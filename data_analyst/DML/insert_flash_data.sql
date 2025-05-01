-- Purpose: Insert sample KPI data into the metrics table for analyst reporting

INSERT INTO finance.metrics (
    metric_id, metric_name, metric_type, value, value_type, dimension_1, source_system, description
) VALUES (
    'M-2023-001',
    'July Marketing Campaign Revenue',
    'financial',
    15000.00,
    'currency',
    'Campaign_2023_Q3',
    'CRM',
    'Revenue generated from July marketing campaign'
);

-- Add more inserts if needed
INSERT INTO finance.metrics (
    metric_id, metric_name, metric_type, value, value_type, dimension_1, source_system, description
) VALUES (
    'M-2023-002',
    'Q3 User Growth',
    'user_growth',
    12.5,
    'percentage',
    'Product_A',
    'Analytics_Tool',
    'User growth rate for Product A in Q3'
);