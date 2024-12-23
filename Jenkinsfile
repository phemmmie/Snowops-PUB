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
                // Checkout SQL files from GitHub
                git branch: 'main',
                    url: 'https://github.com/phemmmie/Snowops-PUB.git'
            }
        }
        stage('Setup Virtual Environment and Install SnowCLI') {
            steps {
                // Create and activate a virtual environment, then install SnowCLI
                sh '''
                python3 -m venv venv
                source venv/bin/activate

                # Upgrade pip and install SnowCLI
                pip install --upgrade pip
                pip install snowcli

                # Test SnowCLI installation
                venv/bin/snow --version
                '''
            }
        }
        stage('Setup Snowflake Authentication') {
            steps {
                // Configure SnowCLI for Snowflake Authentication
                sh '''
                source venv/bin/activate

                # Use SnowCLI to configure authentication
                venv/bin/snow configure set account ${SNOWFLAKE_ACCOUNT}
                venv/bin/snow configure set user ${SNOWFLAKE_USER}
                venv/bin/snow configure set role ${SNOWFLAKE_ROLE}
                venv/bin/snow configure set warehouse ${SNOWFLAKE_WAREHOUSE}
                venv/bin/snow configure set database ${SNOWFLAKE_DATABASE}
                venv/bin/snow configure set schema ${SNOWFLAKE_SCHEMA}
                '''
            }
        }
        stage('Execute SQL Statements') {
            steps {
                script {
                    // Execute all SQL files in the repository
                    def sqlFiles = sh(script: 'ls *.sql', returnStdout: true).trim().split('\n')
                    for (file in sqlFiles) {
                        echo "Executing ${file}"
                        sh '''
                        source venv/bin/activate
                        venv/bin/snow sql -f ${file}
                        '''
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
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
