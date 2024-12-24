pipeline {
    agent any
    environment {
        SNOWSQL_PATH = '/Applications/SnowSQL.app/Contents/MacOS'
        PATH = "${SNOWSQL_PATH}:${env.PATH}" // Prepend SnowSQL path to ensure it's available
        SNOWSQL_CONFIG_PATH = '/Users/Shared/.snowsql' // Adjust if your SnowSQL config is in a different path
    }
    stages {
        stage('Verify SnowSQL Installation') {
            steps {
                echo 'Checking SnowSQL installation...'
                sh '''
                echo "PATH: $PATH"
                which snowsql
                snowsql --version
                '''
            }
        }
        stage('Clone SQL Repository') {
            steps {
                echo 'Cloning GitHub repository with SQL scripts...'
                git branch: 'main', url: 'https://github.com/phemmmie/Snowops-PUB.git'
            }
        }
        stage('Execute SQL Scripts') {
            steps {
                echo 'Executing SQL scripts on Snowflake...'
                script {
                    // List all SQL files
                    def sqlFiles = sh(script: 'find sql -type f -name "*.sql"', returnStdout: true).trim().split("\n")
                    
                    // Execute each SQL file
                    sqlFiles.each { sqlFile ->
                        sh """
                        snowsql --config $SNOWSQL_CONFIG_PATH \
                                --account <your_account> \
                                --username <your_username> \
                                --password <your_password> \
                                --warehouse <your_warehouse> \
                                --database <your_database> \
                                --schema <your_schema> \
                                --execute @${sqlFile}
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed.'
        }
        success {
            echo 'All SQL scripts executed successfully!'
        }
        failure {
            echo 'Pipeline execution failed. Check the logs for details.'
        }
    }
}

