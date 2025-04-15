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
