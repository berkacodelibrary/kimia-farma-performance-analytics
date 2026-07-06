/*
Project     : Kimia Farma Performance Analytics
Author      : Berka Ridha

Description :
File ini berisi query untuk melakukan validasi dashboard yang sudah di bangun di looker studio.

Dashboard Metrics:
1. Total Transactions
2. Total Net Sales
3. Total Net Profit
4. Revenue & Profit Trend
5. Top Provinces
6. Branch Rating Analysis
7. Branch Category Distribution
*/

-- KPI Summary
SELECT
    COUNT(transaction_id) AS total_transactions,
    SUM(nett_sales) AS total_nett_sales,
    SUM(nett_profit) AS total_nett_profit
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi`;

-- Top 10 Provinces by Total Transactions
SELECT
    provinsi,
    COUNT(transaction_id) AS total_transactions
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi`
GROUP BY provinsi
ORDER BY total_transactions DESC
LIMIT 10;

-- Top 10 Provinces by Net Sales
SELECT
    provinsi,
    SUM(nett_sales) AS total_nett_sales
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi`
GROUP BY provinsi
ORDER BY total_nett_sales DESC
LIMIT 10;

