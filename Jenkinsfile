pipeline {

    agent any

    stages{

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarScanner'
            }
            steps{
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }           

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
                    }
                }
        }

        stage('Create docker image') {
            steps {
                echo ' ============== start building image =================='
                dir ('docker') {
                    sh 'docker build -t yok007/wordpress:latest . '
                }
            }
        }

        stage('Scan with trivy') {
            steps {
                sh 'trivy --no-progress --exit-code 0 --severity HIGH,CRITICAL yok007/wordpress:latest'
            }
        }

        stage("Docker login") {
            steps {
                echo " ============== docker login =================="
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                    docker login -u $USERNAME -p $PASSWORD
                    """
                }
            }
        }

        stage('Docker push') {
            steps {
                echo ' ============== start pushing image =================='
                    sh '''docker push yok007/wordpress:latest'''
            }
        }

        stage('Slack') {
            steps {
                slackSend message: 'test message'
            }
        }
    }
}
