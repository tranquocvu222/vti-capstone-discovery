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
                   // Generate a build version based on the current date
                   def buildVersion = new Date().format("yyyyMMdd")

                   // Define the Docker image tag and ECR URL based on the build version
                   def dockerTag = "${ECR_REPO}:${buildVersion}"
                   def ecrUrl = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:${buildVersion}"

                   // Define the cache image name
                   def cacheImage = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_REPO}:cache"

                   // Log in to the ECR repository
                   withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: ECR_CREDENTIALS, secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                       sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                   }

                   // Check if the cache image already exists in the ECR repository
                   def cacheImageExists = sh(script: "aws ecr describe-images --repository-name ${ECR_REPO} --image-ids imageTag=cache", returnStatus: true) == 0
                   if (!cacheImageExists) {
                       // If cacheImage doesn't exist, build it first
                       sh "docker build -t ${cacheImage} ."
                       sh "docker push ${cacheImage}"
                   } else {
                       // If cacheImage exists, pull it to ensure it's up-to-date
                       sh "docker pull ${cacheImage}"
                   }

                   // Build dockerTag with cache from cacheImage
                   sh "docker build --cache-from ${cacheImage} -t ${dockerTag} ."


                   // Push dockerTag to the ECR repository
                   sh "docker push ${ecrUrl}"

                   // Push the updated cache image to the ECR repository
                   sh "docker push ${cacheImage}"

                   // Log out from the ECR repository
                   sh "docker logout ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
               }
           }
        }
     }
}