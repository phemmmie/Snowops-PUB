pipeline {
    agent any
    environment {
        // Use Jenkins credentials binding for secure config (if needed)
        SNOWSQL_PATH = '/Applications/SnowSQL.app/Contents/MacOS'
        PATH = "${SNOWSQL_PATH}:${env.PATH}"
        // Optional: Store config path in credentials store (example shown below)
        // SNOWSQL_CONFIG_PATH = credentials('snowsql-config-path') 
    }
    parameters {
        choice(name: 'DEPARTMENT', choices: ['finance', 'data_analyst', 'marketing', 'hr'], description: 'Select department')
        text(name: 'TABLE_NAMES', defaultValue: 'departments,employees,budget', description: 'Comma-separated table names to create')
    }
    stages {
        stage('Verify Prerequisites') {
            steps {
                script {
                    echo 'Checking SnowSQL installation...'
                    sh '''
                        echo "PATH: $PATH"
                        which snowsql || { echo "SnowSQL not found"; exit 1; }
                        snowsql --version
                    '''
                    
                    echo 'Validating department directory structure...'
                    def departmentDir = "${params.DEPARTMENT}/ddl"
                    if (!fileExists(departmentDir)) {
                        error "Department directory ${departmentDir} not found in repository!"
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
        
        stage('Execute Batch SQL Scripts') {
            steps {
                script {
                    echo "Processing tables for ${params.DEPARTMENT} department..."
                    
                    // Convert comma-separated string to list
                    def tables = params.TABLE_NAMES.split(/,/).collect { it.trim() }
                    
                    tables.each { tableName ->
                        def sqlFile = "${params.DEPARTMENT}/ddl/create_${tableName}_table.sql"
                        
                        if (fileExists(sqlFile)) {
                            echo "Executing ${sqlFile}..."
                            try {
                                sh """
                                    snowsql --config ${env.SNOWSQL_CONFIG_PATH} \\
                                            -f ${sqlFile}
                                """
                            } catch (Exception e) {
                                error "Failed to execute ${sqlFile}: ${e.message}"
                            }
                        } else {
                            error "SQL file ${sqlFile} not found in workspace!"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed.'
            cleanWs() // Clean workspace after execution
        }
        success {
            echo 'All SQL scripts executed successfully!'
            // Add Slack/Email notification here if needed
            // notifySuccess()
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
            // notifyFailure()
        }
    }
}