pipeline {
    agent any
    stages {
        stage('Setup Environment') {
            steps {
                script {
                    // Define environment variables
                    env.SNOWSQL_INSTALLER_URL = 'https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql'
                    env.SNOWSQL_CONFIG_PATH = '/home/jenkins/.snowsql'
                }
            }
            steps {
                echo 'Installing SnowSQL...'
                // Ensure wget is installed and download SnowSQL
                sh '''
                if ! command -v snowsql &> /dev/null; then
                    wget $SNOWSQL_INSTALLER_URL -O /tmp/snowsql && chmod +x /tmp/snowsql && /tmp/snowsql -y
                fi
                '''
                echo 'SnowSQL installation complete.'
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
                    // Load SQL files from the cloned repository
                    def sqlFiles = findFiles(glob: 'sql/**/*.sql')
                    for (sqlFile in sqlFiles) {
                        sh """
                        snowsql --config $SNOWSQL_CONFIG_PATH \
                                --account <your_account> \
                                --username <your_username> \
                                --password <your_password> \
                                --warehouse <your_warehouse> \
                                --database <your_database> \
                                --schema <your_schema> \
                                --execute @${sqlFile.path}
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

