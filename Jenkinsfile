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
                sh '''
                    echo "Checking Docker..."
                    docker --version

                    echo "Checking AWS CLI..."
                    aws --version

                    echo "Checking kubectl..."
                    kubectl version --client
                '''
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                sh '''
                    echo "Building Frontend Docker Image..."

                    docker build \
                      -t ${FRONTEND_ECR}:${IMAGE_TAG} \
                      "./Frontend deployment"
                '''
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                sh '''
                    echo "Building Backend Docker Image..."

                    docker build \
                      -t ${BACKEND_ECR}:${IMAGE_TAG} \
                      "./Backenddeployment"
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                    echo "Running backend tests..."

                    cd Backenddeployment

                    npm install

                    npm test --if-present

                    echo "Tests completed successfully."
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    echo "Logging in to AWS ECR..."

                    aws ecr get-login-password \
                      --region ${AWS_REGION} | \
                    docker login \
                      --username AWS \
                      --password-stdin \
                      ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    echo "Pushing Frontend Image..."

                    docker push ${FRONTEND_ECR}:${IMAGE_TAG}

                    echo "Pushing Backend Image..."

                    docker push ${BACKEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Connect to EKS') {
            steps {
                sh '''
                    echo "Connecting to EKS Cluster..."

                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${EKS_CLUSTER}

                    echo "Checking EKS Nodes..."

                    kubectl get nodes
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo "Deploying Kubernetes Services..."

                    kubectl apply -f k8s/backend-service.yaml
                    kubectl apply -f k8s/frontend-service.yaml

                    echo "Deploying Backend..."

                    kubectl apply -f k8s/backend-deployment.yaml

                    echo "Deploying Frontend..."

                    kubectl apply -f k8s/frontend-deployment.yaml

                    echo "Updating Backend Image..."

                    kubectl set image deployment/backend \
                      backend=${BACKEND_ECR}:${IMAGE_TAG}

                    echo "Updating Frontend Image..."

                    kubectl set image deployment/frontend \
                      frontend=${FRONTEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Kubernetes Deployment') {
            steps {
                sh '''
                    echo "Checking Deployments..."

                    kubectl get deployments

                    echo "Checking Pods..."

                    kubectl get pods -o wide

                    echo "Checking Services..."

                    kubectl get services

            echo 'Pipeline execution completed.'
    }
}        }
        always {
        }
        failure {
            echo 'CI/CD PIPELINE FAILED - CHECK CONSOLE OUTPUT'


        }
                    echo "Final Kubernetes Status..."
            echo 'CI/CD PIPELINE COMPLETED SUCCESSFULLY'

                    kubectl get pods
        success {
                    kubectl get services

    post {
                '''
            }

    }
            }
        }
                '''
                    echo "Application health verification completed."
        }

                    kubectl get endpoints frontend-service

            steps {
                sh '''
                    echo "Checking backend endpoints..."
                    kubectl get endpoints backend-service

                    echo "Checking frontend endpoints..."

        stage('Application Health Check') {

                    kubectl rollout status deployment/frontend --timeout=180s

                '''
            }
        }

                    echo "Checking Frontend Rollout..."
        stage('Rollout Status') {
            steps {

                sh '''
                    echo "Checking Backend Rollout..."

                    kubectl rollout status deployment/backend --timeout=180s
