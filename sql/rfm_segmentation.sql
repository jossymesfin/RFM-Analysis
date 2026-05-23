-- Step 1: Append all tables in to a single table called "sale2025"

CREATE OR REPLACE TABLE `rfm4040.sales.sales_2025` AS
SELECT * FROM `rfm4040.sales.sales202501`
UNION ALL SELECT * FROM `rfm4040.sales.sales202502`
UNION ALL SELECT * FROM `rfm4040.sales.sales202503`
UNION ALL SELECT * FROM `rfm4040.sales.sales202504`
UNION ALL SELECT * FROM `rfm4040.sales.sales202505`
UNION ALL SELECT * FROM `rfm4040.sales.sales202506`
UNION ALL SELECT * FROM `rfm4040.sales.sales202507`
UNION ALL SELECT * FROM `rfm4040.sales.sales202508`
UNION ALL SELECT * FROM `rfm4040.sales.sales202509`
UNION ALL SELECT * FROM `rfm4040.sales.sales202510`
UNION ALL SELECT * FROM `rfm4040.sales.sales202511`
UNION ALL SELECT * FROM `rfm4040.sales.sales202512`;

-- step 2: calculate recency , frequency , monetary ,r,f,m ranks
-- combine views with CTEs
CREATE OR REPLACE VIEW `rfm4040.sales.rfm_metrics`
AS
WITH current_date AS (
  SELECT DATE('2026-03-06') AS analysis_date --today's date
),
rfm AS (
  SELECT 
    CustomerID,
    MAX(OrderDate) AS last_order_date,
    DATE_DIFF((SELECT analysis_date FROM current_date),MAX(OrderDate),DAY) AS recency,
    COUNT(*) AS frequency,
    SUM(OrderValue) AS monetary
    FROM `rfm4040.sales.sales_2025`
    GROUP BY CustomerID
)
SELECT  rfm.*,
        ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
        ROW_NUMBER() OVER(ORDER BY frequency DESC) AS f_rank,
        ROW_NUMBER() OVER(ORDER BY monetary DESC) AS m_rank
FROM rfm;
