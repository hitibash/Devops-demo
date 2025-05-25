pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }
    
    environment {
        IMAGE_NAME = "hitibash/devops-demo"
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/hitibash/Devops-demo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Run Tests') {
            steps {
                withCredentials([file(credentialsId: 'ENV_DB_CRED', variable: 'ENV_FILE')]) {
                    sh '''
                        cp "$ENV_FILE" .env || exit 1
                        docker compose up --build --abort-on-container-exit --exit-code-from test
                        docker compose down --volumes --remove-orphans
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                script {
                    sh '''
                        docker run --rm \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            aquasec/trivy:latest image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:latest || true

                        docker run --rm \
                            -v $(pwd):/src \
                            aquasec/trivy:latest fs --scanners secret /src
                    '''
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh "docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }
        stage('Deploy to K3s') {
            steps {
                sh '''
                    kubectl apply -f k3s/configmap.yaml
                    kubectl apply -f k3s/deployment.yaml
                    kubectl apply -f k3s/service.yaml
                '''
            }
        }

    }
}
