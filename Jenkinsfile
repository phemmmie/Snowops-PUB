pipeline {
    agent any
    environment {
        SNOWSQL_PATH = '/Applications/SnowSQL.app/Contents/MacOS'
        PATH = "${SNOWSQL_PATH}:${env.PATH}"
        SNOWSQL_CONFIG_PATH = '/Users/oluwafemisobakin/.snowsql/config'
    }
    parameters {
        choice(name: 'DEPARTMENT', choices: ['finance', 'data_analyst', 'marketing', 'hr'], description: 'Department to manage tables')
        text(name: 'TABLE_NAMES', defaultValue: '', description: 'Comma-separated table names to create (optional)')
        text(name: 'DATA_TABLES', defaultValue: '', description: 'Comma-separated table names to insert data into (optional)')
    }
    stages {
        // ... [Existing DDL stages] ...

        stage('Execute Data Inserts') {
            when {
                expression { params.DATA_TABLES?.trim() }
            }
            steps {
                script {
                    echo "Running data inserts for ${params.DEPARTMENT} department..."
                    
                    def tables = params.DATA_TABLES.split(/,/).collect { it.trim() }
                    
                    tables.each { tableName ->
                        def sqlFile = "${params.DEPARTMENT}/DML/insert_${tableName}_data.sql"
                        
                        if (fileExists(sqlFile)) {
                            echo "Executing ${sqlFile}..."
                            try {
                                sh """
                                    snowsql --config ${env.SNOWSQL_CONFIG_PATH} \\
                                            -f "${sqlFile}"
                                """
                            } catch (Exception e) {
                                error "Failed to execute ${sqlFile}: ${e.message}"
                            }
                        } else {
                            error "DML file ${sqlFile} not found in workspace!"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed.'
            cleanWs()
        }
        success {
            echo '✅ Tables and data created successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}