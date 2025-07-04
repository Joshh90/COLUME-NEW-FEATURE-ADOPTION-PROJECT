/* Measure the weekly retention rate of users who adopted at least one of the
features within 7 days of launch and compare it with retention rates of users who
do not engage with the features. */

-- Step 1: View features launched on February 20, 2025
SELECT * FROM Features
WHERE launch_date = '2025-02-20';

-- Step 2: View all users
SELECT * FROM users;

-- Step 3: EARLY ADOPTION ANALYSIS PIPELINE
-- A.FINDING THE RETENTION RATE

CREATE VIEW retention_rate AS
WITH eligible_users AS (
    SELECT user_id
    FROM users
    WHERE sign_up_date < '2025-02-20'
      AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
    SELECT DISTINCT user_id
    FROM activity_log
    WHERE activity_type IN ('task_reminder', 'voice_assistant', 'custom_theme')
      AND timestamp BETWEEN '2025-02-20' AND '2025-02-20'::DATE + INTERVAL '7 days'
      AND user_id IN (SELECT user_id FROM eligible_users)
),

-- Identify eligible users who did not adopt any new feature
non_adopters AS (
    SELECT eu.user_id AS user_id
    FROM eligible_users eu
    LEFT JOIN adopters a ON eu.user_id = a.user_id
    WHERE a.user_id IS NULL
),

-- Combine all eligible users and mark their adoption status
all_users AS (
    SELECT
        eu.user_id AS eligible_users,
        a.user_id AS adopted,
        na.user_id AS non_adopted
    FROM eligible_users eu
    LEFT JOIN adopters a ON eu.user_id = a.user_id
    LEFT JOIN non_adopters na ON na.user_id = eu.user_id
),

-- B. WEEKLY RETENTION ANALYSIS
user_group AS (
    SELECT
        eligible_users,
        CASE
            WHEN adopted IS NOT NULL THEN 'adopter'
            ELSE 'non_adopter'
        END AS adopter_group,
        timestamp,
        FLOOR((timestamp::DATE - DATE '2025-02-20') / 7) AS week_diff,
        ROW_NUMBER() OVER (
            PARTITION BY eligible_users, FLOOR((timestamp::DATE - DATE '2025-02-20') / 7)
            ORDER BY timestamp
        ) AS RowN
    FROM all_users
    JOIN activity_log a ON a.user_id = all_users.eligible_users
    WHERE timestamp BETWEEN '2025-02-20'::DATE - INTERVAL '2 weeks' AND '2025-02-20'::DATE + INTERVAL '7 weeks'
),

-- Count total users per group
grouped AS (
    SELECT adopter_group, COUNT(DISTINCT eligible_users) AS all_users
    FROM user_group
    GROUP BY adopter_group
),

-- Count retained users per group per week
weekly_retention AS (
    SELECT
        adopter_group,
        week_diff,
        COUNT(DISTINCT eligible_users) AS retained_users
    FROM user_group
    WHERE RowN = 1
    GROUP BY adopter_group, week_diff
),

-- Final retention rate per group per week
retention_calc AS (
    SELECT
        wr.adopter_group,
        wr.week_diff,
        ROUND((wr.retained_users * 100.0) / g.all_users, 2) AS retention_rate
    FROM weekly_retention wr
    JOIN grouped g ON g.adopter_group = wr.adopter_group
    GROUP by 1,2,3
    ORDER by 2 asc
    LIMIT 18
) select * from retention_calc,

-- Pivot the retention rates for easier comparison
pivoted AS (
    SELECT
        week_diff,
        MAX(CASE WHEN adopter_group = 'adopter' THEN retention_rate END) AS adopter,
        MAX(CASE WHEN adopter_group = 'non_adopter' THEN retention_rate END) AS non_adopter
    FROM retention_calc
    GROUP BY week_diff
)

-- Final output: Week, Retention by group, Difference
SELECT
    week_diff,
    adopter,
    non_adopter,
    (adopter - non_adopter) AS percent_diff
FROM pivoted;

SELECT * FROM retention_rate

CREATE VIEW user_weekly AS
WITH eligible_users AS (
    SELECT user_id
    FROM users
    WHERE sign_up_date < '2025-02-20'
      AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
    SELECT DISTINCT user_id
    FROM activity_log
    WHERE activity_type IN ('task_reminder', 'voice_assistant', 'custom_theme')
      AND timestamp BETWEEN '2025-02-20' AND '2025-02-20'::DATE + INTERVAL '7 days'
      AND user_id IN (SELECT user_id FROM eligible_users)
),

