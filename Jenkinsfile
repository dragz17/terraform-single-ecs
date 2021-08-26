pipeline {
    agent{
        label 'slave-tf'
    }
    environment {
        repoURL = 'git@github.com:dragz17/terraform-single-ecs.git'
        ALICLOUD_ACCESS_KEY = credentials('alicloud_accesskey')
        ALICLOUD_SECRET_KEY = credentials('alicloud_secretkey')
    }
    stages {
        stage ('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[credentialsId: 'github-dragz17', url: env.repoURL]]])
            }
        }
    
        stage('TF Init&Plan') {
            steps {
              sh 'terraform init'
              sh 'terraform plan'
            }      
        }

        stage('TF Apply') {
            steps {
            sh 'terraform apply -auto-approve'
            }
        }
        
        stage('upload tfstate'){
            steps{
                sh "ossutil cp terraform.tfstate oss://sre-automation-config/terraform/tfstate/${env.JOB_NAME}"
            }
        }

        stage ('Delete the tfstate') {
            steps {
                script{
                    sh 'rm -rf terraform.tfstate'
                }
            }
        }
        
    }
    
}


