-- Purpose: Process loan metrics with logging
CREATE OR REPLACE PROCEDURE finance.metrics(loan_id STRING, schedule_id STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
    var result = `Processing loan: ${loan_id}, Schedule: ${schedule_id}`;
    
    // Optional: Insert into a log table
    var sql = `
        INSERT INTO finance.procedure_logs (
            procedure_name, input_params, executed_at
        ) VALUES (
            'metrics', 
            'loan_id: ${loan_id}, schedule_id: ${schedule_id}',
            CURRENT_TIMESTAMP()
        )
    `;
    
    try {
        snowflake.execute({sqlText: sql});
        return `Success: ${result}`;
    } catch (err) {
        return `Error: ${err.message}`;
    }
$$;