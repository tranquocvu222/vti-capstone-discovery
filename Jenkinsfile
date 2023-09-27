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
               script {

                  // Set AWS credentials as environment variables

                   withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}",
                            "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}",
                            "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"]
                            ) {

                   sh '/usr/bin/docker login -u AWS -p $(/usr/bin/aws ecr get-login-password --region ap-northeast-3) 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com'
                   sh '/usr/bin/docker build -t service-discovery-dev .'
                   sh '/usr/bin/docker tag service-discovery-dev:latest 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com/service-discovery-dev:""$BUILD_ID""'
                   sh '/usr/bin/docker push 639136264313.dkr.ecr.ap-northeast-3.amazonaws.com/service-discovery-dev:""$BUILD_ID""'
                  }
               }
           }
        }
     }
}