node {
    stage('Checkout') {
        echo 'Checking out the code...'
        checkout scm
    }

    stage('Compile') {
        echo 'Compiling Sample.java...'
        sh 'ls -l'
        sh 'javac Sample.java'
    }

    stage('Run') {
        echo 'Running Sample.java...'
        sh 'java Sample'
    }
}
