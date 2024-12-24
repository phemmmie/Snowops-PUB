pipeline {
    agent any
    environment {
        SNOWFLAKE_ACCOUNT = 'uluiluz-oo62075'
        SNOWFLAKE_USER = 'DEBO2577'
        SNOWFLAKE_ROLE = 'ACCOUNTADMIN'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'PEDWUK_TB'
        SNOWFLAKE_SCHEMA = 'DDE_OPS'
    }
    stages {
        stage('Checkout SQL Scripts from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/phemmmie/Snowops-PUB.git',
                    credentialsId: 'github-credentials'
            }
        }
        stage('Install SnowSQL via Homebrew') {
            steps {
                sh '''
                # Install Homebrew if not already installed
                if ! command -v brew &> /dev/null; then
                    echo "Installing Homebrew..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                fi
                
                # Install SnowSQL using Homebrew
                if ! command -v snowsql &> /dev/null; then
                    echo "Installing SnowSQL..."
                    brew install --cask snowflake-snowsql
                else
                    echo "SnowSQL is already installed."
                fi

                # Verify SnowSQL installation
                snowsql --version
                '''
            }
        }
        stage('Configure SnowSQL') {
            steps {
                sh '''
                # Create or overwrite SnowSQL configuration file
                mkdir -p ~/.snowsql
                cat <<EOF > ~/.snowsql/config
[connections]
accountname = ${SNOWFLAKE_ACCOUNT}
username = ${SNOWFLAKE_USER}
rolename = ${SNOWFLAKE_ROLE}
warehousename = ${SNOWFLAKE_WAREHOUSE}
dbname = ${SNOWFLAKE_DATABASE}
schemaname = ${SNOWFLAKE_SCHEMA}
EOF
                chmod 600 ~/.snowsql/config
                '''
            }
        }
        stage('Execute SQL Statements') {
            steps {
                script {
                    // List all SQL files in the workspace
                    def sqlFiles = sh(script: 'ls *.sql || echo ""', returnStdout: true).trim().split('\n')
                    if (sqlFiles.size() == 0 || sqlFiles[0] == "") {
                        echo "No SQL files found in the workspace."
                        error "Execution stopped: No SQL files to process."
                    }
                    for (file in sqlFiles) {
                        echo "Executing ${file}"
                        sh """
                        snowsql -f ${file}
                        """
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for details.'
        }
    }
}

