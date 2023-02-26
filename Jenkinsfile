pipeline {
    agent any

    stages {
        stage('CI') {
            steps {
                git url: 'https://github.com/mostafaG95/python.git', branch: 'main'
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh """
                docker login -u ${USERNAME} -p ${PASSWORD}
                docker build . -f Dockerfile -t mostafag95/projecttt --network host
                docker push mostafag95/projecttt
                pwd
                """
                }
            }
        }
         stage('CD') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                sh """
             
   
                """
                }
            }
        }
    }
}
