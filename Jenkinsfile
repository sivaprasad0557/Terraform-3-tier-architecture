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
                    echo "===== Docker ====="
                    docker --version

                    echo "===== AWS CLI ====="
                    aws --version

                    echo "===== kubectl ====="
                    kubectl version --client
                '''
            }
        }

        stage('Check AWS Account') {
            steps {
                sh '''
                    echo "===== AWS ACCOUNT ====="
                    aws sts get-caller-identity

                    echo "===== AWS REGION ====="
                    aws configure get region
                '''
            }
        }

        stage('Check EKS Cluster') {
            steps {
                sh '''
                    echo "Checking EKS cluster..."

                    aws eks describe-cluster \
                        --region ${AWS_REGION} \
                        --name ${EKS_CLUSTER} \
                        --query 'cluster.name' \
                        --output text
                '''
            }
        }

        stage('Check ECR Repositories') {
            steps {
                sh '''
                    echo "Checking frontend ECR repository..."

                    aws ecr describe-repositories \
                        --repository-names three-tier-frontend \
                        --region ${AWS_REGION}

                    echo "Checking backend ECR repository..."

                    aws ecr describe-repositories \
                        --repository-names three-tier-backend \
                        --region ${AWS_REGION}
                '''
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                sh '''
                    echo "Building frontend Docker image..."

                    docker build \
                        -t ${FRONTEND_ECR}:${IMAGE_TAG} \
                        "./Frontend deployment"
                '''
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                sh '''
                    echo "Building backend Docker image..."

                    docker build \
                        -t ${BACKEND_ECR}:${IMAGE_TAG} \
                        "./Backenddeployment"
                '''
            }
        }

        stage('Test Backend') {
            steps {
                sh '''
                    echo "Running backend tests..."

                    cd Backenddeployment

                    npm install

                    npm test --if-present
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    echo "Logging in to Amazon ECR..."

                    aws ecr get-login-password \
                        --region ${AWS_REGION} | \
                    docker login \
                        --username AWS \
                        --password-stdin \
                        ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Push Frontend Image') {
            steps {
                sh '''
                    echo "Pushing frontend image..."

                    docker push ${FRONTEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push Backend Image') {
            steps {
                sh '''
                    echo "Pushing backend image..."

                    docker push ${BACKEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Connect to EKS') {
            steps {
                sh '''
                    echo "Updating kubeconfig..."

                    aws eks update-kubeconfig \
                        --region ${AWS_REGION} \
                        --name ${EKS_CLUSTER}

                    echo "===== Kubernetes Nodes ====="

                    kubectl get nodes
                '''
            }
        }

        stage('Deploy Kubernetes Services') {
            steps {
                sh '''
                    echo "Applying backend service..."

                    kubectl apply -f k8s/backend-service.yaml

                    echo "Applying frontend service..."

                    kubectl apply -f k8s/frontend-service.yaml
                '''
            }
        }

        stage('Deploy Kubernetes Applications') {
            steps {
                sh '''
                    echo "Applying backend deployment..."

                    kubectl apply -f k8s/backend-deployment.yaml

                    echo "Applying frontend deployment..."

                    kubectl apply -f k8s/frontend-deployment.yaml
                '''
            }
        }

        stage('Update Backend Image') {
            steps {
                sh '''
                    echo "Updating backend image..."

                    kubectl set image deployment/backend \
                        backend=${BACKEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Update Frontend Image') {
            steps {
                sh '''
                    echo "Updating frontend image..."

                    kubectl set image deployment/frontend \
                        frontend=${FRONTEND_ECR}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Deployments') {
            steps {
                sh '''
                    echo "===== DEPLOYMENTS ====="

                    kubectl get deployments

                    echo "===== PODS ====="

                    kubectl get pods -o wide

                    echo "===== SERVICES ====="

                    kubectl get services
                '''
            }
        }

        stage('Backend Rollout Status') {
            steps {
                sh '''
                    echo "Checking backend rollout..."

                    kubectl rollout status \
                        deployment/backend \
                        --timeout=180s
                '''
            }
        }

        stage('Frontend Rollout Status') {
            steps {
                sh '''
                    echo "Checking frontend rollout..."

                    kubectl rollout status \
                        deployment/frontend \
                        --timeout=180s
                '''
            }
        }

        stage('Application Health Check') {
            steps {
                sh '''
                    echo "===== BACKEND ENDPOINTS ====="

                    kubectl get endpoints backend-service

                    echo "===== FRONTEND ENDPOINTS ====="

                    kubectl get endpoints frontend-service

                    echo "===== FINAL POD STATUS ====="

                    kubectl get pods
                '''
            }
        }
    }

    post {
        success {
            echo '''
==========================================
CI/CD PIPELINE COMPLETED SUCCESSFULLY
==========================================
'''
        }

        failure {
            echo '''

'''
        }

        always {
            echo 'Pipeline execution completed.'
        }
    }
}
