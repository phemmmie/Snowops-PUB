pipeline {
    agent any
    environment {
        SNOWCLI_VERSION = "0.1.1" // Ensure this version exists
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
        stage('Setup Virtual Environment and Install SnowCLI') {
            steps {
                sh '''
                python3 -m venv venv
                source venv/bin/activate
                export PATH=$VIRTUAL_ENV/bin:$PATH
                pip install --upgrade pip
                if ! pip install --force-reinstall snowcli==${SNOWCLI_VERSION}; then
                    echo "SnowCLI installation failed. Please verify the version."
                    exit 1
                fi
                echo "PATH after activation: $PATH"  # Debug PATH
                ls -l $VIRTUAL_ENV/bin  # Verify the existence of 'snowcli' executable
                if ! [ -x "$VIRTUAL_ENV/bin/snowcli" ]; then
                    echo "SnowCLI executable not found in expected location. Installation might have failed."
                    exit 1
                fi
                $VIRTUAL_ENV/bin/snowcli --version  # Verify SnowCLI installation
                '''
            }
        }
        stage('Setup Snowflake Authentication') {
            steps {
                sh '''
                source venv/bin/activate
                $VIRTUAL_ENV/bin/snowcli configure set account ${SNOWFLAKE_ACCOUNT}
                $VIRTUAL_ENV/bin/snowcli configure set user ${SNOWFLAKE_USER}
                $VIRTUAL_ENV/bin/snowcli configure set role ${SNOWFLAKE_ROLE}
                $VIRTUAL_ENV/bin/snowcli configure set warehouse ${SNOWFLAKE_WAREHOUSE}
                $VIRTUAL_ENV/bin/snowcli configure set database ${SNOWFLAKE_DATABASE}
                $VIRTUAL_ENV/bin/snowcli configure set schema ${SNOWFLAKE_SCHEMA}
                '''
            }
        }
        stage('Execute SQL Statements') {
            steps {
                script {
                    def sqlFiles = sh(script: 'ls *.sql || echo ""', returnStdout: true).trim().split('\n')
                    if (sqlFiles.size() == 0 || sqlFiles[0] == "") {
                        echo "No SQL files found in the workspace."
                        error "Execution stopped: No SQL files to process."
                    }
                    for (file in sqlFiles) {
                        echo "Executing ${file}"
                        sh """
                        source venv/bin/activate
                        $VIRTUAL_ENV/bin/snowcli sql -f ${file}
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

