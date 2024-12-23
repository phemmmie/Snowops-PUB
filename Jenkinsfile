pipeline {
    agent any
    environment {
        SNOWCLI_VERSION = "1.1.0"
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
        stage('Install SnowCLI') {
            steps {
                // Install SnowCLI and make sure it's accessible
                sh '''
                python3 -m pip install --upgrade pip
                python3 -m pip install snowcli==${SNOWCLI_VERSION}

                # Get the path to SnowCLI
                SNOWCLI_PATH=$(python3 -m site --user-base)/bin
                echo "Adding SnowCLI path: $SNOWCLI_PATH to PATH"
                export PATH=$SNOWCLI_PATH:$PATH

                # Test if snow is accessible
                snow --version
                '''
            }
        }
        stage('Setup Snowflake Authentication') {
            steps {
                // Configure SnowCLI for Snowflake Authentication
                sh '''
                SNOWCLI_PATH=$(python3 -m site --user-base)/bin
                export PATH=$SNOWCLI_PATH:$PATH

                snow configure set account ${SNOWFLAKE_ACCOUNT}
                snow configure set user ${SNOWFLAKE_USER}
                snow configure set role ${SNOWFLAKE_ROLE}
                snow configure set warehouse ${SNOWFLAKE_WAREHOUSE}
                snow configure set database ${SNOWFLAKE_DATABASE}
                snow configure set schema ${SNOWFLAKE_SCHEMA}
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
                        SNOWCLI_PATH=$(python3 -m site --user-base)/bin
                        export PATH=$SNOWCLI_PATH:$PATH
                        
                        snow sql -f ${file}
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

