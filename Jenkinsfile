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
        stage('Clone GitHub Repository') {
            steps {
                echo 'Cloning the SnowOps-PUB repository...'
                git branch: 'main', url: 'https://github.com/phemmmie/Snowops-PUB.git'
            }
        }
        stage('List Files in Workspace') {
            steps {
                echo 'Listing files in the current workspace to check for SQL file...'
                sh 'ls -R'
            }
        }
        stage('Execute SnowSQL Script') {
            steps {
                echo 'Executing SQL script on Snowflake...'
                script {
                    // Path to your SQL file
                    def sqlFile = 'snow_create.sql' // The SQL file to execute
                    def sqlFilePath = "${pwd()}/${sqlFile}" // Absolute path to the file
                    
                    // Check if the SQL file exists
                    if (fileExists(sqlFilePath)) {
                        echo "Executing ${sqlFilePath}..."
                        sh """
                        snowsql --config $SNOWSQL_CONFIG_PATH \
                                --account <your_account> \
                                --username <your_username> \
                                --password <your_password> \
                                --warehouse <your_warehouse> \
                                --database <your_database> \
                                --schema <your_schema> \
                                --execute @${sqlFilePath}
                        """
                    } else {
                        error "SQL file ${sqlFile} not found in the workspace!"
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
            echo 'SQL script executed successfully!'
        }
        failure {
            echo 'Pipeline execution failed. Check the logs for details.'
        }
    }
}

