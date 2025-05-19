pipeline {
    agent any

    environment {
        IMAGE_NAME = "hitibash/devops-demo"
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds'
    }

    stages {
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
                withCredentials([file(credentialsId: 'env-secret', variable: 'ENV_FILE')]) {
                    sh '''
                        echo "[INFO] Copying .env file from Jenkins secret..."
                        if ! cp "$ENV_FILE" .env; then
                            echo "[ERROR] Could not copy .env"; exit 1
                        fi

                        echo "[INFO] Listing files:"
                        ls -la

                        echo "[INFO] Making run_tests.sh executable..."
                        chmod +x run_tests.sh || (echo "[ERROR] chmod failed"; exit 1)

                        echo "[INFO] Running run_tests.sh"
                        ./run_tests.sh || (echo "[ERROR] Tests failed"; exit 1)
                    '''
                    }

                }
            }
        }


        stage('Trivy Scan') {
            steps {
                script {
                    sh '''
                        echo "[SYSTEM]: Running Trivy image scan..."
                        docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        aquasec/trivy:latest image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:latest || true

                        echo "[SYSTEM]: Running Trivy secret scan..."
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
                        echo "[SYSTEM]: Pushing Docker image to DockerHub..."
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        docker push ${IMAGE_NAME}:latest
                    '''
                }
            }
        }
    }
}
