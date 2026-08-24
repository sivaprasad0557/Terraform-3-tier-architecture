pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '657566734724'

        FRONTEND_ECR = '657566734724.dkr.ecr.us-east-1.amazonaws.com/three-tier-frontend'
        BACKEND_ECR  = '657566734724.dkr.ecr.us-east-1.amazonaws.com/three-tier-backend'

        EKS_CLUSTER = 'task9-cluster'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }

        stage('Check Tools') {
            steps {
                sh 'docker --version'
                sh 'aws --version'
                sh 'kubectl version --client'
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                sh 'docker build -t ${FRONTEND_ECR}:${IMAGE_TAG} "./Frontend deployment"'
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                sh 'docker build -t ${BACKEND_ECR}:${IMAGE_TAG} "./Backenddeployment"'
            }
        }

        stage('Test') {
            steps {
                sh '''
                    cd Backenddeployment
                    npm install
                    npm test --if-present
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin \
                    ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh 'docker push ${FRONTEND_ECR}:${IMAGE_TAG}'
                sh 'docker push ${BACKEND_ECR}:${IMAGE_TAG}'
            }
        }

        stage('Connect to EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                    --region ${AWS_REGION} \
                    --name ${EKS_CLUSTER}

                    kubectl get nodes
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/backend-service.yaml
                    kubectl apply -f k8s/frontend-service.yaml
                    kubectl apply -f k8s/backend-deployment.yaml
                    kubectl apply -f k8s/frontend-deployment.yaml

                    kubectl set image deployment/backend \
                    backend=${BACKEND_ECR}:${IMAGE_TAG}

                    kubectl set image deployment/frontend \
                    frontend=${FRONTEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Kubernetes Deployment') {
            steps {
                sh 'kubectl get deployments'
                sh 'kubectl get pods -o wide'
                sh 'kubectl get services'
            }
        }

        stage('Rollout Status') {
            steps {
                sh 'kubectl rollout status deployment/backend --timeout=180s'
                sh 'kubectl rollout status deployment/frontend --timeout=180s'
            }
        }

        stage('Application Health Check') {
            steps {
                sh 'kubectl get endpoints backend-service'
                sh 'kubectl get endpoints frontend-service'
            }
        }
    }

    post {
        success {
            echo 'CI/CD PIPELINE COMPLETED SUCCESSFULLY'
        }

        failure {
            echo 'CI/CD PIPELINE FAILED - CHECK CONSOLE OUTPUT'
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
