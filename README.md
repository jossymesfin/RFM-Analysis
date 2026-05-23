````markdown
# 📊 RFM Customer Segmentation Analysis

> A complete end-to-end **Customer Segmentation Analytics Project** using **Google BigQuery, SQL, and Power BI** to identify high-value customers, churn risks, and growth opportunities through the **RFM (Recency, Frequency, Monetary)** framework.

---

## 🚀 Project Overview

This project analyzes customer purchasing behavior using the **RFM model**:

- **Recency (R)** → How recently a customer purchased
- **Frequency (F)** → How often a customer purchases
- **Monetary (M)** → How much a customer spends

Customers are scored and grouped into actionable business segments such as:

- 🏆 Champions
- 💎 Loyal VIPs
- 🌟 Potential Loyalists
- 📈 Promising
- 👥 Engaged
- ⚠️ Required Attention
- 🔴 At Risk
- ❌ Lost / Inactive

The final output is an interactive **Power BI Dashboard** designed for business decision-making.

---

# 🛠️ Tech Stack

| Component | Technology | Purpose |
|---|---|---|
| Data Warehouse | Google BigQuery | Cloud SQL analytics |
| Analytics | SQL (BigQuery SQL) | RFM calculations |
| Visualization | Power BI | Interactive dashboards |
| Automation | Scheduled Queries | Data refresh |
| Data Model | OLAP Schema | Customer analytics |

---

# 📂 Project Structure

```bash
RFM-Customer-Segmentation/
│
├── sql/
│   ├── rfm_segmentation.sql
│   ├── rfm_score.sql
│   └── rfm_final_table.sql
│
├── docs/
│   ├── SQL_DOCUMENTATION.md
│   └── POWERBI_DOCUMENTATION.md
│
├── powerbi/
│   └── RFM_Customer_Segmentation.pbix
│
└── README.md
````

---

# ⚡ Quick Start

## 📌 Prerequisites

Before starting, ensure you have:

* Google BigQuery account
* Power BI Desktop / Power BI Service
* Sales transaction data
* SQL Editor

### Expected Monthly Tables

```sql
sales202501
sales202502
sales202503
...
```

---

# 🔄 End-to-End Workflow

```text
Step 1: Data Consolidation
──────────────────────────
12 monthly sales tables
        ↓
1 unified table → sales_2025

Step 2: RFM Metrics Calculation
───────────────────────────────
For each customer:
• Recency   = Days since last purchase
• Frequency = Total orders
• Monetary  = Total spend

Step 3: Decile Scoring
──────────────────────
Customers ranked from 1 → 10
• 10 = Best
• 1  = Lowest

Step 4: Total RFM Score
───────────────────────
RFM Score = R + F + M
Range: 3 → 30

Step 5: Customer Segmentation
─────────────────────────────
Scores mapped into
8 business segments

Step 6: Power BI Dashboard
──────────────────────────
Interactive business insights
```

---

# 🧠 Customer Segmentation Logic

## Example Customer Journey

```text
Customer Summary
────────────────────────────────
Last Purchase : 5 days ago
Total Orders  : 15
Total Spend   : $5,000

RFM Analysis
────────────────────────────────
Recency Score  : 10
Frequency Score: 10
Monetary Score : 10

Final RFM Score: 30

