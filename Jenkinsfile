pipeline {
    agent any
    tools {
        maven 'maven_jenkins'
        jdk 'java_temurin_17_0_12'
    }
    stages {
        stage ('Build') {
            steps {
                sh 'mvn -version'
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
                sh 'mkdir -p target/surefire-reports'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
    }
}