# 🔍 Exploratory Data Analysis w/ SQL: Job Market Analytics

![Project 1 Overview](/Exploratory-Data-Analysis/1_EDA/1_1_Project_EDA.png)

This project delivers a data-driven market analysis of the **Remote Data Engineering** job market. By leveraging analytical SQL queries on a star-schema data warehouse, this repository identifies which skills offer the highest market demand, command premium compensation, and provide the **optimal career ROI** for Data Engineers.

Rather than relying purely on raw skill counts or basic averages, this analysis introduces a **custom mathematical scoring metric** that balances market volume against median annual salary to uncover true high-value skills.

---

## 📊 Key Findings & Business Insights

> 💡 **Executive Summary:** SQL and Python are non-negotiable baseline requirements, but specialized cloud and big data tooling yield the highest financial compensation.

- 🧠 **Baseline Competency:** SQL and Python dominate overall volume, appearing in over 80% of analyzed data engineering postings.
- 💰 **Premium Compensations:** Infrastructure-as-Code and Big Data engines (e.g., Terraform, Apache Spark, Kubernetes) command median salaries exceeding $130,000+.
- 🎯 **Optimal ROI Skills:** AWS, Python, and SQL achieved the highest **Optimal Skill Scores**, offering the safest balance of high job availability and upper-tier compensation.

---

## 🧩 Data Architecture & Schema

This analysis queries a relational data warehouse modeled using a **Star Schema** design:

![Data Warehouse Schema](/Exploratory-Data-Analysis/1_EDA/1_2_Data_Warehouse.png)

- **Fact Table:** `job_postings_fact` – Stores individual job posting metadata, including salary averages, job titles, and remote statuses. (Grain: One row per job posting).
- **Dimension Table:** `skills_dim` – Catalog containing individual skill names and categorization.
- **Bridge Table:** `skills_job_dim` – Resolves the many-to-many relationship between job postings and skills.

---

## 🎯 Analytical Modules & Query Architecture

The project is structured into three progressive analytical modules:

1. **[`01_top_demanded_skills.sql`](./01_top_demanded_skills.sql) — Volume & Market Demand Analysis**
   - **Goal:** Identify the most frequently requested skills in remote Data Engineer job postings.
   - **Methodology:** Performs multi-table `INNER JOIN` operations across `job_postings_fact`, `skills_job_dim`, and `skills_dim` to aggregate total posting volume (`COUNT(*)`) per skill.

2. **[`02_top_paying_skills.sql`](./02_top_paying_skills.sql) — Compensation & Salary Analysis**
   - **Goal:** Determine which skills command the highest median annual compensation (`salary_year_avg`).
   - **Methodology:** Computes `MEDIAN(salary_year_avg)` per skill with sample threshold filtering.

3. **[`03_optimal_skills.sql`](./03_optimal_skills.sql) — High-Value Skill Optimization Score**
   - **Goal:** Uncover "sweet spot" skills balancing market availability and high salary.
   - **Methodology:** Implements a custom **Optimal Skill Score**:
     $$\text{Optimal Score} = \frac{\text{MEDIAN}(\text{salary}) \times \ln(\text{demand\_count})}{1,000,000}$$

---

## 🛡️ Data Quality, Assumptions & Caveats

To enforce analytical rigor and manage data anomalies, the following guardrails were implemented:

- **Scope Control:** Restricts analysis strictly to `job_title_short = 'Data Engineer'` and `job_work_from_home = True` to isolate remote market benchmarks.
- **Null Compensation Handling:** Explicitly excludes records where `salary_year_avg IS NOT NULL` in financial queries to avoid skewing median aggregations.
- **Statistical Significance Threshold:** Applies a `HAVING COUNT(*) > 100` cutoff across salary queries to eliminate low-frequency outlier skills.
- **Mathematical Normalization:** Uses Natural Logarithm (`LN`) on raw demand counts to prevent high-frequency skills (e.g., 29,000+ postings) from completely overpowering salary values in the optimization metric.
- **Dataset Limitation:** Only ~15–20% of job postings explicitly disclose compensation figures, introducing potential salary transparency bias.

---

## ⚙️ Setup & Execution Instructions

### Execution Context & Assumptions

The SQL scripts in this repository are written in **DuckDB / ANSI-SQL dialect**. They assume a database instance populated with the star-schema job market dataset (or a direct connection to a DuckDB/MotherDuck endpoint) is already initialized.

### Author's Development Environment

This project was developed using a modern, containerized cloud-data workflow:

- **Database Engine:** [MotherDuck](https://motherduck.com/) (Serverless Cloud DuckDB)
- **Containerization:** **Docker Compose** managing the local development environment
- **IDE & Client:** VS Code connected via SQL tools to the MotherDuck instance

---

### Steps to Reproduce

#### Option 1: Quick Local Run (For Reviewers with Local DuckDB)

If you have a local `data_jobs.db` file or DuckDB CLI installed:

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
   cd your-repo-name/1_EDA
   ```