Segment
────────────────────────────────
🏆 CHAMPION
```

---

# 🎯 8-Segment Model

| Segment                | Score Range | Customer % | Business Strategy                |
| ---------------------- | ----------- | ---------- | -------------------------------- |
| 🏆 Champions           | 28–30       | 1–2%       | VIP treatment & exclusive offers |
| 💎 Loyal VIPs          | 24–27       | 5–7%       | Retention & premium service      |
| 🌟 Potential Loyalists | 20–23       | 10–12%     | Upselling & nurturing            |
| 📈 Promising           | 16–19       | 15–18%     | Encourage repeat purchases       |
| 👥 Engaged             | 12–15       | 20–25%     | Re-engagement campaigns          |
| ⚠️ Required Attention  | 8–11        | 15–20%     | Win-back efforts                 |
| 🔴 At Risk             | 4–7         | 10–12%     | Urgent retention campaigns       |
| ❌ Lost / Inactive      | 0–3         | 20–25%     | Final outreach attempts          |

---

# 📊 Power BI Dashboard Pages

## 1️⃣ Executive Summary

* Total customers
* Revenue metrics
* Segment distribution
* Top customers
* KPI cards

---

## 2️⃣ Segment Deep Dive

* Recency distribution
* Frequency vs Monetary scatter plot
* RFM score distribution
* Customer lifecycle analysis

---

## 3️⃣ Revenue & Performance

* Revenue by segment
* Contribution analysis
* Customer lifetime value (LTV)
* Revenue concentration metrics

---

## 4️⃣ Actionable Insights

* Segment health scorecards
* Retention recommendations
* Churn risk indicators
* Campaign targeting suggestions

---

# ✨ Interactive Dashboard Features

* ✅ Dynamic Filtering
* ✅ Cross Filtering
* ✅ Drill Through Analysis
* ✅ Export Customer Lists
* ✅ Responsive Dashboard Design
* ✅ Real-Time Data Refresh

---

# 🧮 RFM Scoring Methodology

Each customer receives:

| Score   | Meaning                               |
| ------- | ------------------------------------- |
| R-Score | Recent buyers receive higher scores   |
| F-Score | Frequent buyers receive higher scores |
| M-Score | Higher spenders receive higher scores |

## Formula

```text
Total RFM Score = R + F + M
Range = 3 → 30
```

---

# 📈 Typical Customer Distribution

```text
Champions              ████
Loyal VIPs             ██████████
Potential Loyalists    ███████████████
Promising              ██████████████████
Engaged                █████████████████████████
Required Attention     ███████████████████
At Risk                ███████████
Lost / Inactive        █████████████████████████
```

---

# 🏁 Getting Started

## Step 1 — Verify Your Data

```sql
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    MIN(OrderDate) AS first_order,
    MAX(OrderDate) AS last_order
FROM `rfm4040.sales.sales202501`;
```

---

## Step 2 — Run SQL Files

Execute the SQL scripts in this exact order:

```bash
1. sql/rfm_segmentation.sql
   └── Creates:
       • sales_2025
       • rfm_metrics

2. sql/rfm_score.sql
   └── Creates:
       • rfm_scores
       • rfm_total_score

3. sql/rfm_final_table.sql
   └── Creates:
       • rfm_segment_final
```

---

## Step 3 — Verify Segmentation Output

```sql
SELECT
    rfm_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(rfm_total_score), 1) AS avg_score,
    ROUND(AVG(monetary), 2) AS avg_spend
FROM `rfm4040.sales.rfm_segment_final`
GROUP BY rfm_segment
ORDER BY avg_spend DESC;
```

---

## Step 4 — Connect Power BI

```text
Power BI Desktop
    ↓
Get Data
    ↓
Google BigQuery
    ↓
Project: rfm4040
Dataset: sales
Table: rfm_segment_final
```

Open:

```text
powerbi/RFM_Customer_Segmentation.pbix
```

---

# 📚 Documentation

## SQL Documentation

```text
docs/SQL_DOCUMENTATION.md
```

Includes:

* Query explanations
* Window functions
* CTEs
* Date calculations
* NTILE scoring
* Performance optimization
* Troubleshooting

---

## Power BI Documentation

```text
docs/POWERBI_DOCUMENTATION.md
```

Includes:

* Dashboard walkthrough
* KPI explanations
* Interactive features
* DAX measures
* Refresh setup
* Troubleshooting

---

# 💡 Business Use Cases

## 🎯 Marketing & Sales

### VIP Programs

* Exclusive offers
* Loyalty programs
* Personalized outreach

### Churn Prevention

* Identify at-risk customers
* Launch win-back campaigns
* Retention strategies

### Revenue Optimization

* Upselling
* Cross-selling
* Segment-based promotions

---

## 📊 Analytics & Strategy

### Portfolio Analysis

* Customer mix analysis
* Revenue concentration
* Segment trends

### Campaign ROI

* Segment movement tracking
* Retention improvement analysis
* Campaign impact measurement

---

# 📊 Expected Insights

After running the project, expect insights such as:

* 40–50% of revenue from top 5–10% customers
* High-value customer identification
* Churn risk visibility
* Growth opportunity detection
* Revenue concentration analysis

---

# 🔧 Customization

## Modify Segment Thresholds

```sql
CASE
    WHEN rfm_total_score >= 28 THEN 'Champions'
    WHEN rfm_total_score >= 24 THEN 'Loyal VIPs'
    ...
