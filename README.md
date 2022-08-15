# demo_project
<h2>Project description</h2>

This repo contains Wordpress application deployment for my demo project at SoftServe DevOps Crash Course 2021.

<h2>Project pre-requisites</h2>

Installed Jenkins, Docker, Kubernetes, Helm, AWS CLI, AWS Authenticator, Terraform, Datadog, Slack.

<h2>Project structure</h2>

k8s folder contains manifests files, that is used by Jenkins to deploy the app.

Dockerfile custom Wordpress docker image build on latest version.

sonar-project.properties is config file for SonarQube project for this application.

<h3>Jenkinsfile contains pipeline with a following stages:</h3>
    <ul><li>Checkout GitHub</li>
    <li>Check the code with SonarQube
    <li>Build Docker image
    <li>Scaning image with Trivy for vulneriabilities
    <li>Push image to the registry
    <li>Deploy application to the cluster
    <li>Send notification to respective Slack channel</ul>
    
<h3>Jenkinsfile-WP contains pipeline with a following stages:</h3>
    <ul><li>Deploy application to the cluster
    <li>Send notification to respective Slack channel</ul>
    
<h3>Jenkinsfile-Datadog contains pipeline with a following stages:</h3>
   <ul> <li>Deploy DataDog for monitoring infrastructure to AWS EKS cluster using Helm with kubeconfig new context after terraform deployment.</ul>

The pipeline is triggered automatically by code change, via webhook from GitHub to Jenkins.



