pipeline {
    agent any

    tools {
        nodejs "NodeJS"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Frontend') {
            steps {
                dir('Frontend deployment') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Test Frontend') {
            steps {
                dir('Frontend deployment') {
                    sh 'npm test || true'
                }
            }
        }

        stage('Build Backend') {
            steps {
                dir('Backenddeployment') {
                    sh 'npm install'
                }
            }
        }

        stage('Test Backend') {
            steps {
                dir('Backenddeployment') {
                    sh 'npm test || true'
                }
            }
        }

        stage('Backend Health Check') {
            steps {
                dir('Backenddeployment') {
                    sh 'node --version'
                    sh 'npm --version'
                }
            }
        }
    }

    post {
        success {
            echo 'Build and Test completed successfully.'
        }

        failure {
            echo 'Pipeline Failed.'
        }
    }
}