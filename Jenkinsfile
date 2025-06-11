pipeline {
    agent any

    stages {
        stage('Terraform Apply') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                      terraform init
                      terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
