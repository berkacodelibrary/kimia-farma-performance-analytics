/*
Project     : Kimia Farma Performance Analytics
Author      : Berka Ridha

Description :
Membuat tabel analytical dengan menggabungkan tabel transaction, produk, kota cabang
yang nantinya akan di gunakan sebagai sumber data di Looker Studio.

Output Table :
berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi
*/

CREATE TABLE `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi` AS
WITH base AS (
  SELECT
      t.transaction_id,
      t.date,
      b.branch_id,
      b.branch_name,
      b.kota,
      b.provinsi,
      b.rating AS rating_cabang,
      t.customer_name,
      p.product_id,
      p.product_name,
      p.price AS actual_price,
      t.discount_percentage,
      CASE
        WHEN p.price <= 50000 THEN 0.1
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.3
      END AS persentase_gross_laba,
      t.rating AS rating_transaksi
  FROM `berka-rakamin-kf-analytics.kimia_farma.kf_product` p
  JOIN `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction` t ON p.product_id = t.product_id
  JOIN `berka-rakamin-kf-analytics.kimia_farma.kf_kantor_cabang` b ON b.branch_id = t.branch_id
)
SELECT
    transaction_id,
    date,
    branch_id,
    branch_name,
    kota,
    provinsi,
    rating_cabang,
    customer_name,
    product_id,
    product_name,
    actual_price,
    discount_percentage,
    persentase_gross_laba,
    (actual_price - (actual_price * discount_percentage)) AS nett_sales,
    (actual_price - (actual_price * discount_percentage)) * persentase_gross_laba AS nett_profit,
    rating_transaksi
FROM base;

--Validation
SELECT
    (SELECT COUNT(*)
     FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_transaction`)
     AS total_transaction,

    (SELECT COUNT(*)
     FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi`)
     AS total_analytical_data;


-- Check negative Net Sales
SELECT
    COUNT(*) AS negative_nett_sales
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi`
WHERE nett_sales < 0;


-- Check negative Net Profit
SELECT
    COUNT(*) AS negative_nett_profit
FROM `berka-rakamin-kf-analytics.kimia_farma.kf_final_data_aggregasi`
WHERE nett_profit < 0;