-- Create a list of weeks to cover the analysis window
Weeks AS (
    SELECT -2 AS wk UNION ALL
    SELECT -1 UNION ALL
    SELECT 0 UNION ALL
    SELECT 1 UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6
),

-- Cross join all eligible users with each week
user_weeks AS (
    SELECT eu.user_id, wk
    FROM eligible_users eu
    CROSS JOIN Weeks
)

-- Final Output for the View
SELECT
    uw.user_id,
    uw.wk,
    CASE
        WHEN a.user_id IS NOT NULL THEN 'adopter'
        ELSE 'non_adopter'
    END AS adopter_group,
    MAX(CASE
            WHEN al.user_id IS NOT NULL THEN 1
            ELSE 0
        END) AS active
FROM user_weeks uw
LEFT JOIN adopters a
    ON uw.user_id = a.user_id
LEFT JOIN activity_log al
    ON al.user_id = uw.user_id
   AND FLOOR((al.timestamp::DATE - DATE '2025-02-20') / 7) = uw.wk
GROUP BY uw.user_id, uw.wk, a.user_id;
--Note: Views and CTE dont use ORDER BY

Select * from user_weekly


--STEP 4:FINDING THE PLAN CHANGE
-- Finding those who upgraded their plan status

CREATE VIEW Plan_change AS
WITH eligible_users AS (
    SELECT user_id
    FROM users
    WHERE sign_up_date < DATE '2025-02-20'
      AND (churn_date > DATE '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
    SELECT DISTINCT user_id
    FROM activity_log
    WHERE activity_type IN ('task_reminder', 'voice_assistant', 'custom_theme')
      AND timestamp BETWEEN DATE '2025-02-20' AND DATE '2025-02-27'
      AND user_id IN (SELECT user_id FROM eligible_users)
),

-- Get first billing within 30 days before launch
first_billing AS (
    SELECT
        user_id,
        plan_type,
        MIN(billing_date) AS first_billing
    FROM billing
    WHERE billing_date BETWEEN (DATE '2025-02-20' - INTERVAL '30 days') AND DATE '2025-02-20'
    GROUP BY user_id, plan_type
),

-- Get second billing within 30 days after launch
second_billing AS (
    SELECT
        user_id,
        plan_type,
        MIN(billing_date) AS second_billing
    FROM billing
    WHERE billing_date BETWEEN DATE '2025-02-20' AND (DATE '2025-02-20' + INTERVAL '30 days')
    GROUP BY user_id, plan_type
),

-- Combine user groups and billing data
Billing_check AS (
    SELECT
        eu.user_id,
        CASE WHEN a.user_id IS NOT NULL THEN 'adopter' ELSE 'non_adopter' END AS adopter_group,
        f.first_billing AS first_billing_date,
        f.plan_type AS first_plan,
        s.second_billing AS second_billing_date,
        s.plan_type AS second_plan
    FROM eligible_users eu
    LEFT JOIN adopters a ON eu.user_id = a.user_id
    LEFT JOIN first_billing f ON f.user_id = eu.user_id
    LEFT JOIN second_billing s ON s.user_id = eu.user_id
    WHERE f.first_billing IS NOT NULL
      AND f.plan_type <> 'Enterprise'
),

-- Determine plan status changes
Status AS (
    SELECT
        user_id,
        adopter_group,
        CASE
            WHEN first_plan = second_plan THEN 'same_plan'
            WHEN second_billing_date IS NULL AND second_plan IS NULL THEN 'No renewal'
            WHEN first_plan IN ('Basic', 'Pro') AND second_plan IN ('Pro', 'Enterprise') THEN 'Upgraded'
            WHEN first_plan = 'Pro' AND second_plan = 'Basic' THEN 'Down_graded'
            ELSE 'Other'
        END AS plan_change
    FROM Billing_check
)

-- Final counts per adopter group and plan change status
SELECT
    adopter_group,
    COUNT(CASE WHEN plan_change = 'same_plan' THEN 1 END) AS same_plan_cnt,
    COUNT(CASE WHEN plan_change = 'Upgraded' THEN 1 END) AS upgraded_cnt,
    COUNT(CASE WHEN plan_change = 'Down_graded' THEN 1 END) AS downgraded_cnt,
    COUNT(CASE WHEN plan_change = 'No renewal' THEN 1 END) AS no_renewal_cnt,
    COUNT(CASE WHEN plan_change = 'Other' THEN 1 END) AS other_cnt
FROM Status
GROUP BY adopter_group;



---STEP 5:FINDING THE ADOPTION RATE
CREATE VIEW adoption_rate AS
WITH eligible_users AS (
    SELECT user_id
    FROM users
    WHERE sign_up_date < '2025-02-20'
      AND (churn_date > '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
    SELECT DISTINCT user_id
    FROM activity_log
    WHERE activity_type IN ('task_reminder', 'voice_assistant', 'custom_theme')
      AND timestamp BETWEEN '2025-02-20' AND '2025-02-20'::DATE + INTERVAL '7 days'
      AND user_id IN (SELECT user_id FROM eligible_users)
)

--SELECT * FROM adopters

SELECT COUNT(eu.user_id) all_users,COUNT(a.user_id) adopter_cnt,
COUNT(CASE WHEN a.user_id IS NULL THEN 1 END) AS non_adopter_cnt,
ROUND(
  (COUNT(a.user_id)::numeric * 100.0) / COUNT(eu.user_id),
  2
) AS adoption_rate
FROM eligible_users eu
LEFT JOIN adopters a ON a.user_id = eu.user_id;




--STEP 6: FINDING WEEKLY LOGIN
CREATE VIEW weekly_login AS
WITH eligible_users AS (
    SELECT user_id
    FROM users
    WHERE sign_up_date < DATE '2025-02-20'
      AND (churn_date > DATE '2025-02-20' OR churn_date IS NULL)
),

-- Identify users who engaged with new features in the first 7 days after launch
adopters AS (
    SELECT DISTINCT user_id
    FROM activity_log
    WHERE activity_type IN ('task_reminder', 'voice_assistant', 'custom_theme')
      AND timestamp BETWEEN DATE '2025-02-20' AND DATE '2025-02-27'
      AND user_id IN (SELECT user_id FROM eligible_users)
),

-- Mark all eligible users as adopters or non-adopters
all_users AS (
    SELECT
        eu.user_id AS eligible_users,
        CASE WHEN a.user_id IS NOT NULL THEN 'adopter' ELSE 'non_adopter' END AS adopter_group
    FROM eligible_users eu
    LEFT JOIN adopters a ON eu.user_id = a.user_id
),

-- Build activity table with week calculation
activity_table AS (
    SELECT
        al.eligible_users,
        al.adopter_group,
        a.timestamp,
        FLOOR(EXTRACT(EPOCH FROM (a.timestamp - DATE '2025-02-20')) / (7 * 24 * 60 * 60)) AS week
    FROM all_users al
    JOIN activity_log a ON al.eligible_users = a.user_id
    WHERE a.timestamp BETWEEN DATE '2025-02-20' - INTERVAL '2 weeks' AND DATE '2025-02-20' + INTERVAL '6 weeks'
),

-- Select first activity per user per week
user_weekly AS (
    SELECT
        eligible_users,
        adopter_group,
        timestamp,
        week,
        ROW_NUMBER() OVER (PARTITION BY eligible_users, week ORDER BY timestamp) AS rn
    FROM activity_table
)

-- Final output
SELECT
    eligible_users,
    adopter_group,
    week,
    timestamp
FROM user_weekly
WHERE rn = 1;
select * from weekly_login;


--STEP 7: CREATING INDEXES
--CREATING A CLUSTERED INDEX ON 'activity_id'
CREATE INDEX act_user_id ON activity_log(activity_id);
CLUSTER activity_log USING act_user_id;

--CREATING A NON-CLUSTER INDEX ON 'timestamp'
CREATE INDEX act_timestamp ON activity_log (timestamp)

---INDEXING--
--We have column-store index and row-store index
---We can only have one clustered index in a table(on primary key by default), because we can only sort a table once. We have clustered and non clustered index.
--Clustered index sort the table by default. Non clustered does not sort a table.
--When creating index and we dont specify the type, the default created is non-clustered.
--Table scan(other dbs) and Sequential scan(postgre) are synonymous.
--Under obj, when index kind is a heap structure, that means that there is no index.
SELECT * FROM user_weekly;
select * from activity_log;
SELECT * FROM adoption_rate;
SELECT * FROM retention_rate;
SELECT * FROM plan_change;







-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--:CREATING A FUNCTION
CREATE OR REPLACE FUNCTION date_diff(start_date date, end_date date)
returns integer AS $$
begin
return  FLOOR(EXTRACT(EPOCH FROM date_trunc('week',end_date) - date_trunc('week',start_date)) / (7 * 24 * 60 * 60));
end;
$$
language plpgsql;


select * from date_diff (date '2025-01-01', '2025-02-20')

select * from billing;
