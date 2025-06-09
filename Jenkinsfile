node {
    stage('Compile') {
        echo '🔍 Listing files in workspace...'
        sh 'ls -l'

        echo '📦 Compiling Sample.java...'
        sh 'javac Sample.java'
    }

    stage('Run') {
        echo '🚀 Running Sample.class...'
        sh 'java Sample'
    }
}
