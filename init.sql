
--- AUTH ---

DROP SEQUENCE IF EXISTS user_credentials_id_seq CASCADE;

DROP TABLE IF EXISTS user_credentials CASCADE;

CREATE TABLE user_credentials (
  id SERIAL,
  username VARCHAR(100),
  user_password VARCHAR,
  oauth2_idp VARCHAR(50),
  user_role VARCHAR(20)
);

INSERT INTO user_credentials (username, user_password, user_role)
VALUES ('user01@domain.com', '$2y$10$R.AVbuzy7f7Vijnj94DF1.7aI8C7V4Zwbf2FWAWk2dCRC3n1iOkbG', 'USER');

INSERT INTO user_credentials (username, user_password, user_role)
VALUES ('user02@domain.com', '$2y$10$SfJCRbSkbM.ObOJHvVCRNuxdrY13loabTM8ROaGW1kBCWJHhI/iZ6', 'USER');

INSERT INTO user_credentials (username, user_password, user_role)
VALUES ('user03@domain.com', '$2y$10$Snb12fzwuYwQY/5zxZTFDer0UK1.RyAVnzCqVVzcF8sF6OF6pdCAm', 'USER');

INSERT INTO user_credentials (username, oauth2_idp, user_role)
VALUES ('user04@gmail.com', 'GOOGLE', 'USER');

--- BUDGETS ---

DROP TABLE IF EXISTS monthly_summary;
DROP TABLE IF EXISTS buckets;
DROP TABLE IF EXISTS budgets;

