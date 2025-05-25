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

        stage('CD - Deploy to Kubernetes') {
            steps {
                withCredentials([string(credentialsId: 'k3s_mysql_secrets_yaml', variable: 'MYSQL_SECRET_YAML')]) {
                    sh '''
cp "$MYSQL_SECRET_FILE" k3s/secrets.yaml
sed "s/__BUILD_NUMBER__/$BUILD_NUMBER/" k3s/deployment.template.yaml > k3s/deployment.yaml

kubectl apply -f k3s/secrets.yaml
kubectl apply -f k3s/db_pvc.yaml
kubectl apply -f k3s/db_deployment.yaml
kubectl create configmap create-tables --from-file=sql/create_tables.sql --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f k3s/db_init_job.yaml
kubectl apply -f k3s/deployment.yaml
kubectl apply -f k3s/service.yaml
                    '''
                }
            }
        }
    }
}

