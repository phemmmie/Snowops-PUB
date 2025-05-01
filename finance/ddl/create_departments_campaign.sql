CREATE TABLE IF NOT EXISTS finance.loan_metrics (
 loan_id VARCHAR(255) NOT NULL,
  customer_id VARCHAR(255) NOT NULL,
  loan_amount DECIMAL(18, 2) NOT NULL,
  interest_rate DECIMAL(5, 2) NOT NULL,
  loan_term_months INTEGER NOT NULL,
  loan_start_date DATE NOT NULL,
  loan_end_date DATE NOT NULL,
  loan_status VARCHAR(50) NOT NULL,
  loan_type VARCHAR(100),
  payment_frequency VARCHAR(50),
  principal_balance DECIMAL(18, 2),
  interest_paid DECIMAL(18, 2),
  fees_paid DECIMAL(18,2),
  last_payment_date DATE,
  next_payment_date DATE
);