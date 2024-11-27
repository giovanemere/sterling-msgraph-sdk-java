pipeline {
    agent any
    tools {
        maven 'maven_jenkins'
        jdk 'java_temurin_17_0_12'
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