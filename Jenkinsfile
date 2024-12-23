pipeline {
    agent any
    environment {
        SNOWCLI_VERSION = "1.1.0" // Specify the desired SnowCLI version
        SNOWFLAKE_ACCOUNT = 'OO62075'
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
                // Install SnowCLI
                sh '''
                pip install --upgrade pip3
                pip install snowcli
                '''
            }
        }
        stage('Setup Snowflake Authentication') {
            steps {
                // Configure SnowCLI for Snowflake Authentication
                sh '''
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
                        sh "snow sql -f ${file}"
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

