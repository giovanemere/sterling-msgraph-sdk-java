pipeline {
    agent any
    tools {
        maven 'maven_jenkins'
        jdk 'java_temurin_17_0_12'
    }
    environment {
        env.JfrogServerID="ConnJfrogDevSecOps"
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
        stage('Publish Artifactory') {
            steps {
                script {
                    // Upload Artifactory
                    rtUpload (  serverId: JfrogServerID,
                        spec: '''{ "files": [ {  
                            "pattern": $WORKSPACE/target/*.jar, 
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