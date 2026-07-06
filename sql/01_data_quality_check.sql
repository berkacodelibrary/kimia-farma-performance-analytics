/*
Project     : Kimia Farma Performance Analytics
Author      : Berka Ridha
Description : Data Quality Check

Objective:
Melakukan validasi kualitas sumber dataset sebelum melakukan data transformasi dan analisis.

Checks Performed:
1. Duplicate transaction_id
2. Unmatched product_id
3. Unmatched branch_id
4. Invalid price or rating values
5. Missing value
*/

-- 1. Check Duplicate Transaction ID
SELECT
    transaction_id,
    COUNT(*) AS total_duplicate
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction`
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- 2. Check Unmatched Product ID
SELECT DISTINCT
    t.product_id
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction` AS t
LEFT JOIN `berka-rakamin-kf-analytics.kimia_farma.kf_product` AS p
       ON t.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 3. Check Unmatched Branch ID
SELECT DISTINCT
    t.branch_id
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction` AS t
LEFT JOIN `berka-rakamin-kf-analytics.kimia_farma.kf_kantor_cabang` AS b
       ON t.branch_id = b.branch_id
WHERE b.branch_id IS NULL;


-- 4. Check Invalid Price or Rating
SELECT
    COUNT(*) AS invalid_rows
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction`
WHERE price IS NULL
   OR price <= 0
   OR rating IS NULL;

-- 5. Check Missing Values
SELECT
    COUNTIF(transaction_id IS NULL) AS missing_transaction_id,
    COUNTIF(date IS NULL) AS missing_date,
    COUNTIF(branch_id IS NULL) AS missing_branch_id,
    COUNTIF(product_id IS NULL) AS missing_product_id,
    COUNTIF(customer_name IS NULL) AS missing_customer_name,
    COUNTIF(price IS NULL) AS missing_price,
    COUNTIF(discount_percentage IS NULL) AS missing_discount,
    COUNTIF(rating IS NULL) AS missing_rating
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction`;