pipeline {
    agent any
    environment {
        SNOWSQL_CONFIG_PATH = '/Users/Shared/.snowsql'
    }
    stages {
        stage('Setup Environment') {
            steps {
                echo 'Installing SnowSQL via Homebrew...'
                sh '''
                if ! command -v snowsql &> /dev/null; then
                    # Ensure Homebrew is installed
                    if ! command -v brew &> /dev/null; then
                        echo "Installing Homebrew..."
                        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    fi

                    echo "Installing SnowSQL..."
                    brew install --cask snowflake-snowsql
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

