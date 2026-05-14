--CREATING GAMING_VS_ACADEMICS TABLE
 CREATE TABLE GAMING_VS_ACADEMICS (
  id INT,
  GAMING_HOURS FLOAT,
   STUDY_HOURS FLOAT,
   SLEEP_HOURS FLOAT
  );
  
--CREATING ACADEMIC_OUTCOME TABLE
CREATE TABLE ACADEMIC_OUTCOME (
  id INT,
  GRADES FLOAT,
  ATTENDANCE FLOAT
  );
  
--CREATING GAMER_REFLEX TABLE 
 DROP TABLE IF EXISTS GAMER_REFLEX;
CREATE TABLE GAMER_REFLEX (
    id INT,
    GAMING_GENRE VARCHAR(20),
    REACTION_TIME_MS FLOAT,
    ADDICTION_SCORE FLOAT
    );
    
--Data Cleaning:
--Check for outliers
SELECT 
    GAMING_HOURS,
    STUDY_HOURS,
    SLEEP_HOURS
FROM
    gaming_vs_academics

WHERE 
    gaming_hours < 0 OR
    STUDY_HOURS < 1 OR
    SLEEP_HOURS < 1;
    
    
    
--QUERY 1 
SELECT
    CORR(GAMING_HOURS, ADDICTION_SCORE)
FROM GAMER_REFLEX GR
JOIN GAMING_VS_ACADEMICS GVA ON GR.ID = GVA.ID;
--HERE I SELECTED ALL OF THE DATA FROM THE GAMER_REFLEX AND GVA TABLES JOINING IT ON WITH
-- THE GVA TABLE BY LINKING THEM BOTH THROUGH STUDENT ID

--QUERY 2
SELECT
    CORR(REACTION_TIME_MS, GRADES)
FROM GAMER_REFLEX GR
JOIN ACADEMIC_OUTCOME AO ON GR.ID = AO.ID;

--DATA ANALYSIS: DESCRIPTIVE STATISTICS
SELECT 
    AVG(GRADES),
    AVG(ATTENDANCE)
FROM
    ACADEMIC_OUTCOME;
    
SELECT 
    AVG(REACTION_TIME_MS)
FROM
    GAMER_REFLEX;
    
SELECT 
    AVG(GAMING_HOURS),
    AVG(STUDY_HOURS),
    AVG(SLEEP_HOURS)
FROM
    GAMING_VS_ACADEMICS;  
    
SELECT 
    MEDIAN(GRADES),
    MEDIAN(ATTENDANCE)
FROM
    ACADEMIC_OUTCOME;
    
SELECT 
    MEDIAN(REACTION_TIME_MS)
FROM
    GAMER_REFLEX;
    
SELECT 
    MEDIAN(GAMING_HOURS),
    MEDIAN(STUDY_HOURS),
    MEDIAN(SLEEP_HOURS)
FROM
    GAMING_VS_ACADEMICS; 
    
SELECT 
    MODE(GRADES),
     MODE(ATTENDANCE)
FROM
    ACADEMIC_OUTCOME;
    
SELECT 
    MODE(REACTION_TIME_MS)
FROM
    GAMER_REFLEX;
    
SELECT 
    MODE(GAMING_HOURS),
    MODE(STUDY_HOURS),
    MODE(SLEEP_HOURS)
FROM
    GAMING_VS_ACADEMICS; 
    
    
SELECT 
    STDDEV(GRADES),
     STDDEV(ATTENDANCE)
FROM
    ACADEMIC_OUTCOME;
    
SELECT 
    STDDEV(REACTION_TIME_MS)
FROM
    GAMER_REFLEX;
    
SELECT 
    STDDEV(GAMING_HOURS),
    STDDEV(STUDY_HOURS),
    STDDEV(SLEEP_HOURS)
FROM
    GAMING_VS_ACADEMICS;
    
SELECT *
FROM academic_outcome AO JOIN GAMER_REFLEX GF ON AO.ID = GF.ID
WHERE GRADES > 80;   

--PROJECT QUESTIONS

--Question 1
--What is the average sleep time for high achieving students
-- in comparison to low-achieving students (grades < 50%) (grades > 80%)?

--Average Sleep Hours:
SELECT
    (SELECT AVG(ga.sleep_hours)
    FROM 
         academic_outcome ao
    JOIN 
        gaming_vs_academics ga ON ao.id = ga.id
    WHERE 
        ao.grades > 80) AS avg_sleep_high,


    (SELECT AVG(ga.sleep_hours)
    FROM 
        academic_outcome ao
    JOIN 
        gaming_vs_academics ga ON ao.id = ga.id
    WHERE 
        ao.grades > 50) AS avg_sleep_low
FROM dual;

-- Question 2
-- Do students who game for longer hours peform 
-- lower acadmically?

--AVERAGE GAMING HOURS
--Heavy gamers -- gaming_hours > 20
--Light gamers -- gaming_hours < 5 hours

SELECT
    (SELECT AVG(ao.grades)
    FROM academic_outcome ao
    JOIN gaming_vs_academics ga ON ao.id = ga.id
    WHERE ga.gaming_hours > 6) AS avg_heavy_gamer_grades,
    
    (SELECT AVG(ao.grades)
    FROM academic_outcome ao
    JOIN gaming_vs_academics ga ON ao.id = ga.id
    WHERE ga.gaming_hours < 2) AS avg_light_gamer_grades
FROM dual;

