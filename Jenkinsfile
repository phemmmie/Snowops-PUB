pipeline {
    agent any
    environment {
        // SnowSQL configuration
        SNOWSQL_PATH = '/Applications/SnowSQL.app/Contents/MacOS'
        PATH = "${SNOWSQL_PATH}:${env.PATH}"
        SNOWSQL_CONFIG_PATH = '/Users/oluwafemisobakin/.snowsql/config' // Must exist on Jenkins agent
    }
    parameters {
        choice(name: 'DEPARTMENT', choices: ['finance', 'data_analyst', 'marketing', 'hr'], description: 'Department to manage tables')
        text(name: 'TABLE_NAMES', defaultValue: 'departments', description: 'Comma-separated table names to create')
    }
    stages {
        stage('Verify Prerequisites') {
            steps {
                script {
                    echo 'Checking SnowSQL installation...'
                    sh '''
                        echo "PATH: $PATH"
                        which snowsql || { echo "SnowSQL not found in PATH"; exit 1; }
                        snowsql --version
                    '''

                    echo 'Validating department directory structure...'
                    def departmentDir = "${params.DEPARTMENT}/DDL" // Match your actual case-sensitive directory
                    if (!fileExists(departmentDir)) {
                        error "Directory ${departmentDir} not found! Ensure structure matches department/DDL/"
                    }
                }
            }
        }

        stage('Clone GitHub Repository') {
            steps {
                echo 'Cloning SnowOps-PUB repository...'
                git branch: 'main', url: 'https://github.com/phemmmie/Snowops-PUB.git'
            }
        }

        stage('Execute Snowflake Scripts') {
            steps {
                script {
                    echo "Processing tables for ${params.DEPARTMENT} department..."
                    
                    // Parse comma-separated table names
                    def tables = params.TABLE_NAMES.split(/,/).collect { it.trim() }
                    
                    tables.each { tableName ->
                        def sqlFile = "${params.DEPARTMENT}/DDL/create_${tableName}_table.sql"
                        
                        if (fileExists(sqlFile)) {
                            echo "Executing ${sqlFile}..."
                            try {
                                sh """
                                    # Ensure config file exists
                                    if [ ! -f "${env.SNOWSQL_CONFIG_PATH}" ]; then
                                        echo "Error: SnowSQL config file not found at ${env.SNOWSQL_CONFIG_PATH}"
                                        exit 1
                                    fi

                                    # Execute SnowSQL command
                                    snowsql --config "${env.SNOWSQL_CONFIG_PATH}" \\
                                            -f "${sqlFile}"
                                """
                            } catch (Exception e) {
                                error "Failed to execute ${sqlFile}: ${e.message}"
                            }
                        } else {
                            error "SQL file ${sqlFile} not found in repository!"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed.'
            cleanWs() // Clean workspace to prevent conflicts
        }
        success {
            echo '✅ All SQL scripts executed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}