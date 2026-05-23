# 📊 Power BI Dashboard Documentation

## RFM Customer Segmentation Dashboard - User Guide

This document provides a comprehensive guide to using the Power BI dashboard for RFM analysis and customer insights.

---

## Table of Contents

1. [Dashboard Overview](#dashboard-overview)
2. [Getting Started](#getting-started)
3. [Dashboard Pages & Visualizations](#dashboard-pages--visualizations)
4. [How to Use Interactive Features](#how-to-use-interactive-features)
5. [Key Metrics & KPIs](#key-metrics--kpis)
6. [Data Refresh Guide](#data-refresh-guide)
7. [Common Use Cases](#common-use-cases)
8. [Troubleshooting](#troubleshooting)

---

## Dashboard Overview

### Purpose
The RFM Customer Segmentation Dashboard transforms raw customer data into actionable business intelligence, enabling:
- **Segment Analysis**: Understand customer distribution across 8 segments
- **Performance Tracking**: Monitor customer lifecycle metrics
- **Strategic Planning**: Identify target audiences for marketing campaigns
- **Risk Management**: Spot churn signals early

### Key Features
✅ Interactive filtering and drill-down capabilities  
✅ Real-time KPI cards for quick insights  
✅ Segment distribution visualizations  
✅ Customer behavior heatmaps  
✅ Revenue contribution analysis  
✅ Trend comparisons across segments  

### File Location
```
Power BI/RFM_Customer_segmentation.pbix
```

---

## Getting Started

### Prerequisites
- Power BI Desktop (latest version) OR Power BI Service access
- BigQuery connection credentials
- Access to `rfm4040.sales` dataset
- `rfm_segment_final` table populated with latest data

### Opening the Dashboard

#### Option 1: Power BI Desktop
```
1. Open Power BI Desktop
2. File → Open → Power BI/RFM_Customer_segmentation.pbix
3. If prompted: Enter BigQuery credentials
4. Wait for data to load
```

#### Option 2: Power BI Service
```
1. Go to https://app.powerbi.com
2. Upload Power BI/RFM_Customer_segmentation.pbix
3. Configure BigQuery data source
4. Set up scheduled refresh
```

### Initial Data Connection

When opening for the first time:

```
1. Click: "Refresh" or "Transform Data"
2. Provide BigQuery connection details:
   - Project: rfm4040
   - Dataset: sales
   - Table: rfm_segment_final
3. Test connection
4. Load data
5. Save file
```

---

## Dashboard Pages & Visualizations

### 📄 Page 1: Executive Summary

**Purpose**: High-level overview of customer segments and KPIs

#### Visualizations

##### 1. **Total Customers (KPI Card)**
```
Display: Total customer count
Location: Top-left
Formula: COUNT(DISTINCT CustomerID)
Example: "47,523 Customers"
Business Value: Quick reference for customer base size
```

##### 2. **Average RFM Score (KPI Card)**
```
Display: Average combined RFM score
Location: Top-center
Formula: AVERAGE(rfm_total_score)
Example: "15.2"
Range: 3-30
Business Value: Overall customer quality indicator
```

##### 3. **Average Monetary Value (KPI Card)**
```
Display: Average spend per customer
Location: Top-right
Formula: AVERAGE(monetary)
Example: "$1,245.67"
Business Value: Revenue potential per customer
```

##### 4. **Segment Distribution Pie Chart**
```
Location: Center-left
X-Axis: rfm_segment
Values: COUNT(CustomerID)
Colors: Color-coded by segment tier
Business Value: Visual breakdown of customer portfolio
```

**Segment Colors** (Standard):
- 🏆 Champions: Gold/Yellow
- 💎 Loyal VIPs: Purple
- 🌟 Potential Loyalists: Blue
- 📈 Promising: Light Blue
- 👥 Engaged: Green
- ⚠️ Required Attention: Orange
- 🔴 At Risk: Red
- ❌ Lost/Inactive: Dark Gray

##### 5. **Segment Metrics Table**
```
Columns:
- Segment Name
- Customer Count
- % of Total
- Avg Recency (days)
- Avg Frequency (purchases)
- Avg Monetary ($)
- Total Revenue

Sorting: By total revenue descending
Business Value: Detailed metrics per segment
```

##### 6. **Top 10 Customers Card**
```
Shows: Customer ID, RFM Score, Spend
Sorted By: rfm_total_score DESC
Business Value: Identify VIP accounts
```

---

### 📊 Page 2: Segment Deep Dive

**Purpose**: Detailed analysis of each customer segment

#### Visualizations

##### 1. **Segment Selector (Filter)**
```
Type: Dropdown/Slicer
Options: All 8 segments + "All Segments"
Default: All
Purpose: Filter all visuals to specific segment
```

##### 2. **Recency Distribution (Histogram)**
```
X-Axis: Recency (days) - binned by 30-day intervals
Y-Axis: Customer count
Color: By segment
Business Value: When did customers last purchase?
- Left side (recent): Good engagement
- Right side (old): Churn risk
```

##### 3. **Frequency vs Monetary (Scatter Plot)**
```
X-Axis: frequency (purchase count)
Y-Axis: monetary (total spend)
Bubble Size: RFM score
Color: By segment
Business Value: 
- Top-right: High-frequency, high-spend (Champions)
- Bottom-left: Low-frequency, low-spend (At Risk)
- Identify upsell opportunities
```

##### 4. **RFM Score Distribution (Box Plot)**
```
X-Axis: Segment
Y-Axis: rfm_total_score range (3-30)
Shows: Min, Q1, Median, Q3, Max
Business Value:
- Compare score ranges across segments
- Identify segment quality variation
```

##### 5. **Customer Lifecycle Curve (Line Chart)**
```
X-Axis: rfm_total_score (sorted bins)
Y-Axis: Customer count
Multiple Lines: By recency quartile
Business Value: See how many customers at each score level
```

---

### 📈 Page 3: Revenue & Performance Analysis

**Purpose**: Financial metrics and business impact

#### Visualizations

##### 1. **Revenue by Segment (Bar Chart)**
```
X-Axis: rfm_segment
Y-Axis: SUM(monetary)
Color: By segment
Sort: Descending by revenue
Business Value: Which segments drive most revenue?
```

**Typical Pattern**:
```
Champions & Loyal VIPs:    ~40-50% of revenue (small % of customers)
Potential Loyalists:        ~20-30% of revenue
Promising:                  ~10-15% of revenue
Engaged:                    ~5-10% of revenue
Others:                     ~5% of revenue
```

##### 2. **Revenue per Customer (Column Chart)**
```
X-Axis: rfm_segment
Y-Axis: AVERAGE(monetary)
Color: Green gradient
Business Value: Average value per customer by segment
```

##### 3. **Segment Contribution (100% Stacked Bar)**
```
Shows: Revenue contribution % by segment
Colors: By segment
Business Value: Portfolio mix at a glance
```

##### 4. **Customer LTV Estimate (Table)**
```
Columns:
- Segment
- Customers
- Avg Spend
- Avg Frequency
- Estimated LTV (spend × frequency)
- Retention Priority

Business Value: Prioritize segment resources
```

##### 5. **Monetary Value Heatmap (Matrix)**
```
Rows: RFM Score Ranges (4-7, 8-11, 12-15, etc.)
Columns: Frequency Categories (Low, Medium, High)
Values: AVERAGE(monetary) - Color intensity = value
Business Value: Spot high-value customer combinations
```

---

### 🎯 Page 4: Actionable Insights & Recommendations

**Purpose**: Drive business decisions

#### Visualizations

##### 1. **Segment Health Scorecard**
```
For Each Segment:
- Current Size
- Growth/Decline vs Last Period
- Churn Risk Level
- Recommended Action

Actions:
Champions → VIP Engagement Program
At Risk → Re-activation Campaign
Lost → Sunset/Archive
```

##### 2. **Top Priority Actions (Card List)**
```
1. "23% of At-Risk customers are in top 10% of spenders"
   Action: Launch urgent retention campaign
   
2. "Potential Loyalists show 45% higher LTV"
   Action: Implement upsell strategy
   
3. "Lost segment has 5,000 customers with >$500 history"
   Action: Win-back email series
```

##### 3. **Customer Journey (Sankey Diagram)**
```
Shows: Flow between segments
Example:
- Champions ↔ Loyal VIPs (healthy movement)
- Required Attention → At Risk (churn warning)
- Engaged → Promising (growth opportunity)

Business Value: Identify upgrade/downgrade patterns
```

##### 4. **Next Action Recommendations (Table)**
```
Segment         | Recommended Action      | Expected ROI | Urgency
----------------|------------------------|--------------|----------
Champions       | VIP Program            | High         | Low
At Risk         | Re-activation Campaign | High         | Critical
Lost/Inactive   | Win-back Email Series  | Medium       | Medium
Potential       | Upsell Campaign        | High         | Medium
```

---

## How to Use Interactive Features

### 1. Slicers (Filters)

#### Segment Slicer
```
Click on segment name to filter all visuals
Example: Click "Champions" to see only champion customers
```

#### Date Range Slicer (if available)
```
Drag slider to select date range
Useful for: Trend analysis over time
```

#### Recency Slicer
```
Filter by days since last purchase
Options: 0-30 days, 30-90 days, 90-365 days, 365+ days
```

### 2. Cross-Filtering

```
Click on any visual element to filter others:

Example 1: Click "Champions" bar in distribution pie
→ All other charts update to show only Champions

Example 2: Click a data point in Frequency vs Monetary scatter
→ Table below updates to show those customers

Example 3: Click segment in table
→ Related metrics update in all visuals
```

### 3. Drill-Through

```
If enabled, right-click on visualizations:
- Customer detail drill-through
- Transaction history
- Segment composition breakdown
```

### 4. Bookmarks (Saved Views)

If bookmarks are configured:
```
Click bookmark buttons to jump to pre-configured views:
- "Champions Overview"
- "At-Risk Dashboard"
- "Revenue Focus"
- "Full Customer View"
```

### 5. Exporting Data

```
Click "..." menu on any visual:
- Export this visual
- Export underlying data (Excel)
- Export as PDF
- Pin to Power BI app
```

---

## Key Metrics & KPIs

### Primary KPIs

#### 1. **Total Customer Base**
```
Formula: COUNT(DISTINCT CustomerID)
Benchmark: Track growth over time
Target: Year-over-year growth
```

#### 2. **Average RFM Score**
```
Formula: AVERAGE(rfm_total_score)
Range: 3-30
Interpretation:
- 20+: Healthy customer base
- 15-20: Average quality
- <15: Concerning, needs intervention
Benchmark: Industry standard ~15-18
```

#### 3. **Top-Tier Customer Percentage**
```
Formula: COUNT(Champions & Loyal VIPs) / Total Customers
Benchmark: Healthy is 5-10%
Target: Grow to 10-15%
```

#### 4. **Revenue Concentration**
```
Formula: Revenue from top 2 segments / Total Revenue
Benchmark: Healthy is 50-60%
Concern: >70% = over-reliance on few segments
```

#### 5. **Churn Risk Score**
```
Formula: COUNT(At Risk & Lost) / Total Customers
Benchmark: Should be <15%
Target: Keep under 10%
Alert: If increasing, activate retention programs
```

### Secondary Metrics

#### 6. **Average Recency (by segment)**
```
Champions: <30 days (recent buyers)
At Risk: >180 days (dormant)
Optimal: <60 days across all active segments
```

#### 7. **Purchase Frequency Trend**
```
Measures: Purchases per customer per segment
Trend: Should increase for Potential Loyalists
Warning: If decreasing in Champions, investigate
```

#### 8. **Monetary Value Growth**
```
Year-over-Year spending change
Target: 5-10% growth
Trend: Should grow fastest in Potential Loyalists
```

---

## Data Refresh Guide

### Refresh Frequency
```
Recommended: Daily or Weekly
Timing: Off-peak hours (early morning)
Impact: 5-15 minutes for typical datasets
```

### Manual Refresh (Desktop)
```
1. Open RFM_Customer_segmentation.pbix
2. Click: "Refresh" in home ribbon
3. Wait for all queries to complete
4. Save file
```

### Automatic Refresh (Service)
```
1. Upload file to Power BI Service
2. Select dataset in Service
3. Settings → Scheduled Refresh
4. Set frequency and time
5. Configure refresh credentials
```

### Refresh Process
```
Step 1: BigQuery queries rfm_segment_final table
Step 2: Loads fresh customer metrics
Step 3: Updates all visualizations
Step 4: Refreshes cache
Step 5: Ready for analysis
```

### Troubleshooting Refresh Issues

**Issue**: "Data refresh failed"
```
Solution:
1. Check BigQuery connection
2. Verify dataset permissions
3. Ensure rfm_segment_final table exists
4. Check for duplicate column names
```

**Issue**: "Refresh takes too long"
```
Solution:
1. Use DirectQuery instead of Import (if possible)
2. Reduce data retention (e.g., last 24 months only)
3. Archive old customer data
4. Optimize BigQuery queries
```

---

## Common Use Cases

### Use Case 1: Launch VIP Campaign for Champions

```
Step 1: Go to "Executive Summary" page
Step 2: Click "Champions" in Segment Distribution
Step 3: Check "Top 10 Customers" card
Step 4: Export customer list:
        - Right-click on table
        - Select "Export this visual"
        - Save to Excel
Step 5: Use exported list for:
        - Personalized outreach
        - Premium offers
        - Exclusive events
Step 6: Track campaign performance by re-checking segment after 30 days
```

### Use Case 2: Identify At-Risk Customers for Retention

```
Step 1: Go to "Segment Deep Dive" page
Step 2: Filter: rfm_segment = "At Risk"
Step 3: View Recency histogram:
        - Customers furthest right = highest churn risk
Step 4: Check Frequency vs Monetary scatter:
        - If high monetary = valuable customer
        - Should prioritize retention
Step 5: Export customer list for re-engagement campaign
Step 6: Create Win-back email series
Step 7: Track recovery after 60 days
```

### Use Case 3: Revenue Impact Analysis

```
Step 1: Go to "Revenue & Performance" page
Step 2: View "Revenue by Segment" bar chart
Step 3: Identify top revenue-generating segment
Step 4: Check "Segment Contribution" chart
Step 5: For top segment:
        - Analyze average spend
        - Review frequency distribution
        - Plan retention strategy
Step 6: For under-performing segments:
        - Develop uplift programs
        - Plan cross-sell campaigns
```

### Use Case 4: Develop Segment-Specific Strategy

```
Step 1: Select each segment using slicer
Step 2: For each segment, note:
        - Average recency
        - Purchase frequency
        - Monetary value
        - Growth trend
Step 3: Create strategy matrix:
        
Segment             Action              Budget  Timeline
─────────────────────────────────────────────────────────
Champions           VIP Program         High    Ongoing
Potential Loyalists  Upsell Campaign     Medium  30 days
At Risk            Re-engagement        High    15 days
Lost/Inactive      Win-back Series      Low     30 days

Step 4: Set budget allocation based on ROI potential
Step 5: Execute campaigns in priority order
Step 6: Track results in Power BI dashboard
```

### Use Case 5: Monitor Segment Transitions

```
Step 1: Go to "Actionable Insights" page
Step 2: View Sankey diagram showing segment flow
Step 3: Identify:
        - Positive flows (At Risk → Engaged)
        - Negative flows (Champions → Loyal VIPs)
        - Stagnation (Engaged staying in Engaged)
Step 4: Root cause analysis:
        - Product quality issues?
        - Marketing mix?
        - Competitive pressure?
Step 5: Adjust strategy accordingly
Step 6: Re-analyze after campaign month
```

---

## Dashboard Best Practices

### 1. **Regular Review Schedule**
```
Daily: Check KPI summary (5 min)
Weekly: Full dashboard review (30 min)
Monthly: Deep dive analysis (2 hours)
Quarterly: Strategic planning session (4 hours)
```

### 2. **Setting Alerts**
```
Configure alerts for:
- Churn Risk Score exceeds 15%
- Champions segment decreases by >5%
- Average RFM score drops below 14
- At-Risk customers increase >10%
```

### 3. **Sharing Insights**
```
Executive Summary: KPI cards + Segment distribution
Marketing Team: At-Risk & Potential segments
Sales Team: Top customers + opportunity list
Finance: Revenue by segment + LTV analysis
```

### 4. **Documentation**
```
Keep changelog:
- Date of analysis
- Key findings
- Actions taken
- Results and impact
- Follow-up date
```

---

## Troubleshooting

### Issue 1: No Data Appearing

**Problem**: Dashboard shows empty charts

**Solution**:
```
1. Check data refresh status
   → Settings → Refresh logs
   
2. Verify BigQuery connection
   → File → Options → Data Source Settings
   → Test connection
   
3. Confirm rfm_segment_final exists
   → Query in BigQuery console
   → SELECT COUNT(*) FROM rfm_segment_final
   
4. Check for data filtering
   → Remove all slicer filters
   → Click "Clear all filters"
```

### Issue 2: Slow Performance

**Problem**: Dashboard takes >30 seconds to load

**Solution**:
```
1. Reduce visual complexity
   - Remove unused visuals
   - Simplify filters
   
2. Optimize data model
   - Use aggregations
   - Set appropriate column types
   
3. Check file size
   - File size > 100MB = too large
   - Archive old data to separate file
   
4. Switch to DirectQuery (if available)
   - Reduces file size
   - Live connection to BigQuery
```

### Issue 3: Incorrect Segment Counts

**Problem**: Segment totals don't match

**Solution**:
```
1. Verify SQL query ran successfully
   → Run in BigQuery:
   SELECT COUNT(*) FROM rfm_segment_final
   
2. Check for filtering
   → Ensure no hidden filters active
   
3. Refresh data model
   → File → Refresh all
   
4. Check data type consistency
   → CustomerID should be same type in all tables
```

### Issue 4: Missing Customers in Export

**Problem**: Exported list has fewer customers than expected

**Solution**:
```
1. Check if filters are applied
   - Export includes filtered data only
   - Clear filters to get all customers
   
2. Verify export settings
   - Settings → Ensure all columns selected
   
3. Check date range
   - Confirm date slicer isn't limiting data
```

### Issue 5: Connection Fails on Opening

**Problem**: "Unable to connect to data source"

**Solution**:
```
1. Check internet connection
   → Ping google.com
   
2. Verify BigQuery credentials
   → File → Options → Data source settings
   → Edit → Re-enter credentials
   
3. Check project/dataset names
   → Confirm: rfm4040.sales
   
4. Verify table permissions
   → In BigQuery: Check GRANT permissions
   
5. Try re-importing data
   → File → Queries Editor → New Source
   → Select: Google BigQuery
   → Re-authenticate
```

---

## Advanced Tips

### 1. Creating Custom Measures

If you want to add measures to the dashboard:

```
Right-click on data → New measure

Example 1: Churn Risk Percentage
churn_risk_pct = 
DIVIDE(
  CALCULATE(COUNTA(Customers[CustomerID]), 
    Customers[rfm_segment] IN {"At Risk", "Lost/Inactive"}),
  COUNTA(Customers[CustomerID])
)

Example 2: Revenue per Customer
revenue_per_cust = 
DIVIDE(
  SUM(Customers[monetary]),
  COUNTA(Customers[CustomerID])
)
```

### 2. Conditional Formatting

Highlight cells based on values:
```
1. Select column in table
2. Click "Conditional formatting"
3. Choose: Color scales, Data bars, or Icons
4. Set thresholds:
   - Green: >20 RFM score (good)
   - Yellow: 10-20 (average)
   - Red: <10 (concern)
```

### 3. Dynamic Titles

Make titles update based on filters:
```
Title = 
IF(HASONEVALUE(Customers[rfm_segment]),
  "Segment: " & SELECTEDVALUE(Customers[rfm_segment]),
  "All Segments")
```

---

## Dashboard Summary

This Power BI dashboard provides:
- ✅ **Executive Overview**: Key metrics at a glance
- ✅ **Segment Analysis**: Deep dive into customer groups
- ✅ **Financial Tracking**: Revenue and value metrics
- ✅ **Actionable Insights**: Strategic recommendations
- ✅ **Interactive Exploration**: Drill-down capabilities
- ✅ **Export Capability**: Data extraction for campaigns

For SQL technical details, refer to: **[SQL_DOCUMENTATION.md](SQL_DOCUMENTATION.md)**

---

## Contact & Support

For questions about the dashboard:
1. Check troubleshooting section above
2. Review Power BI documentation
3. Contact data analytics team
4. Submit issue to project repository

---

**Last Updated**: 2026-05-23  
**Version**: 1.0  
**Dashboard File**: RFM_Customer_segmentation.pbix
