node {
    stage('Checkout') {
        // This step ensures Jenkins pulls the Git repo contents (e.g., Sample.java)
        checkout scm
    }

    stage('Compile') {
        echo 'Compiling Sample.java...'
        sh 'ls -l'                 // List files to confirm Sample.java is present
        sh 'javac Sample.java'     // Compile the Java file
    }

    stage('Run') {
        echo 'Running Sample...'
        sh 'java Sample'           // Run the compiled Java class
    }
}
