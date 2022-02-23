// Pipeline starts from GitHub Webhook.
// SonarQube for scaning code from GitHub repository.
// Building custom docker image.
// Trivy for scaning docker container (artifact) for vulneriabilities.
// Pushing artifact to docker registry for continuous deployment.
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
                echo ' ============== quality gate for code =================='
                timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
                    }
                }
        }

        stage('Create docker image') {
            steps {
                echo ' ============== start building image =================='
                dir ('docker') {
                    sh 'docker build -t yok007/wordpress:demo . '
                }
            }
        }

        stage('Scan with trivy') {
            steps {
                echo ' ============== start scaning image for vulneriabilities =================='
                sh 'trivy --no-progress --exit-code 0 --severity HIGH,CRITICAL yok007/wordpress:demo'
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
                    sh '''docker push yok007/wordpress:demo'''
            }
        }

    }
    post {
        success {
            slackSend color: 'good', message: "Good job: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
        failure {
            slackSend color: 'danger', message: "Job failed: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
  }
}
