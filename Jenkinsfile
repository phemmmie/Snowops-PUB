pipeline {
    agent any
    environment {
        SNOWSQL_VERSION = "latest" // Ensure this version exists
        SNOWSQL_CONFIG_FILE = ".snowsql" // Default configuration file location
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
        stage('Install SnowSQL') {
            steps {
                sh '''
                # Install SnowSQL if not already installed
                if ! command -v snowsql &> /dev/null; then
                    echo "Installing SnowSQL..."
                    curl -O https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/snowsql.dmg
                    hdiutil attach snowsql.dmg
                    sudo installer -pkg /Volumes/SnowSQL/snowsql.pkg -target /
                    hdiutil detach /Volumes/SnowSQL
                else
                    echo "SnowSQL is already installed."
                fi
                # Verify installation
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

