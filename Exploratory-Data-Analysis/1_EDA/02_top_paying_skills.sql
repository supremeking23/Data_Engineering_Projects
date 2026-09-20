/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing 
    how common those skills are, providing a more complete picture for skill development priorities
*/

SELECT 
    sd.skills, 
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim as sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY median_salary DESC
LIMIT 25;


/*
Insights: -- made need our own insights based on the results that we have.

Here's a breakdown of the highest-paying skills for Data Engineers:

Key Insights:
- Rust remains the top-paying skill at $210K median salary, though demand is still relatively limited (232 postings).
- Terraform and Golang both have high median salaries at $184K, with strong demand (Terraform: 3,248 postings; Golang: 912 postings).
- Other notable skills with both high pay and moderate-to-high frequency include:
  - Spring: $175.5K median salary (364 postings)
  - Neo4j: $170K median salary (277 postings)
  - GDPR: $169.6K median salary (582 postings)
  - GraphQL: $167.5K median salary (445 postings)
  - Kubernetes: $150.5K median salary (4,202 postings)
  - Airflow: $150K median salary (9,996 postings)
- Bitbucket, Ruby, Redis, Ansible, and Jupyter all appear in the top 25 for pay, each with hundreds of postings.
- Most skills on the list are no longer extreme statistical outliers with just a handful of postings; instead, many show consistently strong demand.

Takeaway: While the very top-paying skill (Rust) still has less demand than major cloud and data tools, most of the top-paying skills have both solid salaries and


Results:
├───────────────┼───────────────┼──────────────┤
│ mongo         │      190128.0 │          178 │
│ neo4j         │      179988.0 │          130 │
│ express       │      171875.0 │          124 │
│ graphql       │      170938.0 │          201 │
│ bitbucket     │      167500.0 │          223 │
│ splunk        │      157500.0 │          156 │
│ microstrategy │      157500.0 │          169 │
│ fastapi       │      157500.0 │          106 │
│ cassandra     │      155000.0 │          652 │
│ jupyter       │      155000.0 │          238 │
│ redis         │      151000.0 │          317 │
│ css           │      150000.0 │          134 │
│ typescript    │      150000.0 │          204 │
│ ruby          │      150000.0 │          184 │
│ perl          │      148750.0 │          127 │
│ ansible       │      147500.0 │          283 │
│ node.js       │      147500.0 │          155 │
│ golang        │      145750.0 │          318 │
│ terraform     │      145000.0 │         1529 │
│ db2           │      144482.0 │          244 │
│ tensorflow    │      142500.0 │          287 │
│ kubernetes    │      142500.0 │         2107 │
│ kafka         │      142500.0 │         3438 │
│ react         │      140000.0 │          260 │
│ mongodb       │      140000.0 │          956 │
└───────────────┴───────────────┴──────────────┘
/*
