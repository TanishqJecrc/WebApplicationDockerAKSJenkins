pipeline {
    agent any
    environment {
        ACR_NAME = "acrjenkinsdocker"
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        AZURE_CREDENTIALS_ID = 'azure-service-principal'
        RESOURCE_GROUP = 'rg-jenkins-docker-aks'
        AKS_CLUSTER = 'aks-cluster-docker-jenkins'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/TanishqJecrc/WebApplicationDockerAKSJenkins.git'
            }
        }
         stage('Terraform Init') {
                steps {
                     withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    dir('terraform') {
                        bat 'terraform init'
                    }
                }
                }
          }
          stage('Terraform Plan & Apply') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                dir('terraform') {
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
            }
        }

        stage('Build') {
             steps {
                 dir('WebApplication') {
                     bat 'dotnet publish WebApplication.csproj -c Release -o out'
                    
                 }
                 
             }
         }
         tage('Build Docker Image') {
            steps {
                bat "docker build -t %ACR_LOGIN_SERVER%/webapplication:latest -f WebApplication/Dockerfile WebApplication"
            }
        }
         stage('Login to ACR') {
            steps {
                bat "az acr login --name %ACR_NAME%"
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                bat "docker push %ACR_LOGIN_SERVER%/webapplication:latest"
            }
        }

        stage('Get AKS Credentials') {
            steps {
                bat "az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER% --overwrite-existing"
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat "kubectl apply -f WebApplication/deployment.yaml"
            }
        }

    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
