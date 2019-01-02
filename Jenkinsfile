#!groovy
import java.io.File;
import java.io.IOException;

devEmailId =   "vasudev.ramisetti@gmail.com"
qaEmailId =    "vasudev.ramisetti@gmail.com"

waitingTime = 48
branchName = env.BRANCH_NAME

if ( branchName == 'master' || branchName == 'development') {

  node('RHEL7-LABLE') {
    //Java and maven path setup
    env.JAVA_HOME="${tool 'jdk-1.8'}"
    env.PATH="${JAVA_HOME}/bin:${PATH}"
    env.PATH = "${tool 'maven-default'}/bin:${env.PATH}"
    // defining artifactory configurations
    def server = Artifactory.server('artifacts')

   try {

  stage 'Clone Code'

          deleteDir()
          checkout scm
          repositoryURL = sh(script: 'git config remote.origin.url', returnStdout: true).trim()
          echo "${repositoryURL}"
          repositoryName = sh (script: "echo ${repositoryURL} | rev | cut -d '.' -f2 | cut -d '/' -f1 | rev ", returnStdout: true).trim()
          echo "${repositoryName}"

          buildversion = sh(
          script: "mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version|grep -Ev '(^\\[|Download|Downloading|Downloaded\\w+:)'",
          returnStdout: true
          )


   stage 'Build'

          sh "mvn compile"

   stage 'Test'

          sh "mvn test"

stage 'package'

          sh "mvn package"


//Uploading artifacts to Jfrog artifactory
   stage 'Upload artifacts to Dev'

     def rtMaven = Artifactory.newMavenBuild()
     rtMaven.deployer server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
   //  rtMaven.resolver server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
     def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'clean install -Dmaven.test.skip=true'
     server.publishBuildInfo buildInfo

     stage 'Tower stage approval'
       try{
         notifyDev2deploy()
               proceedConfirmation("proceed1","Deploy app into server ?")
             }
              catch(e) {
              notifyBuild('ABORTED')
              throw e;
             }



 // //To deploy on led01506 server
  stage 'Tower template execution'

      towerdeploy("Skynet-Prepod", "Skynet-Prepod", "Dev-1", "dev")


      }
        catch(e) {
        notifyBuild('FAILED')
        throw e;
        }

    }

  } else {
        echo "Aborted: Please run this build under master or development branch"
      }


      def towerdeploy(String jobTemplateName, String inventoryName, String groupName, String repoName)  {
      sh "echo ${buildversion}"
      extraVars = "{'VERSION': '${buildversion}' , 'REPO': '${repoName}'}"
      ansibleTower(
      towerServer: 'tower',
      templateType: 'job',
      jobTemplate: "${jobTemplateName}",
      importTowerLogs: true,
      inventory: "${inventoryName}",
      limit: "${groupName}",
      removeColor: false,
      verbose: true,
      credential: '',
      extraVars:"${extraVars}"

          )

      }

