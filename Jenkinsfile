pipeline {

    agent any

    tools {
        maven 'maven_jenkins'
        jdk 'java_temurin_17_0_12'
    }

    environment {
        ServerJfrog = "https://artifactory.edtech.com.co/artifactory"
        JfrogServerID = "ConnJfrogDevSecOps"
    }

    stages {
        stage ('Build') {
            steps {
                sh 'mvn -version'
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
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
        stage ("Publish Artifactory"){
            when { expression { "${disableJfrog}" == '1' } }
            steps {
                script { 
                    // Construccion de Variables
                        env.JfrogURL = "${ServerJfrog}/DevSecOps/SCCOLSFG/sfg_o365_cf/Artifact/"
                        echo "JfrogURL: ${env.JfrogURL}"
                    // Upload Artifactory
                     rtUpload (  serverId: JfrogServerID,
                                spec: '''{ "files": [ {  
                                    "pattern": "$WORKSPACE/target/O365InboxAttachmentToDisk 5.2.0.jar", 
                                    "target": "DevSecOps/SCCOLSFG/sfg_o365_cf/Artifact/", 
                                    "recursive": "false" 
                                    } 
                                    ] }'''
                            )
                }
            }
        }
    }
    }
}