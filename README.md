# COLUME-NEW-FEATURE-ADOPTION-PROJECT
# 📊 Feature Adoption & Retention Analysis

## 📚 Table of Contents
1. [Project Overview](#1-project-overview)
2. [Business Question](#2-business-question)
3. [Objectives](#3-objectives)
4. [Stakeholders](#4-stakeholders)
5. [Data Sources](#5-data-sources)
6. [Data Cleaning Summary](#6-data-cleaning-summary)
7. [Analysis Pipeline](#7-analysis-pipeline)

---

## 🔍 1. Project Overview

**Brief Details**  
Project Duration: **February – April 2025**  
Prepared by: **Analytics Team**  
Primary Stakeholder: **Product Team**

In February 2025, Colume launched three new features:
- 🎨 Custom Themes  
- 🗣️ Voice Assistant  
- ⏰ Task Reminders

This analysis investigates how early adoption of these features impacted user retention and behavior trends post-launch.

---

## ❓ 2. Business Question

> **Did early engagement with the newly launched features improve user retention?**

To answer this, we compared users who adopted **at least one feature** within the first **7 days** of launch against those who did not.

---

## 🎯 3. Objectives

- Segment users into **early adopters** and **non-adopters**  
- Calculate **7-day adoption rate**  
- Measure and compare **weekly retention** rates  

---

## 👥 4. Stakeholders

- **Primary:** Product Team  

---

## 🗃️ 5. Data Sources

- `users`: The user profile and metadata  
- `activity_log`: User activities and feature usage  
- `sessions`: Login/logout data  
- `billing`: Payment history  
- `features`: Feature catalog  
- `subscriptions`: Subscription lifecycle  
- `support_tickets`: Customer issues  
- `feedback`: User feedback submissions  

---

## 🧹 6. Data Cleaning Summary

### ✅ Integrity Checks:
- Checked for `NULLs`, duplicates, outliers  
- Verified foreign key relationships  

### 🧼 Cleaning Actions:
- Dropped users aged **<16** or **>90**  
- Split `full_name` into `first_name` and `last_name`  
- Standardized `plan_type` and `currency` values  
- Fixed `churn_date` earlier than `sign_up_date`  
- Renamed and deduplicated key tables  
- Handled invalid `amount` and payment records  

---

## 🔄 7. Analysis Pipeline

1. **Validate Launch Date** → February 20, 2025  
2. **Filter Eligible Users**
   - Signed up *before* launch  
   - Didn’t churn *on or before* launch  
3. **Segment Adopters**
   - Used at least one feature *within 7 days* → **adopter**  
   - Otherwise → **non-adopter**  
4. **Calculate Weekly Retention**
   - Use `ROW_NUMBER()` and weekly buckets (`week_diff`) from **-2 to +6**
   - Formula: `Retention % = active / cohort size`

---

## 🛠️ SQL: Early Adoption Analysis Pipeline

```sql
-- STEP 1: Create view to store retention analysis
CREATE VIEW retention_rate AS 
WITH

-- Step 1a: Get all users eligible for feature adoption
-- Criteria: signed up before launch and not churned before launch
eligible_users AS (
    SELECT user_id 
    FROM users
    WHERE sign_up_date < '2025-02-20' 
      AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),
...
