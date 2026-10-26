# Hospital Analytics: SQL & Power BI

## Project Overview
This project analyzes hospital patient records using MySQL and Power BI to identify trends in patient encounters, healthcare costs, payer coverage, procedures, and readmissions.

The analysis was completed in MySQL using SQL techniques including aggregation, conditional logic, date functions, JOINs, and self-joins to explore utilization, cost, payer, and readmission patterns.

## Tools Used
- **MySQL / MySQL Workbench** — database creation, data querying, analysis, and validation
- **Power BI** — data modeling, DAX measures, and interactive dashboard development
- **GitHub** — project documentation and portfolio presentation

## SQL Analysis
The SQL analysis focused on several areas of hospital operations and patient utilization

- Encounter volume and trends over time
- Encounter class distribution and encounter duration
- Payer coverage and average claim costs
- Most frequent and highest-cost procedures
- Unique patient activity over time
- 30-day readmissions and patients with the highest readmission counts

The analysis also included validation checks to confirm unusual results and ensure the outputs were consistent with the underlying encounter data.

## Power BI Dashboard
The Power BI report contains two dashboard pages

**Hospital Operations Overview** — summarizes total encounters, unique patients, average claim cost, zero payer coverage, encounter trends by year and month, and encounter class distribution.

**Cost & Patient Insights** — highlights average claim cost by payer, payer coverage rates, the most frequently performed procedures, and unique patient trends over time.

The dashboard was built using relationships between the patients, encounters, payers, and procedures tables, along with DAX measures for key performance indicators and summary metrics.

## Key Findings
- The dataset contains 27,891 hospital encounters across 974 unique patients.
- 48.71% of encounters had zero payer coverage, indicating a large share of encounters with no recorded payer contribution.
- The average total claim cost per encounter was approximately $3,639.68.
- Encounter volume varied considerably by year, with 2014 recording the highest annual volume at 3,885 encounters.
- 770 patients had at least one subsequent encounter within 30 days of a previous encounter.
- Readmission analysis identified several patients with unusually high repeat encounter counts, which were reviewed with additional validation queries.

## Data Notes
- The dataset covers records from 2011 through February 2022.
- 2022 represents a partial year and should not be directly compared with complete prior years.

## Data Source
Dataset: Maven Analytics — Hospital Patient Records

The source dataset is organized into five areas

- Encounters 
- Organizations
- Patients
- Payers
- Procedures

The analysis used the encounters, patients, payers, and procedures data to examine hospital utilization, patient activity, healthcare costs, payer coverage, and procedure trends.
