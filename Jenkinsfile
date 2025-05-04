pipeline {
    agent any
    environment {
        SNOWSQL_PATH = '/Applications/SnowSQL.app/Contents/MacOS'
        PATH = "${SNOWSQL_PATH}:${env.PATH}"
        SNOWSQL_CONFIG_PATH = '/Users/oluwafemisobakin/.snowsql/config'
    }
    parameters {
        // Existing parameters
        choice(name: 'DEPARTMENT', choices: ['finance', 'data_analyst', 'marketing', 'hr'], description: 'Department to manage tables')
        text(name: 'TABLE_NAMES', defaultValue: '', description: 'Comma-separated table names to create (optional)')
        text(name: 'DATA_TABLES', defaultValue: '', description: 'Comma-separated table names to insert data into (optional)')
        
        // New parameters for stored procedures
        booleanParam(name: 'EXECUTE_PROCEDURE', defaultValue: false, description: 'Should we execute the metrics stored procedure?')
        string(name: 'LOAN_ID', defaultValue: 'DA00000892356', description: 'Loan ID for metrics processing')
        string(name: 'SCHEDULE_ID', defaultValue: 'SCHD_00010', description: 'Schedule ID for metrics processing')
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/phemmmie/Snowops-PUB.git'
            }
        }

        stage('Create Stored Procedure (If Needed)') {
            when {
                expression { fileExists("${params.DEPARTMENT}/DDL/PROCEDURES/create_procedure_metrics.sql") }
            }
            steps {
                script {
                    echo "Creating stored procedure..."
                    def sqlFile = "${params.DEPARTMENT}/DDL/PROCEDURES/create_procedure_metrics.sql"
                    
                    sh """
                        snowsql --config ${env.SNOWSQL_CONFIG_PATH} \\
                                -f "${sqlFile}"
                    """
                }
            }
        }

        stage('Create Tables') {
            when {
                expression { params.TABLE_NAMES?.trim() }
            }
            steps {
                script {
                    def tables = params.TABLE_NAMES.split(/,/).collect { it.trim() }
                    
                    tables.each { tableName ->
                        def sqlFile = "${params.DEPARTMENT}/DDL/create_${tableName}_table.sql"
                        
                        if (fileExists(sqlFile)) {
                            sh """
                                snowsql --config ${env.SNOWSQL_CONFIG_PATH} \\
                                        -f "${sqlFile}"
                            """
                        } else {
                            error "DDL file ${sqlFile} not found!"
                        }
                    }
                }
            }
        }

        stage('Insert Data') {
            when {
                expression { params.DATA_TABLES?.trim() }
            }
            steps {
                script {
                    def tables = params.DATA_TABLES.split(/,/).collect { it.trim() }
                    
                    tables.each { tableName ->
                        def sqlFile = "${params.DEPARTMENT}/DML/insert_${tableName}_data.sql"
                        
                        if (fileExists(sqlFile)) {
                            sh """
                                snowsql --config ${env.SNOWSQL_CONFIG_PATH} \\
                                        -f "${sqlFile}"
                            """
                        } else {
                            error "DML file ${sqlFile} not found in workspace!"
                        }
                    }
                }
            }
        }

        stage('Call Stored Procedure') {
            when {
                expression { params.EXECUTE_PROCEDURE }
            }
            steps {
                script {
                    echo "Calling stored procedure with parameters:"
                    echo "LOAN_ID: ${params.LOAN_ID}"
                    echo "SCHEDULE_ID: ${params.SCHEDULE_ID}"
                    
                    try {
                        // Construct and execute the CALL command
                        sh """
                            echo "CALL finance.metrics('${params.LOAN_ID}', '${params.SCHEDULE_ID}');" \\
                                | snowsql --config ${env.SNOWSQL_CONFIG_PATH}
                        """
                    } catch (Exception e) {
                        error "Stored procedure call failed: ${e.message}"
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
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs for details.'
        }
    }
}