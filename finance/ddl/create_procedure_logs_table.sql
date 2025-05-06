CREATE TABLE IF NOT EXISTS finance.procedure_logs (
    procedure_name STRING,
    input_params STRING,
    executed_at TIMESTAMP_NTZ
);