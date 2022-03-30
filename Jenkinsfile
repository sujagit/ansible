pipeline {
    agent any
    stages {
       stage('copy file to ansible') {
           steps {
               script {
                   echo  "copy file to ansible server"
                   sshagent(['ansible-ssh-key']) {
                       sh "scp -o StrictHostKeyChecking=no ansible/* root@104.131.60.77:/root"
                       withCredentials([sshUserPrivateKey(credentialsId:'ansible-ssh-key',keyFileVariable:'keyfile',usernameVariable:'user')]) {
                           sh "scp -o StrictHostKeyChecking=no $keyfile root@104.131.60.77:/root/sshkey.pem"
                       }

                   }

               }
           }

       }

       stage('execute ansible scripts') {
           steps {
               script {

                    echo  "execute ansible scripts"
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = "104.131.60.77"
                    remote.allowAnyHosts = true

                    withCredentials([sshUserPrivateKey(credentialsId:'ansible-ssh-key',keyFileVariable:'keyfile',usernameVariable:'user')]) {
                           remote.user = user
                           remote.identityFile = keyfile
                           sshCommand remote: remote, command: "ansible-playbook deploy-docker.yaml"
                       }
                    
                   

               }
           }

       }
    }   
}