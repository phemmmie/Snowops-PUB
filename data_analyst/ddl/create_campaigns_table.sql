CREATE TABLE IF NOT EXISTS finance.campaigns (
  campaign_id VARCHAR(255) PRIMARY KEY,
  campaign_name VARCHAR(255),
  start_date DATE,
  end_date DATE,
  budget DECIMAL(18, 2)
);