END AS rfm_segment
```

---

## Change Analysis Date

```sql
SELECT DATE('2026-03-06') AS analysis_date;

-- OR

SELECT CURRENT_DATE() AS analysis_date;
```

---

## Add Custom Power BI Measures

```DAX
Revenue per Customer =
DIVIDE(
    SUM(Customers[monetary]),
    COUNTA(Customers[CustomerID])
)
```

---

# 🐛 Troubleshooting

## Power BI Shows No Data?

* Verify BigQuery credentials
* Check dataset permissions
* Confirm `rfm_segment_final` exists
* Refresh Power BI connection

---

## SQL Query Timeout?

* Reduce data volume
* Use date filters
* Break queries into smaller steps
* Test using LIMIT

---

## Incorrect Customer Counts?

* Check duplicate CustomerIDs
* Verify analysis date
* Review data cleaning logic

---

# 📝 SQL Cheat Sheet

## Segment Summary

```sql
SELECT
    rfm_segment,
    COUNT(*),
    ROUND(AVG(monetary), 2) AS avg_spend
FROM rfm_segment_final
GROUP BY rfm_segment
ORDER BY avg_spend DESC;
```

---

## Top Customers

```sql
SELECT *
FROM rfm_segment_final
WHERE rfm_segment = 'Champions'
ORDER BY monetary DESC
LIMIT 10;
```

---

## Revenue Analysis

```sql
SELECT
    rfm_segment,
    SUM(monetary) AS total_revenue,
    COUNT(*) AS customers
FROM rfm_segment_final
GROUP BY rfm_segment
ORDER BY total_revenue DESC;
```

---

# 📌 BigQuery Schema

```sql
CREATE TABLE `rfm4040.sales.sales202501` (
    CustomerID INT64,
    OrderDate DATE,
    OrderValue NUMERIC,
    OrderID STRING,
    Category STRING
);
```

---

# ✅ Deployment Checklist

Before production deployment:

* [ ] SQL queries execute successfully
* [ ] Final table contains expected rows
* [ ] Power BI connects correctly
* [ ] Visuals display data properly
* [ ] Segment distribution looks realistic
* [ ] Revenue metrics match source data
* [ ] Refresh schedule configured
* [ ] Documentation reviewed

---

# 👤 Author

## Jossy Mesfin

**RFM Customer Segmentation Analysis Project**

📅 Last Updated: 2026-05-23

---

# 📄 License

This project is provided for:

* Educational use
* Portfolio projects
* Business analytics learning
* Commercial adaptation

---

# 🎓 Learning Outcomes

This project demonstrates:

* Advanced SQL analytics
* Window functions & CTEs
* BigQuery data warehousing
* Power BI dashboard development
* Customer analytics
* Business segmentation
* Marketing analytics

---

# ⭐ Final Dashboard Includes

✅ Executive Summary
✅ Segment Deep Dive
✅ Revenue Performance
✅ Actionable Insights
✅ Customer Segmentation Analytics
✅ Interactive Filtering
✅ Revenue & Retention Analysis

---

# 🚀 Happy Analyzing!

```
```
