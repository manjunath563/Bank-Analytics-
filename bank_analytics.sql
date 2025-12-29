create database bank_analytics;
use bank_analytics;
select * from `bank _data_analystics`;

-------------- Drop unnecessary Columns-----------------
ALTER TABLE `bank _data_analystics`
DROP COLUMN `ï»¿ State Abbr`,
DROP COLUMN `Account ID`,
DROP COLUMN `BH Name`,
DROP COLUMN `Bank Name`,
DROP COLUMN `Branch Name`,
DROP COLUMN `Close Client`,
DROP COLUMN `Center Id`,
DROP COLUMN `Client id`,
DROP COLUMN `Credif Officer Name`,
DROP COLUMN `Delinq 2 Yrs`,
DROP COLUMN `Age _T`,
DROP COLUMN `Disb By`,
DROP COLUMN `Gender ID`,
DROP COLUMN `Loan Transferdate`,
DROP COLUMN `Application Type`,
DROP COLUMN `Sub Grade`,
DROP column `Grrade`,
DROP COLUMN `State Abbr`,
DROP COLUMN `Tranfer Logic`,
DROP COLUMN `Is Delinquent Loan`,
DROP COLUMN `Is Default Loan`,
DROP COLUMN `Term`;

select * from `bank _data_analystics`;

--------------- 1. Total Loan Applications------------
SELECT COUNT(*) AS total_loan_applications
FROM `bank _data_analystics`;

---------------- 2. Total Funded Amount -------------------
SELECT 
    CONCAT(ROUND(SUM(`Funded Amount`) / 1000000, 2), 'M') AS total_funded_amount
FROM `bank _data_analystics`;

------------------ 3. Loans by Age Group ---------------
SELECT Age, COUNT(*) AS total
FROM `bank _data_analystics`
GROUP BY Age;

--------------------------- 4. 10. Yearly Disbursement------------------
SELECT `Disbursement Date (Years)` AS fy_year,
       COUNT(*) AS loans_disbursed,
       SUM(`Funded Amount`) AS total_disbursed_amount
FROM `bank _data_analystics`
GROUP BY `Disbursement Date (Years)`
ORDER BY fy_year;


-------------------- 5) Loan Status Summary -------------------
SELECT `Loan Status`, COUNT(*) AS total
FROM `bank _data_analystics`
GROUP BY `Loan Status`;

---------------- 6. Loans by City (Top 10 Cities)------------------
SELECT City, COUNT(*) AS total_loans
FROM `bank _data_analystics`
GROUP BY City
ORDER BY total_loans DESC
LIMIT 10;

------------------ 7.Loan Status Summary--------
SELECT `Loan Status`, COUNT(*) AS total
FROM `bank _data_analystics`
GROUP BY `Loan Status`;

------------- 8. Average Recovery per Loan------------------
SELECT ROUND(AVG(`Recoveries`), 2) AS avg_recovery_per_loan
FROM `bank _data_analystics`;

----------------------- 9. Loans by Caste-------------------
SELECT Caste, COUNT(*) AS total_loans
FROM `bank _data_analystics`
GROUP BY Caste;

---------------- Advance Queries -----------
------------- 1) Year-over-Year (YoY) Growth — Funded Amount-------------------
SELECT 
    `Disbursement Date (Years)` AS FY,
    ROUND(SUM(`Funded Amount`) / 1000000, 2) AS funded_M,
    ROUND(
        (SUM(`Funded Amount`) -
        LAG(SUM(`Funded Amount`)) OVER (ORDER BY `Disbursement Date (Years)`))
        / LAG(SUM(`Funded Amount`)) OVER (ORDER BY `Disbursement Date (Years)`) 
        * 100, 2
    ) AS YoY_Growth_Percentage
FROM `bank _data_analystics`
GROUP BY FY
ORDER BY FY;


---------------------- 2) City-wise Recovery Performance Ranking --------------------
SELECT 
    City,
    ROUND(SUM(`Recoveries`) / SUM(`Funded Amount`), 2) AS recovery_ratio,
    RANK() OVER (ORDER BY ROUND(SUM(`Recoveries`) / SUM(`Funded Amount`), 2) DESC) AS rank_no
FROM `bank _data_analystics`
GROUP BY City
ORDER BY recovery_ratio DESC;

---------------- 3) Caste-wise Portfolio Quality-------------
SELECT 
    Caste,
    COUNT(*) AS total_loans,
    SUM(`Total Rec Prncp`) AS principal_received,
    SUM(`Funded Amount`) AS principal_funded,
    ROUND(SUM(`Total Rec Prncp`) / SUM(`Funded Amount`), 3) AS collection_efficiency
FROM `bank _data_analystics`
GROUP BY Caste
ORDER BY collection_efficiency ASC;

------------------ 4) Age Group Risk Score------------------
SELECT 
    Age,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN `Loan Status` != 'Fully Paid' THEN 1 END) AS defaults,
    ROUND(SUM(CASE WHEN `Loan Status` != 'Fully Paid' THEN 1 END) / COUNT(*) * 100, 2) AS risk_score
FROM `bank _data_analystics`
GROUP BY Age
ORDER BY risk_score DESC;


------------ 5) Top 10 Most Profitable Clients -----------------
SELECT 
    `Client Name`,
    ROUND(SUM(`Total Pymnt`) - SUM(`Funded Amount`), 2) AS profit
FROM `bank _data_analystics`
GROUP BY `Client Name`
ORDER BY profit DESC
LIMIT 10;

------------------- 6) Home Ownership Impact on Default ----------------
SELECT 
    `Home Ownership`,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN `Loan Status` != 'Fully Paid' THEN 1 ELSE 0 END) AS defaults,
    ROUND(SUM(CASE WHEN `Loan Status` != 'Fully Paid' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS default_rate_percent
FROM `bank _data_analystics`
GROUP BY `Home Ownership`
ORDER BY default_rate_percent DESC;


