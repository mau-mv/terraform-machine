pipeline {
    agent any

    environment {
	AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AZURE_CLIENT_ID = credentials('azure-client-id')
        AZURE_CLIENT_SECRET = credentials('azure-client-secret')
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id')
        AZURE_TENANT_ID = credentials('azure-tenant-id')    
	}

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/mau-mv/terraform-machine.git'
            }
        }
        stage('Initialize Terraform') {
            steps {
		sh 'pwd'
                sh 'terraform init -upgrade'
            }
        }
        stage('Validate Terraform') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('Plan Terraform') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Apply Terraform') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}


