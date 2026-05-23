
-- step 3: Assigning deciles (10=best, 1=worst)
CREATE OR REPLACE VIEW `rfm4040.sales.rfm_scores`
AS
SELECT 
  *,
  NTILE(10) OVER(ORDER BY r_rank DESC) AS r_score,
  NTILE(10) OVER(ORDER BY f_rank DESC) AS f_score,
  NTILE(10) OVER(ORDER BY m_rank DESC) AS m_score
FROM `rfm4040.sales.rfm_metrics`;


-- step 4: total score
CREATE OR REPLACE VIEW `rfm4040.sales.rfm_total_score`
AS
SELECT 
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  (r_score + f_score + m_score) AS rfm_total_score
FROM `rfm4040.sales.rfm_scores`
ORDER BY rfm_total_score DESC;