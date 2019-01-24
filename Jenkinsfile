pipeline {
  agent any
  stages {
    stage('TF Init') {
      parallel {
        stage('TF Init') {
          steps {
            sh 'terraform init'
          }
        }
        stage('Source Env') {
          steps {
            sh 'source ~/kuberc'
          }
        }
      }
    }
    stage('Tf Plan') {
      steps {
        sh 'terraform plan -out osp_stack'
      }
    }
    stage('Tf Apply') {
      steps {
        sh '''terraform apply -input=false osp_stack
'''
      }
    }
    stage('Tf Destroy') {
      steps {
        sh 'terraform destroy -input=false'
      }
    }
  }
  environment {
    OS_USERNAME = 'osev3'
    OS_PROJECT_ID = 'f5ce3b24704f45cb9b6fa54248315d6b'
    OS_PROJECT_NAME = 'OpenShitfv3'
    OS_PASSWORD = 'ocp1234!'
    OS_REGION_NAME = 'regionOne'
    OS_INTERFACE = 'public'
    OS_INDENTITY_API_VERSION = '2'
  }
}