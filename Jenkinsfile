pipeline {
    agent any
    environment {
        SNOWSQL_PATH = '/Applications/SnowSQL.app/Contents/MacOS'
        PATH = "${SNOWSQL_PATH}:${env.PATH}" // Prepend SnowSQL path to ensure it's available
        SNOWSQL_CONFIG_PATH = '/Users/oluwafemisobakin/.snowsql/config' // Path to your SnowSQL config file
    }
    parameters {
        string(name: 'DEPARTMENT', defaultValue: 'finance', description: 'Department name')
        string(name: 'TABLE_NAME', defaultValue: 'departments', description: 'Table name to create')
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
                    // Construct the SQL file path dynamically based on department and table name
                    def sqlFile = "finance/ddl/create_${params.TABLE_NAME}_table.sql"
                    def sqlFilePath = "${pwd()}/${sqlFile}" // Absolute path to the file
                    
                    // Check if the SQL file exists
                    if (fileExists(sqlFilePath)) {
                        echo "Executing ${sqlFilePath}..."
                        sh """
                        snowsql --config $SNOWSQL_CONFIG_PATH \
                                -f ${sqlFilePath}
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
