/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT 
    sd.skills, 
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
   -- COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)),1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY optimal_score DESC
LIMIT 25;

SELECT AVG (90,78, 95, 88, 92) AS average_score;


/*
Results:
┌────────────┬───────────────┬──────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ optimal_score │
│  varchar   │    double     │    int64     │    double     │
├────────────┼───────────────┼──────────────┼───────────────┤
│ sql        │      125000.0 │          569 │    71125000.0 │
│ python     │      130000.0 │          534 │    69420000.0 │
│ aws        │      133000.0 │          368 │    48944000.0 │
│ spark      │      136410.0 │          238 │ 32465617.1875 │
│ azure      │      127500.0 │          254 │    32385000.0 │
│ snowflake  │      130000.0 │          205 │    26650000.0 │
│ airflow    │      137320.0 │          151 │ 20735367.1875 │
│ kafka      │      142500.0 │          136 │    19380000.0 │
│ java       │      132500.0 │          141 │    18682500.0 │
│ redshift   │      130000.0 │          141 │    18330000.0 │
│ databricks │      128750.0 │          132 │    16995000.0 │
│ scala      │      135000.0 │          114 │    15390000.0 │
│ hadoop     │      135000.0 │          102 │    13770000.0 │
│ nosql      │      136250.0 │           94 │    12807500.0 │
│ sql server │      120000.0 │           82 │     9840000.0 │
│ gcp        │      130000.0 │           75 │     9750000.0 │
│ git        │      127500.0 │           75 │     9562500.0 │
│ pyspark    │      140000.0 │           63 │     8820000.0 │
│ tableau    │      114500.0 │           77 │     8816500.0 │
│ docker     │      134415.0 │           65 │     8736975.0 │
│ oracle     │      123500.0 │           63 │     7780500.0 │
│ kubernetes │      142500.0 │           54 │     7695000.0 │
│ power bi   │      116000.0 │           65 │     7540000.0 │
│ ssis       │      115000.0 │           61 │     7015000.0 │
│ mysql      │      130500.0 │           53 │     6916500.0 │
└────────────┴───────────────┴──────────────┴───────────────┘




New data results from latest SQL:
┌────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    double     │     double      │    double     │
├────────────┼───────────────┼─────────────────┼───────────────┤
│ python     │      130000.0 │             6.3 │          0.82 │
│ aws        │      133000.0 │             5.9 │          0.79 │
│ sql        │      125000.0 │             6.3 │          0.79 │
│ spark      │      136410.0 │             5.5 │          0.75 │
│ azure      │      127500.0 │             5.5 │          0.71 │
│ kafka      │      142500.0 │             4.9 │           0.7 │
│ airflow    │      137320.0 │             5.0 │          0.69 │
│ snowflake  │      130000.0 │             5.3 │          0.69 │
│ java       │      132500.0 │             4.9 │          0.66 │
│ redshift   │      130000.0 │             4.9 │          0.64 │
│ scala      │      135000.0 │             4.7 │          0.64 │
│ databricks │      128750.0 │             4.9 │          0.63 │
│ hadoop     │      135000.0 │             4.6 │          0.62 │
└────────────┴───────────────┴─────────────────┴───────────────┘

*/