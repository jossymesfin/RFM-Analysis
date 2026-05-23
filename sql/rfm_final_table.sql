-- step 5: BI ready rfm segment table
CREATE OR REPLACE TABLE `rfm4040.sales.rfm_segment_final`
AS
SELECT 
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_total_score,
  CASE
    WHEN rfm_total_score >= 28 THEN "Champions" --28-30
    WHEN rfm_total_score >= 24 THEN "Loyal VIPs"
    WHEN rfm_total_score >= 20 THEN "Potential Loyalits"
    WHEN rfm_total_score >= 16 THEN "Promising"
    WHEN rfm_total_score >= 12 THEN "Engaged"
    WHEN rfm_total_score >= 8 THEN "Required Attention"
    WHEN rfm_total_score >= 4 THEN "At Risk"
    ELSE "Lost/Inactive"
  END AS rfm_segment  
FROM `rfm4040.sales.rfm_total_score`
ORDER BY rfm_total_score;
