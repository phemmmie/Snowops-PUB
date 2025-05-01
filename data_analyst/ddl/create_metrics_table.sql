-- Purpose: Store key business metrics for analyst reporting and dashboards
-- Usage: Track KPIs like campaign performance, user engagement, revenue targets, etc.

CREATE TABLE IF NOT EXISTS data_analyst.metrics (
    metric_id VARCHAR(255) PRIMARY KEY,          -- Unique identifier for the metric
    metric_name VARCHAR(255) NOT NULL,           -- Human-readable name (e.g., "Monthly Revenue")
    metric_type VARCHAR(100) NOT NULL,           -- Category (e.g., "financial", "user_growth", "campaign")
    value DECIMAL(18, 2) NOT NULL,               -- Metric value (e.g., 15000.00)
    value_type VARCHAR(50) NOT NULL,             -- Type of value (e.g., "currency", "percentage", "count")
    recorded_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(), -- When the metric was recorded
    recorded_by VARCHAR(255) DEFAULT CURRENT_USER(),       -- Who recorded it (e.g., analyst name)
    dimension_1 VARCHAR(255),                    -- Optional dimension (e.g., campaign_id, region)
    dimension_2 VARCHAR(255),                    -- Optional secondary dimension (e.g., product_id)
    source_system VARCHAR(100),                  -- Source of the metric (e.g., CRM, Ads API, Internal Tool)
    description VARCHAR(1024),                   -- Context for analysts
    is_active BOOLEAN DEFAULT TRUE               -- Toggle for obsolete metrics
);

-- Example Index (optional, for faster queries by type/dimension)
CREATE INDEX idx_metric_type ON data_analyst.metrics(metric_type);