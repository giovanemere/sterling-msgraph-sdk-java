pipeline {
    agent any
    tools {
        maven 'maven_jenkins'
        jdk 'java_temurin_17_0_12'
    }
    environment {
        //Use Pipeline Utility Steps plugin to read information from pom.xml into env variables
        IMAGE = readMavenPom().getArtifactId()
        VERSION = readMavenPom().getVersion()
    }
    stages {
        stage ('Build') {
            steps {
                // using the Pipeline Maven plugin we can set maven configuration settings, publish test results, and annotate the Jenkins console
                withMaven(options: [findbugsPublisher(), junitPublisher(ignoreAttachments: false)]) {
                sh 'mvn clean findbugs:findbugs package'
                }
            }
            post {
                success {
                    // we only worry about archiving the jar file if the build steps are successful
                    archiveArtifacts(artifacts: '**/target/*.jar', allowEmptyArchive: true)
                }
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
                sh 'mkdir -p target/surefire-reports'
            }
        }
    }
}