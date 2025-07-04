---STEP 1:DATA PROFILING
    SELECT * FROM activity_log;
    SELECT COUNT(*)FROM activity_log;
--There are 1644653 rows in activity_log table
    SELECT * FROM billing;
    SELECT COUNT(*) FROM billing;
--There are    18251 rows in billing table

     SELECT * FROM features;
     SELECT COUNT(*) FROM features;
--There are 18 rows in features table

     SELECT * FROM feedback;
     SELECT COUNT(*) FROM feedback;
---There are 6200 rows in feedback table
     SELECT * FROM sessions;
     SELECT COUNT(*) FROM sessions;
---There are 229806 rows in sessions table

   SELECT * FROM subscriptions;
   SELECT COUNT(*) FROM subscriptions;
 ---There are 18280 rows in subscriptions table

    SELECT * FROM support_tickets;
    SELECT COUNT(*) FROM support_tickets;
--There are 1906 rows in support_tickets

    SELECT * FROM system_metrics;
    SELECT COUNT(*) FROM system_metrics;
--There are 2857 rows in system_metrics

    SELECT * FROM users;
    SELECT COUNT(*) FROM users;
--There are 10623 rows in users




--STEP 2:COUNTING NULLS
SELECT * FROM activity_log;
SELECT SUM(CASE WHEN activity_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_activity_id,
SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_session_id,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_id,
SUM(CASE WHEN activity_type IS NULL THEN 1 ELSE 0 END) AS nulls_in_activity_type,
SUM(CASE WHEN activity_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_timestamp
FROM activity_log;
--All columns has 0 nulls.

SELECT * FROM billing;
SELECT SUM(CASE WHEN billing_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_activity_id,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_session_id,
SUM(CASE WHEN billing_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_id,
SUM(CASE WHEN plan_type IS NULL THEN 1 ELSE 0 END) AS nulls_in_activity_type,
SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS nulls_in_timestamp,
SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) AS nulls_in_currency,
SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS nulls_in_status,
SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS nulls_in_payment_method
FROM billing;
--All columns has 0 nulls except activity_type(24 nulls) and 2 nulls in timestamp

SELECT SUM(CASE WHEN feature_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_feature_id,
SUM(CASE WHEN feature_name IS NULL THEN 1 ELSE 0 END) AS nulls_in_feature_name,
SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category,
SUM(CASE WHEN launch_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_launch_date,
SUM(CASE WHEN available_plans IS NULL THEN 1 ELSE 0 END) AS nulls_in_available_plans
FROM features;
--All column has 0 nulls


SELECT SUM(CASE WHEN feedback_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_feedback_id,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_ID,
SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS session_id,
SUM(CASE WHEN submission_timestamp IS NULL THEN 1 ELSE 0 END) AS nulls_in_submission_timestamp,
SUM(CASE WHEN comment_type IS NULL THEN 1 ELSE 0 END) AS nulls_in_comment_type,
SUM(CASE WHEN comment IS NULL THEN 1 ELSE 0 END) AS nulls_in_comment,
SUM(CASE WHEN feature_area IS NULL THEN 1 ELSE 0 END) AS nulls_in_feature_area
FROM feedback;
---We have 0 nulls in all column, except 48 nulls in comment, and 1870 nulls in feature_area

SELECT SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_session_id,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_id,
SUM(CASE WHEN login_time IS NULL THEN 1 ELSE 0 END) AS nulls_in_login_time,
SUM(CASE WHEN logout_time IS NULL THEN 1 ELSE 0 END) AS nulls_in_logout_time,
SUM(CASE WHEN device_type IS NULL THEN 1 ELSE 0 END) AS nulls_in_device_type
FROM sessions;
--All columns has 0 nulls except device type column that has 10699 nulls

SELECT SUM(CASE WHEN subscription_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_subscription_id,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_id,
SUM(CASE WHEN plan IS NULL THEN 1 ELSE 0 END) AS nulls_in_plan,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS nulls_in_duration,
SUM(CASE WHEN start_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_start_date,
SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_end_date,
SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS nulls_in_status
FROM subscriptions;
--There are 35 nulls in plan. And 0 nulls in the rest of the column

SELECT SUM(CASE WHEN ticket_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_ticket_id,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_id,
SUM(CASE WHEN feature IS NULL THEN 1 ELSE 0 END) AS nulls_in_feature,
SUM(CASE WHEN submitted_at IS NULL THEN 1 ELSE 0 END) AS nulls_in_submitted_at,
SUM(CASE WHEN priority IS NULL THEN 1 ELSE 0 END) AS nulls_in_priority,
SUM(CASE WHEN resolved IS NULL THEN 1 ELSE 0 END) AS nulls_in_resolved,
SUM(CASE WHEN resolved_at IS NULL THEN 1 ELSE 0 END) AS nulls_in_resolved_at,
SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS nulls_in_status
FROM support_tickets;

--There are 938 nulls in resolved_at column

SELECT SUM(CASE WHEN timestamp IS NULL THEN 1 ELSE 0 END) AS nulls_in_timestamp,
SUM(CASE WHEN active_users IS NULL THEN 1 ELSE 0 END) AS nulls_in_active_users,
SUM(CASE WHEN request_count IS NULL THEN 1 ELSE 0 END) AS nulls_in_request_count,
SUM(CASE WHEN error_count IS NULL THEN 1 ELSE 0 END) AS nulls_in_error_count,
SUM(CASE WHEN error_rate IS NULL THEN 1 ELSE 0 END) AS nulls_in_error_rate,
SUM(CASE WHEN cpu_usage IS NULL THEN 1 ELSE 0 END) AS nulls_in_cpu_usage,
SUM(CASE WHEN memory_usage IS NULL THEN 1 ELSE 0 END) AS nulls_in_memory_usage,
SUM(CASE WHEN response_time IS NULL THEN 1 ELSE 0 END) AS nulls_in_response_time
FROM system_metrics;

--There are 0 nulls counts in system_metrics


SELECT SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS nulls_in_user_id,
SUM(CASE WHEN full_name IS NULL THEN 1 ELSE 0 END) AS nulls_in_full_name,
SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS null_in_email,
SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS nulls_in_location,
SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_in_age,
SUM(CASE WHEN plan_type IS NULL THEN 1 ELSE 0 END) AS null_in_plan_type,
SUM(CASE WHEN sign_up_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_sign_up_date,
SUM(CASE WHEN is_active IS NULL THEN 1 ELSE 0 END) AS nulls_in_is_active,
SUM(CASE WHEN churn_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_churn_date,
SUM(CASE WHEN last_login_date IS NULL THEN 1 ELSE 0 END) AS nulls_in_last_login_date
FROM users;
--There are 28 nulls in full_name, 516 nulls in email, 535 nulls in location, 54 nulls in age, 17 nulls in plan_type,9314 nulls in churn_date,0 nulls for the rest.


SELECT * FROM users;

SELECT * FROM support_tickets;

SELECT * FROM subscriptions;

SELECT * FROM sessions;

SELECT * FROM feedback;

SELECT * FROM features;

SELECT * FROM feedback;


SELECT * FROM feedback;


--Quantify weekly retention rates of users who adopted the features within
--7 days of launch
 SELECT * FROM activity_log;
SELECT * FROM features
WHERE launch_date = '2025-02-20'

--Compare the retention rate of adopters vs non-adopters
SELECT * FROM users;
--Analyze whether engaging with new features lead to increased user retention and sustained
--engagement overtime

--Checking the percentage of nulls in each table
SELECT COUNT(*) AS All_rows, COUNT(user_id) AS user_cnt FROM users;
--Note:COUNT(*) will count all rows including nulls, COUNT(user_id) will exclude nulls
--When using 'UNION ALL', the columns you are stacking has to be the same
SELECT 'user_id' AS user_id,
ROUND((COUNT(*) - COUNT(user_id)) * 100.0/ COUNT(*),2) AS percentage_of_nulls
FROM users

UNION ALL

SELECT 'first_name' AS first_name,
ROUND((COUNT(*) - COUNT(first_name)) * 100.0/ COUNT(*),2) AS percentage_of_nulls
FROM users

UNION ALL

SELECT 'last_name' AS last_name,
ROUND((COUNT(*) - COUNT(last_name)) * 100.0/ COUNT(*),2) AS percentage_of_nulls
FROM users

UNION ALL

SELECT 'email' AS email,
ROUND((COUNT(*) - COUNT(email)) * 100.0/ COUNT(*),2) AS percentage_of_nulls
FROM users

UNION ALL
SELECT 'location' AS location,
ROUND((COUNT(*) - COUNT(location)) * 100.0/ COUNT(*),2) AS percentage_of_nulls
FROM users



--STEP 3:CHECKING FOR DUPLICATE VALUES
select * from users

SELECT user_id, COUNT(*) AS Cnt
FROM Users
GROUP BY 1
HAVING  COUNT(*)>1;

SELECT full_name, COUNT(*) AS Cnt
FROM Users
GROUP BY 1
HAVING  COUNT(*)>1;

-- TO KEEP DUPLICATES AND FLAG THEM(Note we have use google sheet to remove duplicate from User table before. The query below should return 0 column)

WITH ranked_users AS (
  SELECT *,
    ROW_NUMBER() OVER(
      PARTITION BY user_id, last_name, email, location, age, plan_type, sign_up_date, is_active, churn_date, last_login_date
    ) AS rowN
  FROM users
)
SELECT *
FROM ranked_users
WHERE rowN > 1;


SELECT session_id, COUNT(*) AS Cnt
FROM sessions
GROUP BY 1
HAVING  COUNT(*)>1;

--STEP 4:REMOVING DUPLICATES

WITH CTE AS(SELECT *, ROW_NUMBER() OVER (PARTITION BY session_id, user_id, login_time,logout_time,device_type ORDER BY(SELECT null))AS rowN
FROM sessions)
SELECT session_id, user_id, login_time,logout_time,device_type
INTO clean_sessions
FROM CTE
WHERE rowN =1;

--Checking for accuracy
SELECT session_id, COUNT(*) AS Cnt
FROM clean_sessions
GROUP BY 1
HAVING  COUNT(*)>1;
--result of check:We still have duplicates
WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY login_time ASC)AS rowN
FROM clean_sessions)

SELECT session_id, user_id, login_time,logout_time,device_type
INTO sessions1
FROM CTE
WHERE rowN =1;
--Another check
SELECT session_id, COUNT(*) AS Cnt
FROM sessions1
GROUP BY 1
HAVING  COUNT(*)>1;

--Result: no more duplicates

SELECT * FROM sessions;
ALTER TABLE sessions1 RENAME TO sessions;


SELECT * FROM users;
SELECT user_id, COUNT(*) AS Cnt
FROM users
GROUP BY 1
HAVING  COUNT(*)>1;


--STEP 5:CHECKING THE DATA TYPES
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'users'

--ADDING PRIMARY KEYS TO A TABLE
ALTER TABLE sessions
ADD CONSTRAINT pk_sessionid PRIMARY KEY (session_id)

---ADDING LENGTH TO THE COLUMN OF A TABLE
ALTER TABLE users
ALTER COLUMN user_id TYPE VARCHAR(255),
ALTER COLUMN user_id SET NOT NULL;

SELECT * FROM sessions;

--STEP 6:CHECKING TRAILING AND LEADING SPACES

SELECT * FROM users;

SELECT full_name, LENGTH(full_name) Original_length, LENGTH(Trim(full_name)) Trimmed_length, Trim(full_name) cleaned_name
FROM users
WHERE LENGTH(full_name) <>LENGTH(Trim(full_name));

--The output show that there is no trailing space

---STEP 7:CHECKING FOR INVALID NUMBERS
SELECT user_id, full_name, age
FROM users
WHERE
    (age ~ '^\d+$')  -- Ensure age is numeric (if stored as TEXT)
    AND (CAST(age AS INTEGER) < 16 OR CAST(age AS INTEGER) > 90);



UPDATE users
SET age = NULL
WHERE (age::int <= 16 OR age::int >= 90);


SELECT DISTINCT age
FROM users
WHERE age !~ '^\d+$';

UPDATE users
SET age = NULL
WHERE age !~ '^\d+$';

ALTER TABLE users
ALTER COLUMN age TYPE integer USING age::integer;

--CHECKING IF THE AGE IS A NUMERIC OR NOT
SELECT *
FROM users
WHERE age::text !~ '^\d+$';
--Note: !~ '^\d+$' is for regex checking

--STEP 8:CHECKING FOR INVALID DATE RANGES
SELECT * FROM users
WHERE churn_date < sign_up_date and churn_date <> sign_up_date;
--Note: churn date should not be less than sign up date. They have to firstly sign up before churning
--Taking care of the invalid date ranges. We are setting churn_date to be equal to sign_up_date
UPDATE users
SET churn_date = sign_up_date
WHERE churn_date < sign_up_date and churn_date <> sign_up_date;

--Another checking
SELECT * FROM users
WHERE churn_date < sign_up_date and churn_date <> sign_up_date;
--The output should be empty

SELECT DISTINCT status
FROM subscriptions;

---SPEP 9:STANDARDIZING PLAN TYPES
SELECT DISTINCT plan_type
FROM billing;
--updating billing
UPDATE billing
SET plan_type =
CASE WHEN plan_type = 'Basicc' THEN 'Basic'
WHEN plan_type IN('Enterpris','Bronze', 'Pro Plus')THEN 'Enterprise'
ELSE plan_type END;

SELECT DISTINCT plan_type FROM billing;

--UPDATING USERS
--checking
SELECT DISTINCT plan_type FROM users;

UPDATE users
SET plan_type =
CASE WHEN plan_type = 'Basicc' THEN 'Basic'
WHEN plan_type IN('Enterpris','Bronze', 'Pro Plus')THEN 'Enterprise'
ELSE plan_type END;

--Another checking, the output should be the updated plan:
SELECT DISTINCT plan_type FROM users;


--UPDATING SUBSCRIPTIONS
SELECT DISTINCT plan FROM subscriptions;

UPDATE subscriptions
SET plan =
CASE WHEN plan = 'Basicc' THEN 'Basic'
WHEN plan IN('Enterpris','Bronze', 'Pro Plus')THEN 'Enterprise'
ELSE plan END;

SELECT * FROM billing
WHERE plan_type = 'Basic' and currency = 'NGN' and amount <> 15000;

SELECT * FROM billing
WHERE plan_type= 'Pro Plus';


--Standardizing payments by updating our tables.
--For Naira:
UPDATE Billing
SET amount=
CASE WHEN plan_type = 'Basic' and currency = 'NGN' Then  15000
WHEN plan_type = 'Pro'  and currency = 'NGN' Then 55000
WHEN plan_type = 'Enterprise'  and currency = 'NGN' Then 283500
ELSE amount END;

--USD:
UPDATE billing
SET amount =
CASE
    WHEN plan_type = 'Basic' AND currency = 'USD' THEN 10
    WHEN plan_type = 'Pro' AND currency = 'USD' THEN 37
    WHEN plan_type = 'Enterprise' AND currency = 'USD' THEN  189
    ELSE amount
END;

UPDATE billing SET plan_type = CASE
    WHEN currency = 'USD' AND amount <= 10 THEN 'Basic' -- Corrected: currency = 'USD'
    WHEN currency = 'USD' AND amount = 37 THEN 'Pro'    -- Corrected: currency = 'USD'
    WHEN currency = 'USD' AND amount = 189 THEN  'Enterprise' -- Corrected: currency = 'USD'
    ELSE plan_type
END;

SELECT * from billing
WHERE plan_type = 'Enterprise' AND currency = 'GBP';

-- Note: 'GPB' typo for 'GBP' in the Enterprise condition
UPDATE billing SET amount =  CASE
    WHEN plan_type = 'Basic' AND currency = 'GBP' THEN 7.5
    WHEN plan_type = 'Pro' AND currency = 'GBP' THEN 27.5
    WHEN plan_type = 'Enterprise' AND currency = 'GBP' THEN  141.75 -- Corrected typo from GPB to GBP
    ELSE amount
END;

SELECT * from billing
WHERE plan_type = 'Enterprise' AND currency = 'INR';

UPDATE billing SET amount =  CASE
    WHEN plan_type = 'Basic' AND currency = 'INR' THEN 750
    WHEN plan_type = 'Pro' AND currency = 'INR' THEN 2775
    WHEN plan_type = 'Enterprise' AND currency = 'INR' THEN 14175
    ELSE amount
END;

-- Standardize 'currency' values in the 'billing' table
UPDATE billing SET currency =
CASE
    WHEN currency IN ('USS','XYZ') THEN 'USD' -- Consolidate variations to 'USD'
    WHEN currency IN ('EURo','EUR') THEN 'EURO' -- Consolidate variations to 'EURO'
    WHEN currency = 'NGNN' THEN 'NGN' -- Correct typo for 'NGN'
    WHEN currency IS NULL THEN 'Unknown' -- Replace NULL with 'Unknown'
    ELSE currency -- Keep other values as they are
END;

-- Standardize 'amount' in 'billing' based on 'plan_type' and 'currency' (EURO)
UPDATE billing SET amount = CASE
    WHEN plan_type = 'Basic' AND currency = 'EURO' THEN 9.20
    WHEN plan_type = 'Pro' AND currency = 'EURO' THEN 34.04
    WHEN plan_type = 'Enterprise' AND currency = 'EURO' THEN  173.89
    ELSE amount
END;

UPDATE billing SET amount =
CASE
    WHEN plan_type = 'Basic' AND payment_method = 'paypal' THEN NULL
    ELSE amount
END
WHERE amount <= 0; -- Condition applies to rows where amount is non-positive

--STEP 10:CHECKING FOR NEGATIVES IN OUR BILLING
SELECT * FROM billing
WHERE amount <=0;

-- Set 'amount' to NULL for Basic plan with paypal if amount is zero or negative.
-- This logic might need review for its specific business meaning.
UPDATE billing SET amount = CASE
    WHEN plan_type = 'Basic' AND payment_method = 'paypal' THEN NULL
    ELSE amount
END
WHERE amount <= 0; -- Condition applies to rows where amount is non-positive

ALTER TABLE billing
ALTER COLUMN amount DROP NOT NULL

--STEP 11:CHECKING FOR INVALID FOREIGN KEYS

SELECT user_id FROM support_tickets WHERE user_id NOT IN (SELECT user_id FROM users);

--CHECKING DISTINCT STATUS FROM SUBSCRIPTION
Select distinct status
from subscription;

--Retreive all users for inspections
Select * from users;

-- STEP 12:FEATURE ENGINEERING:
--SPLITTING 'full_name' into 'first_name' and 'last_name'
ALTER TABLE users
Add First_name VARCHAR(55),
Add Last_name VARCHAR(55);


UPDATE users
SET first_name = SPLIT_PART(full_name, ' ',1),
last_name =
CASE
    WHEN full_name LIKE '% %' THEN SUBSTRING(full_name FROM POSITION(' ' IN full_name) +1)
    ELSE NULL
END;

--Dropping FULLNAME column
ALTER TABLE users
DROP COLUMN full_name;


--REORDERING COLUMNS
/* To reorder columns (e.g., place first_name and last_name in the original position of full_name), you need to:
Option 1: Recreate the table in the desired column order
*/
CREATE TABLE users_new AS
SELECT
    user_id,
    first_name,
    last_name,
    email,
    location,
    age,
    plan_type,
    sign_up_date,
    is_active,
    churn_date,
    last_login_date
FROM users;
--Then:
DROP TABLE users;
ALTER TABLE users_new RENAME TO users;

SELECT * FROM users;
/*Measure the weekly retention rate of users who adopted at least one of the
features within 7 days of launch and compare it with retention rates of users who
do not engage with the features.
*/
---TO FIND NEW FEATURE LAUNCHED
SELECT * FROM Features
WHERE launch_date= '2-20-2025';


--TO FIND ELIGIBLE USERS
WITH eligible_users AS (SELECT user_id from users
where sign_up_date < '2-20-2025' and (churn_date > '2-20-2025' OR churn_date IS NULL));
--This users signed up before launch date and churned after launch date or did not churn

Select   user_id from activity_log where activity_type IN('Task_reminders', 'voice_assistant', 'custom_themes');


CREATE INDEX id_cx ON sales(amount)

--STEP 13:DEDUPLICATION
WITH CTE AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY session_id, user_id, login_time,logout_time,device_type ORDER BY (SELECT null))row_n
FROM Sessions)
SELECT session_id, user_id, login_time,logout_time,device_type
INTO new_sessions
FROM CTE
WHERE row_n = 1;

--CHECKING DUPLICATES
SELECT session_id, COUNT(*) as all_count
FROM sessions
group by 1
Having COUNT(*) > 1

--CHECKING  COLUMNS DATA TYPE
SELECT column_name, data_type from information_schema.columns
where table_name = 'users'

--CHECKING NULLS
SELECT SUM(CASE WHEN feedback_id IS NULL THEN 1 ELSE 0 END)as feedback_null,
SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END)as user_id_null
FROM feedback
