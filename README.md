# Colume Feature Adoption & Retention Analysis

## 📚 Table of Contents

1. [Project Overview](#project-overview)
2. [Business Question](#business-question)
3. [Objectives](#objectives)
4. [Stakeholders](#stakeholders)
5. [Data Sources](#data-sources)
6. [Data Cleaning Summary](#data-cleaning-summary)
7. [Analysis Pipeline](#analysis-pipeline)
8. [Query Highlights](#query-highlights)
9. [Key Metrics](#key-metrics)
10. [SQL: Early Adoption Analysis Pipeline](#sql-early-adoption-analysis-pipeline)


---

## Project Overview

**Brief Details**  
🗓️ **Project Duration**: February – April 2025  
🧑‍💼 **Prepared by**: Analytics Team  
🏢 **Primary Stakeholder**: Product Team

In February 2025, Colume launched three new features:

- Custom Themes  
- Voice Assistant  
- Task Reminders

This analysis investigates how early adoption of these features impacted user retention and behavior trends post-launch.

---

## Business Question

> **Did early engagement with the newly launched features improve user retention?**

We compared users who adopted **at least one feature** within the first **7 days** of launch against those who did not.

---

## Objectives

- Segment users into **early adopters** and **non-adopters**  
- Calculate **7-day adoption rate**  
- Measure and compare **weekly retention** rates  

---

## Stakeholders

- **Primary:** Product Team

---

## Data Sources

- `users`: User profile and metadata  
- `activity_log`: Feature usage logs  
- `sessions`: Login/logout data  
- `billing`: Payment records  
- `features`: Feature definitions  
- `subscriptions`: Subscription lifecycle  
- `support_tickets`: User-reported issues  
- `feedback`: Customer feedback  

---

## Data Cleaning Summary

### ✅ Integrity Checks:

- Checked for `NULL`s, duplicates, outliers  
- Verified foreign key relationships  

### 🧹 Cleaning Actions:

- Dropped users aged **<16** or **>90**  
- Split `full_name` → `first_name`, `last_name`  
- Standardized `plan_type`, `currency`  
- Fixed invalid `churn_date < sign_up_date`  
- Renamed and deduplicated tables  
- Handled negative or missing payment amounts  

---

## Analysis Pipeline

1. ✅ **Validate Launch Date** → February 20, 2025  
2. ✅ **Filter Eligible Users**  
   - Signed up *before* launch  
   - Didn’t churn *on or before* launch  
3. ✅ **Segment Adopters**  
   - Used any new feature *within 7 days* → **adopter**  
   - Otherwise → **non-adopter**  
4. ✅ **Calculate Weekly Retention**  
   - Use `ROW_NUMBER()` + weekly buckets from **-2 to +6**  
   - `Retention % = active / cohort size`

---

## Query Highlights

**🔍 Query Optimization Techniques**

- ✅ Used **CTEs** and **window functions** for clarity and modularity  
- ⚡ Indexed `user_id`, `timestamp` to improve filter and join performance  
- ❌ Avoided **correlated subqueries** to prevent repeated execution costs  
- 🧠 Ran `EXPLAIN` to verify and tune query plan efficiency

---

## Key Metrics

### 📊 Adoption Summary

- **7-Day Adoption Rate**: `45.41%`  
- **Adopters**: `2,837`  
- **Non-Adopters**: `3,411`  

### 📌 Feature Usage Breakdown

- Custom Themes: `35.13%`  
- Voice Assistant: `33.23%`  
- Task Reminders: `31.65%`

### 📈 Weekly Retention Rate

| Week | Adopters (%) | Non-Adopters (%) | Difference |
|------|---------------|------------------|------------|
| -2   | 30.60         | 12.25            | +18.35     |
| -1   | 81.11         | 55.78            | +25.33     |
| 0    | 100.00        | 74.24            | +25.76     |
| 1    | 85.83         | 59.35            | +26.48     |
| 2    | 84.95         | 59.43            | +25.52     |
| 3    | 85.41         | 59.61            | +25.80     |
| 4    | 84.28         | 59.35            | +24.93     |
| 5    | 84.95         | 57.87            | +27.08     |
| 6    | 83.89         | 57.96            | +25.93     |

---

## SQL: Early Adoption Analysis Pipeline

```sql
-- STEP 1: Create view to store retention analysis
CREATE VIEW retention_rate AS
WITH

-- Step 1a: Get all users eligible for feature adoption
eligible_users AS (
    SELECT user_id
    FROM users
    WHERE sign_up_date < '2025-02-20'
      AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Step 1b: Identify users who adopted any of the new features within 7 days post-launch
adopters AS (
    SELECT DISTINCT user_id
    FROM activity_log
    WHERE activity_type IN ('task_reminder', 'voice_assistant', 'custom_theme')
      AND timestamp BETWEEN '2025-02-20' AND '2025-02-20'::DATE + INTERVAL '7 days'
      AND user_id IN (SELECT user_id FROM eligible_users)
),

-- Step 1c: Identify eligible users who did NOT adopt any new feature
non_adopters AS (
    SELECT eu.user_id AS user_id
    FROM eligible_users eu
    LEFT JOIN adopters a ON eu.user_id = a.user_id
    WHERE a.user_id IS NULL
),

-- Step 1d: Combine all eligible users with their adoption status
all_users AS (
    SELECT
        eu.user_id AS eligible_users,
        a.user_id AS adopted,
        na.user_id AS non_adopted
    FROM eligible_users eu
    LEFT JOIN adopters a ON eu.user_id = a.user_id
    LEFT JOIN non_adopters na ON na.user_id = eu.user_id
),

-- Step 1e: Calculate percentage of adopters vs non-adopters
adopter_percentage AS (
    SELECT
        ROUND(COUNT(CASE WHEN adopted IS NOT NULL THEN 1 END) * 100.0 / COUNT(eligible_users), 2) AS adopters_count,
        ROUND(COUNT(CASE WHEN non_adopted IS NOT NULL THEN 1 END) * 100.0 / COUNT(eligible_users), 2) AS non_adopters_count
    FROM all_users
);

```
---
## 🧠 BAIIR Framework

| Stage          | Action Taken                                   |
|----------------|------------------------------------------------|
| Baseline       | Defined eligible users and grouped by adoption |
| Analysis       | Retention, churn, session time, upgrade trends |
| Insight        | Adoption improves retention and engagement     |
| Impact         | Boosting adoption improves retention, revenue  |
| Recommendation | Build nudges, reinforce value, reduce drop-off |

---

## 💡 Insights, Impacts & Recommendations

### Insight 1: Early Adoption Improves Retention

**Week 1 Retention**: 85.83% (Adopters) vs 59.35% (Non-Adopters)  
**Week 6 Retention**: 83.89% vs 57.96%

**Impact**: 10% increase in adoption → ~1,000 users → +259 retained users

**Recommendations:**

- Prompt feature usage within first 3 days  
- Re-engage by Day 5  
- Celebrate first feature use  
- Promote top-performing features

---

### Insight 2: Adopters Show Slightly Higher Churn

**Churn Rate**: 5.7% of adopters vs 1.8% of non-adopters

**Impact**: Reducing churn by 2% saves ~42 users

**Recommendations:**

- Build 7-day post-adoption engagement flow  
- Highlight benefits gained  
- Proactively nudge inactive adopters  
- Run feedback survey for churned users

---

### Insight 3: Low Plan Upgrades

**Observation:**  
Over 90% stayed on the same plan  
Only 3.9% of adopters upgraded

**Impact**: Feature adoption didn’t convert to upsell

**Recommendations:**

- Push locked features post-adoption  
- Show ROI metrics (time saved, tasks completed)  
- Trial premium features  
- In-app upgrade suggestions

---

## 📎 Supporting Files

| File                     | Description                                 |
|--------------------------|---------------------------------------------|
| `Data Cleaning.sql`      | SQL scripts for all cleaning steps          |
| `Data analysis.sql`      | Logic for adoption, segmentation, retention |


---

## 📌 Final Thoughts

Early adoption drives higher retention and engagement.  
With strategic nudges, improved onboarding, and feature reinforcement,  
**Colume** can improve long-term user retention and conversion.