CREATE TABLE budgets (
    budget_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    total_amount INT,
	is_reserved BOOLEAN DEFAULT FALSE,
	month_year Date,
	notes VARCHAR(255),
    created_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE buckets (
    bucket_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    bucket_name VARCHAR(100) NOT NULL,
    amount_required NUMERIC(10, 2) NOT NULL,
    amount_reserved NUMERIC(10, 2) NOT NULL,
    month_year Date,
	is_reserved BOOLEAN DEFAULT FALSE,
	is_active BOOLEAN DEFAULT FALSE,
    date_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE monthly_summary (
    summary_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    month_year DATE,
    projected_income NUMERIC(10, 2) NOT NULL,
    total_budget_amount NUMERIC(10, 2) NOT NULL
);

INSERT INTO budgets (user_id, category, total_amount, is_reserved, month_year, notes) VALUES
(1, 'Groceries', 150.00, FALSE, '2024-05-01', 'Weekly grocery shopping'),
(1, 'Rent', 1200.00, TRUE, '2024-05-01', 'May rent payment'),
(2, 'Utilities', 200.00, FALSE, '2024-05-01', 'Electricity and water bill'),
(2, 'Internet', 50.00, TRUE, '2024-05-01', 'Monthly internet bill'),
(3, 'Entertainment', 100.00, FALSE, '2024-05-01', 'Movies and dining out'),
(3, 'Savings', 500.00, TRUE, '2024-05-01', 'Monthly savings deposit');

INSERT INTO buckets (user_id, bucket_name, amount_required, amount_reserved, month_year, is_reserved, is_active) VALUES
(1, 'Vacation Fund', 2000.00, 500.00, '2024-05-01', FALSE, TRUE),
(1, 'Emergency Fund', 1000.00, 300.00, '2024-05-01', TRUE, TRUE),
(2, 'Car Maintenance', 500.00, 100.00, '2024-05-01', FALSE, FALSE),
(2, 'Home Improvement', 1500.00, 750.00, '2024-05-01', TRUE, TRUE),
(3, 'New Laptop', 1200.00, 600.00, '2024-05-01', FALSE, TRUE),
(3, 'Health Insurance', 800.00, 400.00, '2024-05-01', TRUE, FALSE);

INSERT INTO monthly_summary (user_id, month_year, projected_income, total_budget_amount) VALUES
(1, '2024-05-01', 7777.00, 1111.00),
(2, '2024-05-01', 9999.00, 3333.00),
(3, '2024-05-01', 9876.00, 999.00);

--- TAX ---

DROP TABLE IF EXISTS tax_brackets CASCADE;
DROP TABLE IF EXISTS standard_deduction CASCADE;
DROP TABLE IF EXISTS capital_gains_tax;
DROP TABLE IF EXISTS filing_status CASCADE;
DROP TABLE IF EXISTS child_tax_credit CASCADE;
DROP TABLE IF EXISTS dependent_care_tax_credit CASCADE;
DROP TABLE IF EXISTS dependent_care_tax_credit_limit CASCADE;
DROP TABLE IF EXISTS earned_income_tax_credit CASCADE;
DROP TABLE IF EXISTS education_tax_credit_aotc CASCADE;
DROP TABLE IF EXISTS education_tax_credit_llc CASCADE;
DROP TABLE IF EXISTS savers_tax_credit CASCADE;
DROP TABLE IF EXISTS state_tax CASCADE;
DROP TABLE IF EXISTS states CASCADE;


CREATE TABLE IF NOT EXISTS child_tax_credit (
  id SERIAL PRIMARY KEY,
  per_qualifying_child INT NOT NULL,
  per_other_child INT NOT NULL,
  income_threshold INT NOT NULL,
  rate_factor DECIMAL(5, 2) NOT NULL DEFAULT 0.05,
  refundable BOOLEAN NOT NULL,
  refund_limit INT NOT NULL,
  refund_rate DECIMAL(5, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS dependent_care_tax_credit (
  id SERIAL PRIMARY KEY,
  income_range INT NOT NULL,
  rate DECIMAL(5, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS dependent_care_tax_credit_limit (
  id SERIAL PRIMARY KEY,
  num_dependents INT NOT NULL,
  credit_limit INT NOT NULL,
  refundable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS earned_income_tax_credit (
  id SERIAL PRIMARY KEY,
  agi_threshold_3children INT NOT NULL,
  agi_threshold_2Children INT NOT NULL,
  agi_threshold_1Children INT NOT NULL,
  agi_threshold_0Children INT NOT NULL,
  amount_3children INT NOT NULL,
  amount_2children INT NOT NULL,
  amount_1children INT NOT NULL,
  amount_0children INT NOT NULL,
  investment_income_limit INT NOT NULL,
  refundable BOOLEAN NOT NULL,
  refund_limit INT NOT NULL,
  refund_rate DECIMAL(5, 2)
);

CREATE TABLE IF NOT EXISTS education_tax_credit_aotc (
  id SERIAL PRIMARY KEY,
  full_credit_income_threshold INT NOT NULL,
  partial_credit_income_threshold INT NOT NULL,
  income_partial_credit_rate DECIMAL(5, 2) NOT NULL,
  max_credit_amount INT NOT NULL,
  full_credit_expenses_threshold INT NOT NULL,
  partial_credit_expenses_threshold INT NOT NULL,
  partial_credit_expenses_rate DECIMAL(5,2) NOT NULL,
  refundable BOOLEAN NOT NULL,
  refund_limit INT NOT NULL,
  refund_rate DECIMAL(5, 2)
);

CREATE TABLE IF NOT EXISTS education_tax_credit_llc (
  id SERIAL PRIMARY KEY,
  full_credit_income_threshold INT NOT NULL,
  partial_credit_income_threshold INT NOT NULL,
  income_partial_credit_rate DECIMAL(5, 2) NOT NULL,
  max_credit_amount INT NOT NULL,
  expenses_threshold INT NOT NULL,
  credit_rate DECIMAL(5, 2) NOT NULL,
  refundable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS savers_tax_credit (
  id SERIAL PRIMARY KEY,
  agi_threshold_first_contribution_limit INT NOT NULL,
  agi_threshold_second_contribution_limit INT NOT NULL,
  agi_threshold_third_contribution_limit INT NOT NULL,
  first_contribution_rate DECIMAL(5, 2) NOT NULL,
  second_contribution_rate DECIMAL(5, 2) NOT NULL,
  third_contribution_rate DECIMAL(5, 2) NOT NULL,
  max_contribution_amount INT NOT NULL,
  refundable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS filing_status (
  id SERIAL PRIMARY KEY,
  status VARCHAR(50) NOT NULL UNIQUE,
  child_tax_credit_id INT NOT NULL,
  earned_income_tax_credit_id INT NOT NULL,
  education_tax_credit_aotc_id INT NOT NULL,
  education_tax_credit_llc_id INT NOT NULL,
  savers_tax_credit_id INT NOT NULL,
  FOREIGN KEY (child_tax_credit_id) REFERENCES child_tax_credit(id),
  FOREIGN KEY (earned_income_tax_credit_id) REFERENCES earned_income_tax_credit(id),
  FOREIGN KEY (education_tax_credit_aotc_id) REFERENCES education_tax_credit_aotc(id),
  FOREIGN KEY (education_tax_credit_llc_id) REFERENCES education_tax_credit_llc(id),
  FOREIGN KEY (savers_tax_credit_id) REFERENCES savers_tax_credit(id)
);

CREATE TABLE IF NOT EXISTS standard_deduction (
  id SERIAL PRIMARY KEY,
  filing_status_id INT NOT NULL,
  deduction_amount INT NOT NULL,
  FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
);

CREATE TABLE IF NOT EXISTS capital_gains_tax (
  id SERIAL PRIMARY KEY,
  filing_status_id INT NOT NULL,
  rate DECIMAL(5, 2) NOT NULL,
  income_range INT NOT NULL,
  FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
);

CREATE TABLE IF NOT EXISTS tax_brackets (
  id SERIAL PRIMARY KEY,
  filing_status_id INT NOT NULL,
  rate DECIMAL(5, 2) NOT NULL,
  min_income INT NOT NULL,
  max_income INT NOT NULL,
  FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
);

CREATE TABLE IF NOT EXISTS states (
  id SERIAL PRIMARY KEY,
  state_name VARCHAR(50),
  state_code VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS state_tax (
  id SERIAL PRIMARY KEY,
  state_id INT NOT NULL,
  income_range INT NOT NULL,
  rate DECIMAL(6, 5) NOT NULL,
  FOREIGN KEY (state_id) REFERENCES states(id)
);

--- TRANSACTIONS ---

DROP TABLE IF EXISTS transaction;

CREATE TABLE transaction (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    vendor_name VARCHAR(100) NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_amount DECIMAL(10, 2) NOT NULL,
    transaction_description VARCHAR(500),
    transaction_category VARCHAR(50) NOT NULL
);