//Email notification when build failed
def notifyBuild(String buildStatus = 'FAILED') {
def toList = devEmailId
def subject = "${repositoryName}: ${buildStatus}: Job name: '${env.JOB_NAME}' Build Number: '[${env.BUILD_NUMBER}]'"
def summary = "${subject} (${env.BUILD_URL})"
def details = """
    <p>Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
    <p>Build Status is failed.To Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>

                """
    emailext body: details,mimeType: 'text/html', subject: subject, to: toList
    }


     def notifyDev2deploy (String buildStatus = 'STARTED') {
      // build status of null means successful
      buildStatus =  buildStatus ?: 'SUCCESSFUL'
      def toList = devEmailId
      def subject = "${repositoryName}: Artifact is ready to deploy on led01510 server."
      def summary = "${subject} (${env.BUILD_URL})"
      def details = """
        <p> Artifact 'skynet-${buildversion}.jar' was successfully deployed on led01506 server. Now artifacts is ready to deploy on led01510 server </p>
        <p>Click here Approve. "<a href="${env.BUILD_URL}/input">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>

           """
    emailext body: details,mimeType: 'text/html', subject: subject, to: toList

    }


 def proceedConfirmation(String id, String message) {
    def userInput = true
    def didTimeout = false

    try {
    timeout(time: waitingTime, unit: 'HOURS') { //
    userInput = input(
    id: "${id}", message: "${message}", parameters: [
    [$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Confirm to proceed !']
          ])
        }

      }

       catch(e) { // timeout reached or input false
       def user = e.getCauses()[0].getUser()
       if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
       didTimeout = true
       if (didTimeout) {
            echo "no input was received abefore timeout"
            currentBuild.result = "FAILURE"
            throw e
        } else if (userInput == true) {
           echo "this was successful"

            } else {
              userInput = false
              echo "this was not successful"
              currentBuild.result = "FAILURE"
              println("catch exeption. currentBuild.result: ${currentBuild.result}")
              throw e
              }

          }  	else {
              userInput = false
              echo "Aborted by: [${user}]"
              throw e
              }

          }

    }






//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pipeline {
//
//    agent { label 'RHEL7-LABLE' }
//    //agent { label 'master-jenkins' }
//    // agent any
//     tools {
//         maven 'maven-default'
//         jdk 'jdk-1.8'
//     }
//     environment {
//         JAVA_HOME = "${tool 'jdk-1.8'}"
//         PATH = "${JAVA_HOME}/bin:${PATH}"
//
//     }
//
//     options {
//         disableConcurrentBuilds()
//     }
//
//     parameters {
//         choice(choices: 'SNAPSHOT\nRELEASE', description: 'What type of build?', name: 'BUILD')
//     }
//
//     stages {
//         stage('clonecode') {
//             steps {
//                 script {
//                     deleteDir()
//                     checkout scm
//                     sh 'git checkout ${GIT_BRANCH}'
//                     sh 'echo ${GIT_BRANCH}'
//                 }
//             }
//         }
//
//         stage('package') {
//             when {
//                 expression { params.BUILD == 'SNAPSHOT' }
//             }
//             steps {
//                 script {
//
//                sh "mvn package -Dmaven.test.skip=true"
//
//                 }
//             }
//         }
//
//         stage('snapshot') {
//             when {
//                 expression { params.BUILD == 'SNAPSHOT' }
//             }
//             steps {
//                 script {
//                     def server = Artifactory.server('artifacts')
//                     def rtMaven = Artifactory.newMavenBuild()
//                     rtMaven.deployer server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
//                   //  rtMaven.resolver server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
//                     def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'clean install -Dmaven.test.skip=true'
//                     server.publishBuildInfo buildInfo
//
//                 }
//             }
//         }
//
//
//
//       /*  stage('release') {
//             when {
//                 expression { params.BUILD == 'RELEASE' }
//             }
//             steps {
//             sshagent(credentials: ['scmaccess_ssh']) {
//                     script {
//                         sh 'git checkout ${GIT_BRANCH}'
//                         def server = Artifactory.server('artifacts')
//                         def rtMaven = Artifactory.newMavenBuild()
//                         rtMaven.deployer.deployArtifacts = false
//                         rtMaven.deployer server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
//                       //  rtMaven.resolver server: server, releaseRepo: 'libs-release', snapshotRepo: 'libs-snapshot'
//                         def buildInfo = rtMaven.run pom: 'pom.xml', goals: 'release:clean release:prepare release:perform -Dgoals=install -Dmaven.test.skip=true'
//                         buildInfo = rtMaven.run pom: 'target/checkout/pom.xml', goals: 'clean install -Dmaven.test.skip=true'
//                         rtMaven.deployer.deployArtifacts buildInfo
//                         server.publishBuildInfo buildInfo
//
//                     }
//
//                     }
//             }
//
//         }  */
//
//     }
// }
