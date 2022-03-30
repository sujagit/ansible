pipeline {
    agent any
    stages {
       stage('copy file to ansible') {
           steps {
               script {
                   echo  "copy file to ansible server"
                   sshagent(['ansible-ssh-key']) {
                       sh "scp -o StrictHostKeyChecking=no ansible/* root@104.131.60.77:/root"
                       withCredentials([sshUserPrivateKey(credentialsId:'ec2-ssh-key',keyFileVariable:'keyfile',usernameVariable:'user')]) {
                           sh "scp -o StrictHostKeyChecking=no $keyfile root@104.131.60.77:/root/sshkey.pem"
                       }

                   }

               }
           }

       }
    }   
}