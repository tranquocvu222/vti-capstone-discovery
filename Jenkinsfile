pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-northeast-3'
        AWS_ACCOUNT_ID = '639136264313'
        ECR_REPO = 'develop-ecr'
        ECR_CREDENTIALS = credentials('aws-ecr-credentials')
    }

    stages {
        stage('Checkout source') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'echo $PATH'
                sh './gradlew test'
            }
        }

        stage('Build') {
            steps {
                sh './gradlew build'
            }
        }

       stage('Build and Push Image to ECR') {
           steps {
            withCredentials([usernamePassword(credentialsId: 'aws-ecr-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                script {
                   sh 'docker login -u AWS -p $(aws ecr get-login-password --region ap-northeast-3) 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com'
                   sh 'docker build -t service-discovery-dev .'
                   sh 'docker tag service-discovery-dev:latest 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com/service-discovery-dev:""$BUILD_ID""'
                   sh 'docker push 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com/service-discovery-dev:""$BUILD_ID""'
                 }
             }
           }
        }
     }
}