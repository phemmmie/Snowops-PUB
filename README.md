git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/phemmmie/Snowops-PUB.git
git push -u origin main



considering my directory structure has SnowOps-PUB/finance/DDL with a file namd create_departments_table.sql
with the below code
CREATE TABLE IF NOT EXISTS finance.departments_ops (
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
i choose finance as department and Table_name as departments when i run the pipeline i get the following error
+ snowsql --config null -f finance/ddl/create_departments_table.sql
File 'null' does not exist.
Try "snowsql --help" for more information.
script returned exit code 2

I created a new file name create_departments_campaign.sql in this directory SnowOps-PUB/finance/DDL and this file create_departments_campaign.sql
has the below SQL code 
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
when i run the pipeline this table was not created in snowflake