# 📋 SQL Queries Documentation

## RFM Analysis - Complete SQL Reference Guide

This document provides detailed explanations for each SQL query used in the RFM customer segmentation analysis.

---

## Table of Contents
1. [Overview](#overview)
2. [Query 1: Data Consolidation & RFM Metrics](#query-1-data-consolidation--rfm-metrics)
3. [Query 2: RFM Scoring](#query-2-rfm-scoring)
4. [Query 3: Customer Segmentation](#query-3-customer-segmentation)
5. [Advanced Concepts](#advanced-concepts)
6. [Troubleshooting](#troubleshooting)

---

## Overview

The RFM analysis consists of a 5-step pipeline:

| Step | File | Output | Purpose |
|------|------|--------|---------|
| 1 | rfm_segmentation.sql | sales_2025 | Consolidate monthly sales data |
| 2 | rfm_segmentation.sql | rfm_metrics | Calculate RFM values with ranks |
| 3 | rfm_score.sql | rfm_scores | Assign decile scores (1-10) |
| 4 | rfm_score.sql | rfm_total_score | Combine scores (3-30) |
| 5 | rfm_final_table.sql | rfm_segment_final | Map to 8 segments |

---

## Query 1: Data Consolidation & RFM Metrics

**File**: `sql/rfm_segmentation.sql`

### Part A: Data Consolidation (Lines 1-15)

```sql
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
```

#### Explanation

**Purpose**: Combine 12 monthly sales tables into a single unified dataset

**Why UNION ALL?**
- `UNION ALL` combines rows from multiple tables without removing duplicates
- More efficient than `UNION` (which removes duplicates) since monthly data has no overlaps
- Preserves all transaction records

**Expected Schema**: 
```
- CustomerID (unique customer identifier)
- OrderDate (transaction date)
- OrderValue (transaction amount)
- [other transaction fields]
```

**Usage Notes**:
- Adjust table names if your monthly tables have different naming conventions
- Update year (2025) to match your data year
- Verify all 12 months are included in UNION

---

### Part B: RFM Metrics Calculation (Lines 17-38)

```sql
CREATE OR REPLACE VIEW `rfm4040.sales.rfm_metrics`
AS
WITH current_date AS (
  SELECT DATE('2026-03-06') AS analysis_date  -- today's date
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
```

#### Detailed Breakdown

**CTE 1: current_date**
```sql
WITH current_date AS (
  SELECT DATE('2026-03-06') AS analysis_date
)
```
- Defines the analysis reference date
- **IMPORTANT**: Update this date to your analysis date (or use `CURRENT_DATE()`)
- Used for recency calculation as the "today" reference point

**CTE 2: rfm** - Calculates RFM metrics
```sql
rfm AS (
  SELECT 
    CustomerID,
    MAX(OrderDate) AS last_order_date,           -- Last purchase date
    DATE_DIFF(...,MAX(OrderDate),DAY) AS recency, -- Days since last purchase
    COUNT(*) AS frequency,                        -- Total orders
    SUM(OrderValue) AS monetary                   -- Total spend
    FROM `rfm4040.sales.sales_2025`
    GROUP BY CustomerID
)
```

**Recency Calculation**:
```sql
DATE_DIFF((SELECT analysis_date FROM current_date), MAX(OrderDate), DAY) AS recency
```
- **What it does**: Calculates days between analysis date and last order
- **Formula**: Analysis Date - Last Order Date = Days
- **Lower values = Better** (recent purchases are valuable)
- **Example**: If today is 2026-03-06 and customer last ordered on 2026-03-01:
  - Recency = 5 days (active customer)
  - If customer ordered on 2025-03-06 (1 year ago):
    - Recency = 365 days (at-risk customer)

**Frequency Calculation**:
```sql
COUNT(*) AS frequency
```
- Total number of orders per customer
- **Higher values = Better** (more purchases = loyalty)

**Monetary Calculation**:
```sql
SUM(OrderValue) AS monetary
```
- Total lifetime spending per customer
- **Higher values = Better** (higher spend = more valuable)

**Window Functions for Ranking**:
```sql
ROW_NUMBER() OVER(ORDER BY recency ASC) AS r_rank,
ROW_NUMBER() OVER(ORDER BY frequency DESC) AS f_rank,
ROW_NUMBER() OVER(ORDER BY monetary DESC) AS m_rank
```

- **What it does**: Ranks customers 1 to N
- **r_rank**: 
  - Orders by recency ASCENDING (1 = most recent)
  - Lower rank = more recent = better
- **f_rank**: 
  - Orders by frequency DESCENDING (1 = highest frequency)
  - Rank 1 = most frequent = better
- **m_rank**: 
  - Orders by monetary DESCENDING (1 = highest spender)
  - Rank 1 = highest value = better

**Output Example**:
```
CustomerID | recency | frequency | monetary | r_rank | f_rank | m_rank
-----------|---------|-----------|----------|--------|--------|--------
1001       | 5       | 15        | 5000     | 1      | 5      | 2
1002       | 30      | 8         | 3500     | 50     | 25     | 50
1003       | 365     | 1         | 100      | 5000   | 9999   | 9999
```

---

## Query 2: RFM Scoring

**File**: `sql/rfm_score.sql`

### Part A: Decile Scoring (Lines 1-10)

```sql
CREATE OR REPLACE VIEW `rfm4040.sales.rfm_scores` AS
SELECT 
  *,
  NTILE(10) OVER(ORDER BY r_rank DESC) AS r_score,
  NTILE(10) OVER(ORDER BY f_rank DESC) AS f_score,
  NTILE(10) OVER(ORDER BY m_rank DESC) AS m_score
FROM `rfm4040.sales.rfm_metrics`;
```

#### NTILE Window Function Explained

**What is NTILE(10)?**
- Divides ordered data into 10 equal buckets/tiles
- Each tile receives a number 1-10
- Bucket 10 = best performers
- Bucket 1 = worst performers

**Recency Score** (`NTILE(10) OVER(ORDER BY r_rank DESC)`):
- **ORDER BY r_rank DESC**: Customers with lowest r_rank (most recent) come first
- **Result**: 
  - r_score = 10 for top 10% most recent buyers
  - r_score = 1 for bottom 10% (least recent)
- **Interpretation**: Higher r_score = more recent = valuable

**Frequency Score** (`NTILE(10) OVER(ORDER BY f_rank DESC)`):
- **ORDER BY f_rank DESC**: Customers with lowest f_rank (most frequent) come first
- **Result**: 
  - f_score = 10 for top 10% most frequent buyers
  - f_score = 1 for bottom 10% (least frequent)
- **Interpretation**: Higher f_score = more purchases = loyal

**Monetary Score** (`NTILE(10) OVER(ORDER BY m_rank DESC)`):
- **ORDER BY m_rank DESC**: Customers with lowest m_rank (highest spenders) come first
- **Result**: 
  - m_score = 10 for top 10% highest spenders
  - m_score = 1 for bottom 10% (lowest spenders)
- **Interpretation**: Higher m_score = higher spend = valuable

**Visual Example**:
```
10,000 customers distributed into 10 deciles:

Decile 10: 1,000 customers (top 10%) → Score = 10 ⭐⭐⭐⭐⭐
Decile 9:  1,000 customers        → Score = 9  ⭐⭐⭐⭐
Decile 8:  1,000 customers        → Score = 8  ⭐⭐⭐
...
Decile 2:  1,000 customers        → Score = 2  ⭐
Decile 1:  1,000 customers        → Score = 1  (Lowest performers)
```

---

### Part B: Total RFM Score (Lines 12-26)

```sql
CREATE OR REPLACE VIEW `rfm4040.sales.rfm_total_score` AS
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
```

#### Score Combination Logic

**Formula**:
```
rfm_total_score = r_score + f_score + m_score
```

**Possible Range**: 3 to 30
- **Minimum**: 1 + 1 + 1 = 3 (worst customers)
- **Maximum**: 10 + 10 + 10 = 30 (best customers)

**Distribution Example**:
```
Score Range | Customer Type | % of Base | Business Meaning
------------|---------------|-----------|------------------
28-30       | Champions     | ~1-2%     | Elite high-value
24-27       | Loyal VIPs    | ~5-7%     | Core valuable
20-23       | Potential     | ~10-12%   | Growth opportunity
16-19       | Promising     | ~15-18%   | Converting
12-15       | Engaged       | ~20-25%   | Maintenance needed
8-11        | At Attention  | ~15-20%   | Early warning
4-7         | At Risk       | ~10-12%   | Churn likely
0-3         | Lost/Inactive | ~20-25%   | Dormant
```

**ORDER BY rfm_total_score DESC**:
- Sorts results from highest to lowest scores
- Makes it easy to identify top-tier customers first

**Output Example**:
```
CustomerID | recency | frequency | monetary | r_score | f_score | m_score | rfm_total_score
-----------|---------|-----------|----------|---------|---------|---------|----------------
1001       | 5       | 15        | 5000     | 10      | 10      | 10      | 30 (Champion)
1002       | 10      | 14        | 4800     | 10      | 9       | 10      | 29 (Champion)
1003       | 50      | 8         | 3500     | 8       | 7       | 8       | 23 (Potential)
1004       | 300     | 2         | 500      | 2       | 1       | 1       | 4  (Lost)
```

---

## Query 3: Customer Segmentation

**File**: `sql/rfm_final_table.sql`

```sql
CREATE OR REPLACE TABLE `rfm4040.sales.rfm_segment_final` AS
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
    WHEN rfm_total_score >= 28 THEN "Champions"           --28-30
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
```

#### CASE WHEN Logic

**Purpose**: Maps numerical scores to business-meaningful segment names

**Segment Mapping**:

| Condition | Segment | Score | Strategy |
|-----------|---------|-------|----------|
| `>= 28` | Champions | 28-30 | VIP treatment, exclusive offers |
| `>= 24` | Loyal VIPs | 24-27 | Retention, premium service |
| `>= 20` | Potential Loyalists | 20-23 | Nurture, upsell campaigns |
| `>= 16` | Promising | 16-19 | First purchase follow-up |
| `>= 12` | Engaged | 12-15 | Re-engagement campaigns |
| `>= 8` | Required Attention | 8-11 | Win-back efforts |
| `>= 4` | At Risk | 4-7 | Urgent retention |
| `else` | Lost/Inactive | 0-3 | Final outreach |

**How CASE WHEN Works**:
```sql
CASE
  WHEN condition1 THEN value1    -- First match wins
  WHEN condition2 THEN value2
  ...
  ELSE default_value             -- Fallback if no conditions match
END
```

**Important**: Conditions are evaluated top-to-bottom. First matching condition wins.

**Execution Example**:
```
Customer with rfm_total_score = 26:
- Check: 26 >= 28? NO, skip
- Check: 26 >= 24? YES → Segment = "Loyal VIPs" ✓
- (Other conditions not evaluated)

Customer with rfm_total_score = 5:
- Check: 5 >= 28? NO
- Check: 5 >= 24? NO
- Check: 5 >= 20? NO
- ...all fail...
- ELSE → Segment = "Lost/Inactive" ✓
```

**Output Table**:
```
CustomerID | recency | frequency | monetary | r_score | f_score | m_score | rfm_total_score | rfm_segment
-----------|---------|-----------|----------|---------|---------|---------|-----------------|---------------
1001       | 5       | 15        | 5000     | 10      | 10      | 10      | 30              | Champions
1002       | 10      | 14        | 4800     | 10      | 9       | 10      | 29              | Champions
1003       | 50      | 8         | 3500     | 8       | 7       | 8       | 23              | Potential Loyalits
1004       | 365     | 1         | 100      | 1       | 1       | 1       | 3               | Lost/Inactive
```

---

## Advanced Concepts

### 1. Window Functions vs GROUP BY

**GROUP BY** (used in RFM metrics):
```sql
SELECT CustomerID, COUNT(*) as frequency
FROM sales_2025
GROUP BY CustomerID  -- Aggregates rows per customer
```
- Reduces rows to one per group
- Useful for aggregation

**Window Functions** (used in scoring):
```sql
NTILE(10) OVER(ORDER BY frequency DESC) as f_score
```
- Keeps all rows intact
- Adds computed columns based on window specification
- Perfect for ranking/scoring

### 2. CTEs (Common Table Expressions)

**Syntax**:
```sql
WITH cte_name AS (
  SELECT ... -- CTE definition
)
SELECT * FROM cte_name  -- Can be used multiple times
```

**Benefits**:
- Breaks complex queries into readable chunks
- Can reference CTEs in other CTEs
- Improves query maintainability

### 3. Date Functions

**DATE_DIFF**:
```sql
DATE_DIFF(date1, date2, unit) AS difference
```
- Returns difference between two dates
- `date1 - date2 = positive number`
- Units: DAY, WEEK, MONTH, YEAR, etc.

**MAX(OrderDate)**:
```sql
MAX(OrderDate) AS last_order_date
```
- Returns the most recent date in a group
- Works with GROUP BY

### 4. UNION ALL

```sql
SELECT * FROM table1
UNION ALL
SELECT * FROM table2
```

- Combines result sets vertically
- **UNION ALL** keeps duplicates (faster)
- **UNION** removes duplicates (slower, unnecessary here)

---

## Troubleshooting

### Issue 1: No Results/Empty Tables

**Problem**: Queries return 0 rows

**Solutions**:
```sql
-- Check if sales_2025 has data
SELECT COUNT(*) FROM `rfm4040.sales.sales_2025`;

-- Check for specific month tables
SELECT COUNT(*) FROM `rfm4040.sales.sales202501`;

-- Verify table names match your dataset
SHOW TABLES IN `rfm4040.sales`;
```

### Issue 2: Invalid Column Names

**Problem**: "Column 'OrderDate' not found"

**Solution**: 
```sql
-- Check actual column names
SELECT * FROM `rfm4040.sales.sales202501` LIMIT 1;
-- Update queries to match your schema
```

### Issue 3: NULL Values in Results

**Problem**: Some scores or segments are NULL

**Solutions**:
```sql
-- Add NOT NULL checks
SELECT * FROM rfm_segment_final WHERE rfm_segment IS NULL;

-- Use COALESCE to handle nulls
SELECT 
  CustomerID,
  COALESCE(rfm_segment, 'Unknown') as segment
FROM rfm_segment_final;
```

### Issue 4: Query Timeout

**Problem**: Query takes too long to execute

**Solutions**:
- Add filters to reduce data volume
- Use LIMIT in testing
- Check for missing indexes
- Break large queries into separate steps

```sql
-- Test with smaller dataset
SELECT * FROM rfm_metrics LIMIT 100;
```

### Issue 5: Incorrect Analysis Date

**Problem**: Recency values seem off

**Solution**:
```sql
-- Update analysis_date in rfm_segmentation.sql
WITH current_date AS (
  SELECT DATE('2026-03-06') AS analysis_date  -- Update this date!
  -- Or use:
  -- SELECT CURRENT_DATE() AS analysis_date
)
```

---

## Performance Optimization Tips

### 1. Use CREATE OR REPLACE for Incremental Updates
```sql
CREATE OR REPLACE TABLE table_name AS
-- Faster than DROP + CREATE
```

### 2. Use Views for Reusable Logic
```sql
CREATE OR REPLACE VIEW view_name AS
-- More efficient for multiple references
```

### 3. Filter Early
```sql
-- Good: Filter in WHERE clause
SELECT * FROM sales_2025
WHERE OrderDate >= '2026-01-01'
AND status = 'completed'

-- Bad: Filter after aggregation
SELECT * FROM aggregated_data
WHERE OrderDate >= '2026-01-01'  -- Too late!
```

### 4. Use Appropriate Data Types
```sql
INT for small numbers, BIGINT for large
DATE for dates (not TIMESTAMP for daily analysis)
DECIMAL for monetary values
```

---

## Query Execution Order

**Recommended execution sequence**:

```bash
1️⃣  Run: sql/rfm_segmentation.sql
    ✓ Creates: sales_2025, rfm_metrics

2️⃣  Run: sql/rfm_score.sql  
    ✓ Creates: rfm_scores, rfm_total_score

3️⃣  Run: sql/rfm_final_table.sql
    ✓ Creates: rfm_segment_final

4️⃣  Verify results:
    SELECT * FROM rfm_segment_final LIMIT 10;
    
5️⃣  Connect to Power BI
    Connect to: rfm_segment_final table
```

---

## Useful Queries for Analysis

### Get Segment Summary
```sql
SELECT 
  rfm_segment,
  COUNT(*) as customer_count,
  ROUND(AVG(recency), 1) as avg_recency_days,
  ROUND(AVG(frequency), 1) as avg_purchases,
  ROUND(AVG(monetary), 2) as avg_spend,
  ROUND(SUM(monetary), 2) as total_revenue
FROM rfm_segment_final
GROUP BY rfm_segment
ORDER BY total_revenue DESC;
```

### Find Top Customers
```sql
SELECT 
  CustomerID,
  rfm_segment,
  rfm_total_score,
  frequency,
  monetary
FROM rfm_segment_final
WHERE rfm_segment = 'Champions'
ORDER BY monetary DESC
LIMIT 20;
```

### Identify At-Risk Customers
```sql
SELECT 
  CustomerID,
  recency,
  rfm_total_score,
  rfm_segment
FROM rfm_segment_final
WHERE rfm_segment IN ('At Risk', 'Required Attention', 'Lost/Inactive')
ORDER BY recency DESC;
```

---

## Key Takeaways

✅ **RFM Metrics**: Measure customer value through recency, frequency, and monetary metrics

✅ **Window Functions**: Enable ranking and scoring without data loss

✅ **Decile Scoring**: Normalizes different metric ranges (recency vs monetary)

✅ **Segmentation**: Maps scores to actionable business segments

✅ **Modular Design**: Each step builds on previous results for clarity and reusability

---

For visualizations and dashboard usage, see: **[POWERBI_DOCUMENTATION.md](POWERBI_DOCUMENTATION.md)**