--Test for gaming hours > 20
--SELECT*
--FROM gaming_vs_academics
--WHERE gaming_hours > 20;

--SELECT
  --  column_name
--FROM user_tab_columns
--WHERE table_name = 'GAMING_VS_ACADEMICS';

SELECT
    (SELECT AVG(ao.grades)
    FROM academic_outcome ao
    JOIN gaming_vs_academics ga ON ao.id = ga.id
    WHERE ga.GAMING_HOURS > 20) AS avg_heavy_gamer_grades,
    
    (SELECT AVG(ao.grades)
    FROM academic_outcome ao
    JOIN gaming_vs_academics ga ON ao.id = ga.id
    WHERE ga.GAMING_HOURS < 5) AS avg_light_gamer_grades
FROM dual;

--Checking for MIN and MAX gaming hours
SELECT
   MIN(gaming_hours), MAX(gaming_hours)
FROM gaming_vs_academics;

SELECT
    (SELECT AVG(ao.grades)
    FROM academic_outcome ao
    JOIN gaming_vs_academics ga ON ao.id = ga.id
    WHERE ga.gaming_hours > 5) AS avg_heavy_gamer_grades,
    
    (SELECT AVG(ao.grades)
    FROM academic_outcome ao
    JOIN gaming_vs_academics ga ON ao.id = ga.id
    WHERE ga.gaming_hours < 2) AS avg_light_gamer_grades
FROM dual;


-- Questions 3
-- Do students with faster reaction times tend
-- to have better grades than students with 
-- slower reaction times?

--Checking for MIN and MAX reation times
SELECT
    MIN(reaction_time_ms),
    MAX(reaction_time_ms)
 FROM
    GAMER_REfLEX;   
--Defining fast and slow reaction times
-- Fast reaction time -- < 230 ms
-- Slow reaction time -- > 300 ms

--Counting the number in fast and slow groups
--Fast reaction times
SELECT
    count(*)
FROM 
    gamer_reflex
WHERE reaction_time_ms < 230;

--Slow reaction times
SELECT
    count(*)
FROM 
    gamer_reflex
WHERE reaction_time_ms > 300;

--Average grades for fast and slow reaction times
SELECT
    (SELECT AVG(ao.grades)
FROM 
    academic_outcome ao
JOIN 
    gamer_reflex gr ON ao.id = gr.id
WHERE 
    gr.reaction_time_ms < 230) AS AVG_FAST_TIME_GRADES,

    (SELECT AVG(ao.grades)
FROM 
    academic_outcome ao
JOIN 
    gamer_reflex gr ON ao.id = gr.id
WHERE 
    gr.reaction_time_ms > 300) AS AVG_SLOW_TIME_GRADES
FROM dual;



--Questions 4
-- Do students who play games in different genres show
-- different levels of academic performance? 

--Choosing a gaming genre
SELECT 
    *
FROM
    gamer_reflex
FETCH FIRST 15 ROWS ONLY;

--Count students who prefer FPS vs RPG
SELECT
    gaming_genre, COUNT(*)
FROM
    gamer_reflex
WHERE 
    gaming_genre = 'FPS'
OR
    gaming_genre = 'RPG'
GROUP BY 
    gaming_genre;
    
--Average grades for FPS and RPG gamers
SELECT
    (SELECT AVG(ao.grades)
FROM
    academic_outcome ao
JOIN
    gamer_reflex gr ON ao.id = gr.id
    WHERE gr.gaming_genre = 'FPS') AS avg_grades_fps_gamers,

    (SELECT AVG(ao.grades)
FROM 
    academic_outcome ao
JOIN
    gamer_reflex gr ON ao.id = gr.id
WHERE
    gr.gaming_genre ='RPG') AS avg_grades_rpg_gamers
FROM
    dual;
    





    

-- DROP TABLE IF EXISTS GAMING_VS_ACADEMICS;

-- CREATE TABLE GAMING_VS_ACADEMICS (
--    id INT,
--    GAMING_HOURS FLOAT,
--   STUDY_HOURS FLOAT,
--    SLEEP_HOURS FLOAT
--   );
    
-- LOAD DATA 'D:\DS230\Gaming_Academic_Performance.csv'
--LOAD DATA 'Gaming_Academic_Performance.csv'
--INTO TABLE GAMING_VS_ACADEMICS
--FIELDS TERMINATED BY "," -- OPTIONALLY ENCLOSED BY '"'
--(ID, GAMING_HOURS, STUDY_HOURS, SLEEP_HOURS)

DROP TABLE IF EXISTS ACADEMIC_OUTCOME;


CREATE TABLE ACADEMIC_OUTCOME (
  id INT,
  GRADES FLOAT,
  ATTENDANCE FLOAT
  );
  
SELECT 
    CORR(SLEEP_HOURS, REACTION_TIME_MS)
FROM
    JCOLEMA8.GAMER_REFLEX gr
JOIN GAMING_VS_ACADEMICS ga ON gr.ID = ga.ID;

--Descriptive Statistics 
--ACADEMIC_OUTCOME
SELECT 
    *

FROM
    academic_outcome
WHERE grades >80;

--GAMER_REFLEX
SELECT
    *
FROM
    GAMER_REFLEX
WHERE 
    REACTION_TIME_MS < 230
    OR REACTION_TIME_MS > 300;
    
--GAMING_VS_ACADEMICS
SELECT
    *
FROM 
    GAMING_VS_ACADEMICS;



