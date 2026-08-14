pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '657566734724'

        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

        FRONTEND_REPO = 'three-tier-frontend'
        BACKEND_REPO  = 'three-tier-backend'

        EKS_CLUSTER = 'three-tier-cluster'

        IMAGE_TAG = "${BUILD_NUMBER}"
            ============================================

            Check the Jenkins Console Output
            for the failed stage.

            ============================================
            """
        }

        always {
            sh '''
                echo "Cleaning unused Docker images..."
                docker image prune -f || true
            '''
        }
    }
}
```
    }

    stages {
            PIPELINE FAILED

        stage('Checkout') {
            steps {
        failure {
            echo """
            ============================================
                echo 'Checking out source code...'
                checkout scm
            }
        }


        stage('Verify Files') {
            steps {
                sh '''
                    echo "===== Repository ====="
            Backend Image:
            ============================================
            """
        }
            ${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG}

            EKS Cluster:
            ${EKS_CLUSTER}

            Region:
            ${AWS_REGION}

                    ls -la

                    echo "===== Frontend ====="
                    ls -la "Frontend deployment"

            Frontend Image:
            ${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG}


                    echo "===== Backend ====="
                    ls -la Backenddeployment

                    echo "===== Kubernetes ====="
                    if [ -d k8s ]; then
                        ls -la k8s
                    else
            Build Number: ${BUILD_NUMBER}
                        echo "k8s directory not present in Git repository"
                    fi
                '''
            }
        }

            ============================================

        stage('Create Frontend Dockerfile') {
            steps {
                sh '''
                    cat > "Frontend deployment/Dockerfile" <<'EOF'
        success {
            echo """
            ============================================
            PIPELINE SUCCESS
FROM nginx:alpine

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

    post {

CMD ["nginx", "-g", "daemon off;"]
EOF

                    echo "Frontend Dockerfile created."
                    cat "Frontend deployment/Dockerfile"
                '''
            }

        }

        stage('Create Backend Dockerfile') {
            steps {
                sh '''
            }
        }
    }
                    cat > Backenddeployment/Dockerfile <<'EOF'
FROM node:18-alpine

WORKDIR /app


                    echo "Application test completed."
                '''
COPY package*.json ./
                      -- \
                      curl -f http://backend-service:5000/ || true

RUN npm ci --omit=dev

COPY server.js ./

                      --image=curlimages/curl \
EXPOSE 5000

CMD ["node", "server.js"]
EOF

                    echo "Backend Dockerfile created."
                      -i \
                      --restart=Never \
                    cat Backenddeployment/Dockerfile
                '''
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir('Backenddeployment') {
                    sh '''
                        npm ci
                      --rm \
                    '''
                }
            }
        }

        stage('Build Frontend Docker Image') {
            steps {
                dir('Frontend deployment') {
                    sh """
                        docker build \
                    kubectl run jenkins-test \
                          -t ${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG} \
                          -t ${ECR_REGISTRY}/${FRONTEND_REPO}:latest \
                          .
                    """
                }
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                dir('Backenddeployment') {

                    sh """
                        docker build \
                          -t ${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG} \
                          -t ${ECR_REGISTRY}/${BACKEND_REPO}:latest \
                          .
                    """
                }
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login \
                    --username AWS \
                    --password-stdin ${ECR_REGISTRY}
                '''
                    echo "Testing backend service inside Kubernetes..."
            }
        }

        stage('Push Frontend Image to ECR') {
            steps {
                sh """
                    docker push ${ECR_REGISTRY}/${FRONTEND_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${FRONTEND_REPO}:latest
                """
            }
        }

        stage('Push Backend Image to ECR') {
            steps {
                sh """
                    docker push ${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${BACKEND_REPO}:latest
                """
                sh '''
            }
        }

        stage('Configure kubectl for EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${EKS_CLUSTER}

                    echo "===== EKS Cluster ====="
                    kubectl get nodes
                '''
            }
        }

            steps {
        stage('Check Kubernetes Resources') {
            steps {
                sh '''
                    echo "===== Deployments ====="
                    kubectl get deployments

                    echo "===== Services ====="
                    kubectl get services

                    echo "===== Pods ====="
                    kubectl get pods
                '''

        stage('Application Test') {
            }
        }

        stage('Update Backend Image') {
            steps {
                sh """
                    kubectl set image deployment/backend \
                      backend=${ECR_REGISTRY}/${BACKEND_REPO}:${IMAGE_TAG}

            }
        }
                    kubectl rollout status deployment/backend \
                      --timeout=180s
                """
            }
        }

        stage('Update Frontend Image') {
            steps {
                sh """

                    kubectl rollout status deployment/frontend \

                      --timeout=180s
                '''
                """

            }

        }


        stage('Verify Deployment') {
            steps {

                sh '''

                    echo "===== Deployments ====="
                    kubectl get deployments
                    kubectl rollout status deployment/frontend


                    echo "===== Pods ====="

                    kubectl get pods -o wide


                    echo "===== Services ====="

                    kubectl get services

                    echo "===== Backend Rollout ====="
                    kubectl rollout status deployment/backend

                    echo "===== Frontend Rollout ====="

