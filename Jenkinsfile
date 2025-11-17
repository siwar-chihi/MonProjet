pipeline {
    agent any
    options { timestamps() }
    environment {
        IMAGE = 'siwarchihi/monapp'  // ← Mettez VOTRE username Docker Hub
        TAG = "build-${env.BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps { 
                checkout scm 
            }
        }
        
        stage('Docker Build') {
            steps {
                bat 'docker version'
                bat "docker build -t %IMAGE%:%TAG% ."
            }
        }
        
        stage('Smoke Test') {
            steps {
                bat """
                    docker rm -f monapp_test 2>nul || ver > nul
                    docker run -d --name monapp_test -p 8081:80 %IMAGE%:%TAG%
                    ping -n 5 127.0.0.1 > nul
                    docker rm -f monapp_test
                """
            }
        }
        
        stage('Push (Docker Hub)') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'siwarchihi',
                    passwordVariable: 'papa dali 2016')]) {
                    bat """
                        echo %PASS% | docker login -u %USER% --password-stdin
                        docker tag %IMAGE%:%TAG% %IMAGE%:latest
                        docker push %IMAGE%:%TAG%
                        docker push %IMAGE%:latest
                    """
                }
            }
        }
    }
    
    post {
        success { echo 'Build+Test+Push OK ✅' }
        failure { echo 'Build/Tests/Push KO ❌' }
    }
}
