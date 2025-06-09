pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                echo 'Compiling Sample.java...'
                sh 'javac Sample.java'
            }
        }
        stage('Run') {
            steps {
                echo 'Running Sample...'
                sh 'java Sample'
            }
        }
    }
}

