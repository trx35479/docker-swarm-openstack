pipeline {
  agent any
  stages {
    stage('TF Init') {
      steps {
        sh 'terraform init'
      }
    }
    stage('Tf Plan') {
      steps {
        sh 'terraform plan -out osp_stack'
      }
    }
    stage('Tf Apply') {
      steps {
        sh 'terraform apply -input=false osp_stack'
      }
    }
    stage('Tf Destroy') {
      steps {
        sh 'terraform destroy -input=false'
      }
    }
  }
}