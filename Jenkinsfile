pipeline {
    agent any
    
    environment {
        FLUTTER_HOME = 'C:\\Users\\aaron\\flutter\\flutter'
        PATH = "${FLUTTER_HOME}\\bin;${env.PATH}"
        DOCKER_IMAGE = 'quickchat'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Flutter Doctor') {
            steps {
                echo 'Running Flutter doctor...'
                bat 'flutter doctor -v'
            }
        }
        
        stage('Get Dependencies') {
            steps {
                echo 'Getting Flutter dependencies...'
                bat 'flutter pub get'
            }
        }
        
        stage('Analyze') {
            steps {
                echo 'Analyzing code...'
                bat 'flutter analyze'
            }
        }
        
        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                bat 'flutter test'
            }
        }
        
        stage('Build Flutter Web') {
            steps {
                echo 'Building Flutter web application...'
                bat 'flutter build web --release'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                bat """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Stop Previous Container') {
            steps {
                echo 'Stopping previous container if exists...'
                script {
                    bat '''
                        docker ps -a -q --filter "name=quickchat-app" > container.txt
                        set /p CONTAINER_ID=<container.txt
                        if not "%CONTAINER_ID%"=="" (
                            docker stop quickchat-app || echo No container to stop
                            docker rm quickchat-app || echo No container to remove
                        )
                        del container.txt
                    '''
                }
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                bat """
                    docker run -d --name quickchat-app -p 3000:80 --restart unless-stopped ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                bat 'docker ps -f name=quickchat-app'
                echo 'Application deployed successfully at http://localhost:3000'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
            emailext(
                subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                    Good news! The build succeeded.
                    
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                    
                    Application is now running at http://localhost:3000
                """,
                to: '${DEFAULT_RECIPIENTS}'
            )
        }
        failure {
            echo 'Pipeline failed!'
            emailext(
                subject: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """
                    The build failed.
                    
                    Job: ${env.JOB_NAME}
                    Build Number: ${env.BUILD_NUMBER}
                    Build URL: ${env.BUILD_URL}
                    
                    Please check the console output for details.
                """,
                to: '${DEFAULT_RECIPIENTS}'
            )
        }
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
