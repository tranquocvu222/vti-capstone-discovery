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
                   sh 'aws ecr get-login-password --region ap-northeast-3 | docker login --username AWS --password-stdin 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com'
                   sh 'docker build -t develop-ecr .'
                   sh 'docker tag develop-ecr:latest 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com/develop-ecr:""$BUILD_ID""'
                   sh 'docker push 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com/develop-ecr:""$BUILD_ID""'
                 }
             }
           }
        }
     }
}