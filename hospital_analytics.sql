USE hospital_db;

SELECT 'encounters' AS table_name, COUNT(*) AS row_count FROM encounters
UNION ALL
SELECT 'patients', COUNT(*) FROM patients
UNION ALL
SELECT 'payers', COUNT(*) FROM payers
UNION ALL
SELECT 'procedures', COUNT(*) FROM procedures;

DESCRIBE encounters;

SELECT*
FROM encounters
LIMIT 10;

SELECT
	START,
	YEAR(START) AS encounter_year
FROM encounters
LIMIT 10;

-- Objective 1a: How many total encounters occurred each year?
SELECT
	YEAR(START) AS encounter_year,
	COUNT(*) AS total_encounters
FROM encounters
GROUP BY YEAR (START)
ORDER BY encounter_year;

-- Objective 1b: For each year, what percentage of all encounters belonged to each encounter class?
SELECT DISTINCT ENCOUNTERCLASS
FROM encounters
ORDER BY ENCOUNTERCLASS;

SELECT
    YEAR(START) AS encounter_year,
    ENCOUNTERCLASS,
    COUNT(*) AS total_encounters
FROM encounters
GROUP BY
    YEAR(START),
    ENCOUNTERCLASS
ORDER BY
    encounter_year,
    ENCOUNTERCLASS;
    
SELECT
    YEAR(START) AS encounter_year,

    ROUND(
        SUM(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS ambulatory_pct,

    ROUND(
        SUM(CASE WHEN ENCOUNTERCLASS = 'emergency' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS emergency_pct,

    ROUND(
        SUM(CASE WHEN ENCOUNTERCLASS = 'inpatient' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS inpatient_pct,

    ROUND(
        SUM(CASE WHEN ENCOUNTERCLASS = 'outpatient' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS outpatient_pct,

    ROUND(
        SUM(CASE WHEN ENCOUNTERCLASS = 'urgentcare' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS urgentcare_pct,

    ROUND(
        SUM(CASE WHEN ENCOUNTERCLASS = 'wellness' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS wellness_pct

FROM encounters
GROUP BY YEAR(START)
ORDER BY encounter_year;

-- Objective 1c: What percentage of encounters were over 24 hours versus under 24 hours?
SELECT
    CASE
        WHEN TIMESTAMPDIFF(MINUTE, START, STOP) > 1440 THEN 'Over 24 Hours'
        ELSE '24 Hours or Less'
    END AS duration_group,
    COUNT(*) AS total_encounters
FROM encounters
GROUP BY duration_group;

SELECT
    ROUND(
        SUM(CASE
            WHEN TIMESTAMPDIFF(MINUTE, START, STOP) > 1440 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS over_24_hours_pct,

    ROUND(
        SUM(CASE
            WHEN TIMESTAMPDIFF(MINUTE, START, STOP) <= 1440 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS 24_hours_or_less_pct

FROM encounters;

-- Objective 2a: How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT
    SUM(CASE
        WHEN PAYER_COVERAGE = 0 THEN 1
        ELSE 0
    END) AS zero_coverage_encounters,

    ROUND(
        SUM(CASE
            WHEN PAYER_COVERAGE = 0 THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS zero_coverage_pct

FROM encounters;

-- Objective 2b: What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT
    DESCRIPTION AS procedure_name,
    COUNT(*) AS times_performed,
    ROUND(AVG(BASE_COST), 2) AS average_base_cost
FROM procedures
GROUP BY DESCRIPTION
ORDER BY times_performed DESC
LIMIT 10;

-- Objective 2c: What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT
    DESCRIPTION AS procedure_name,
    ROUND(AVG(BASE_COST), 2) AS average_base_cost,
    COUNT(*) AS times_performed
FROM procedures
GROUP BY DESCRIPTION
ORDER BY average_base_cost DESC
LIMIT 10;

-- Objective 2d: What is the average total claim cost for encounters, broken down by payer?
SELECT
    p.NAME AS payer_name,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 2) AS average_total_claim_cost
FROM encounters e
JOIN payers p
    ON e.PAYER = p.Id
GROUP BY p.NAME
ORDER BY average_total_claim_cost DESC;

-- Objective 3a: How many unique patients were admitted each quarter over time?
SELECT
    YEAR(START) AS encounter_year,
    QUARTER(START) AS encounter_quarter,
    COUNT(DISTINCT PATIENT) AS unique_patients
FROM encounters
GROUP BY
    YEAR(START),
    QUARTER(START)
ORDER BY
    encounter_year,
    encounter_quarter;
    
-- Objective 3b: How many patients were readmitted within 30 days of a previous encounter?
SELECT
    COUNT(DISTINCT later.PATIENT) AS patients_readmitted_within_30_days
FROM encounters earlier
JOIN encounters later
    ON earlier.PATIENT = later.PATIENT
WHERE
    later.START > earlier.STOP
    AND later.START <= DATE_ADD(earlier.STOP, INTERVAL 30 DAY);

-- Objective 3c: Which patients had the most readmissions?
SELECT
    later.PATIENT AS patient_id,
    COUNT(DISTINCT later.Id) AS readmission_count
FROM encounters earlier
JOIN encounters later
    ON earlier.PATIENT = later.PATIENT
WHERE
    later.START > earlier.STOP
    AND later.START <= DATE_ADD(earlier.STOP, INTERVAL 30 DAY)
GROUP BY later.PATIENT
ORDER BY readmission_count DESC
LIMIT 10;

-- Checking validity of patient with over 1000 readmission count
SELECT
    PATIENT AS patient_id,
    COUNT(*) AS total_encounters
FROM encounters
WHERE PATIENT = '1712d26d-822d-1e3a-2267-0a9dba31d7c8'
GROUP BY PATIENT;
-- Patient has 1381 total encounters, which validated the 1375 readmission count.

-- ADDITIONAL ANALYSIS --
-- Q1: Which encounter classes have the highest average total claim cost?
SELECT
    ENCOUNTERCLASS AS encounter_class,
    ROUND(AVG(TOTAL_CLAIM_COST), 2) AS average_total_claim_cost
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY average_total_claim_cost DESC;

-- Q2: Which months had the highest number of encounters?
SELECT
    MONTHNAME(START) AS month_name,
    COUNT(*) AS total_encounters
FROM encounters
GROUP BY
    MONTH(START),
    MONTHNAME(START)
ORDER BY total_encounters DESC;

-- Q3: Which payers provided the highest total amount of coverage?
SELECT
    payers.NAME AS payer_name,
    ROUND(SUM(encounters.PAYER_COVERAGE), 2) AS total_payer_coverage,
    COUNT(*) AS total_encounters
FROM encounters
JOIN payers
    ON encounters.PAYER = payers.Id
GROUP BY payers.NAME
ORDER BY total_payer_coverage DESC;