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
        sh '''try {
  terraform apply -input=false osp_stack
} catch (Exception e) {
  terraform destroy -input=false
}'''
        }
      }
      stage('Tf Destroy') {
        steps {
          sh 'terraform destroy -input=false'
        }
      }
    }
  }