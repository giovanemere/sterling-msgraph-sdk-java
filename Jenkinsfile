pipeline {
    agent any
    tools {
        maven 'maven'
        jdk 'openjdk-17.0.12'
    }
    stages {
        stage ('Initialize') {
            steps {
                sh 'mvn -version'
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml' 
                }
            }
        }
    }
}