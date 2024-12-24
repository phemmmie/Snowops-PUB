pipeline {
    agent any
    environment {
        SNOWCLI_VERSION = "0.1.1" // Use a valid version or leave empty for latest
        SNOWFLAKE_ACCOUNT = 'uluiluz-oo62075'
        SNOWFLAKE_USER = 'DEBO2577'
        SNOWFLAKE_ROLE = 'ACCOUNTADMIN'
        SNOWFLAKE_WAREHOUSE = 'COMPUTE_WH'
        SNOWFLAKE_DATABASE = 'PEDWUK_TB'
        SNOWFLAKE_SCHEMA = 'DDE_OPS'
    }
    tools {
        git 'Default' // Use the configured Git installation
    }
    stages {
        stage('Checkout SQL Scripts from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/phemmmie/Snowops-PUB.git',
                    credentialsId: 'your-credentials-id'
            }
        }
        stage('Setup Virtual Environment and Install SnowCLI') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                pip install --upgrade pip
                pip install snowcli==${SNOWCLI_VERSION} || pip install snowcli  # Fallback to latest
                pip list  # Debug: Verify installation
                which snow  # Debug: Locate executable
                snow --version  # Verify SnowCLI installation
                '''
            }
        }
        stage('Setup Snowflake Authentication') {
            steps {
                sh '''
                source venv/bin/activate
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
                    def sqlFiles = sh(script: 'ls *.sql', returnStdout: true).trim().split('\n')
                    for (file in sqlFiles) {
                        echo "Executing ${file}"
                        sh '''
                        source venv/bin/activate
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
