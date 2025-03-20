pipeline {
    agent any

    environment {
        EMAIL_RECIPIENTS = 'yasoob4825.be23@chitkara.edu.in'  
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/YasoobRashid/6.2CJenkins'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project using Jenkins-configured Maven...'
                withMaven(maven: 'Maven') {
                    sh 'mvn clean package' 
                }
            }
        }

        stage('Unit and Integration Tests') {
            steps {
                echo 'Running unit and integration tests...'
                withMaven(maven: 'Maven') { 
                    sh 'mvn test'
                }
            }
            post {
                always {
                    script {
                        sendEmail("Unit and Integration Tests Completed")
                    }
                }
            }
        }

        stage('Code Analysis') {
            steps {
                echo 'Running code analysis with SonarQube...'
                withMaven(maven: 'Maven') {  
                    withSonarQubeEnv('SonarQube-Local') {  
                        sh 'mvn sonar:sonar'  
                    }
                }
            }
        }


        stage('Security Scan') {
            steps {
                echo 'Performing security scan with OWASP Dependency Check...'
                withMaven(maven: 'Maven') {
                    sh 'mvn dependency-check:check'  
                }
            }
            post {
                always {
                    script {
                        sendEmail("Security Scan Completed")
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo 'Deploying to staging server...'
                sh './deploy_staging.sh'  
            }
        }

        stage('Integration Tests on Staging') {
            steps {
                echo 'Running integration tests on staging...'
                sh 'pytest tests/integration'  
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'Deploying to production server...'
                sh './deploy_production.sh'  
            }
        }
    }

    post {
        success {
            script {
                sendEmail("Pipeline Execution Successful")
            }
        }
        failure {
            script {
                sendEmail("Pipeline Execution Failed")
            }
        }
    }
}

def sendEmail(String stageMessage) {
    emailext(
        subject: "Jenkins Pipeline Notification: ${stageMessage}",
        body: "Pipeline Stage Completed: ${stageMessage}\nCheck Jenkins for details.",
        to: "${EMAIL_RECIPIENTS}"
    )
}
