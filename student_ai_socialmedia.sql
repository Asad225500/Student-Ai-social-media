SELECT * FROM public.student_media_usage
LIMIT 100
SELECT COUNT(*) 
FROM student_media_usage;
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'student_media_usage';
SELECT 
    COUNT(student_id) AS total_students,
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_tool_hrs,
    ROUND(AVG(sleep_hours)::numeric, 2) AS avg_sleep_hrs,
    ROUND(AVG(mental_health_score)::numeric, 2) AS avg_mental_health,
    ROUND(AVG(physical_health_score)::numeric, 2) AS avg_physical_health
FROM student_media_usage;
SELECT 
    CASE 
        WHEN daily_social_media_hours < 2 THEN 'Low (< 2 hrs)'
        WHEN daily_social_media_hours BETWEEN 2 AND 5 THEN 'Moderate (2-5 hrs)'
        WHEN daily_social_media_hours BETWEEN 5 AND 8 THEN 'High (5-8 hrs)'
        ELSE 'Very High (> 8 hrs)'
    END AS social_media_bracket,
    COUNT(*) AS student_count,
    ROUND(AVG(mental_health_score)::numeric, 2) AS avg_mental_health,
    ROUND(AVG(sleep_hours)::numeric, 2) AS avg_sleep_hours
FROM student_media_usage
GROUP BY 1
ORDER BY avg_mental_health DESC;
SELECT 
    education_level,
    COUNT(student_id) AS total_students,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_hours,
    ROUND(MAX(daily_ai_tool_usage_hours)::numeric, 2) AS max_ai_hours
FROM student_media_usage
GROUP BY education_level
ORDER BY avg_ai_hours DESC;
SELECT 
    ROUND((daily_social_media_hours + daily_ai_tool_usage_hours)::numeric, 0) AS total_screen_hours,
    ROUND(AVG(sleep_hours)::numeric, 2) AS avg_sleep_hours,
    COUNT(*) AS student_count
FROM student_media_usage
GROUP BY 1
ORDER BY total_screen_hours ASC;
SELECT 
    CASE 
        WHEN physical_activity_hours < 1 THEN 'Low (< 1 hr)'
        WHEN physical_activity_hours BETWEEN 1 AND 3 THEN 'Moderate (1-3 hrs)'
        ELSE 'High (> 3 hrs)'
    END AS activity_level,
    ROUND(AVG(physical_health_score)::numeric, 2) AS avg_physical_health,
    ROUND(AVG(mental_health_score)::numeric, 2) AS avg_mental_health
FROM student_media_usage
GROUP BY 1
ORDER BY avg_physical_health DESC;
SELECT 
    gender,
    COUNT(student_id) AS student_count,
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_hrs,
    ROUND(AVG(mental_health_score)::numeric, 2) AS avg_mental_health_score
FROM student_media_usage
GROUP BY gender;
SELECT 
    education_level,
    gender,
    COUNT(student_id) AS at_risk_count,
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs
FROM student_media_usage
WHERE mental_health_score < 50 AND sleep_hours < 5
GROUP BY education_level, gender
ORDER BY at_risk_count DESC;
SELECT 
    age,
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_tool_hrs,
    ROUND(AVG(mental_health_score)::numeric, 2) AS avg_mental_health
FROM student_media_usage
GROUP BY age
ORDER BY age ASC;
SELECT 
    education_level,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_hrs,
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs,
    ROUND(AVG(daily_ai_tool_usage_hours / NULLIF(daily_social_media_hours, 0))::numeric, 2) AS ai_to_social_ratio
FROM student_media_usage
GROUP BY education_level;
SELECT 
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_hrs,
    ROUND(AVG(sleep_hours)::numeric, 2) AS avg_sleep_hrs,
    ROUND(AVG(physical_activity_hours)::numeric, 2) AS avg_exercise_hrs
FROM student_media_usage
WHERE mental_health_score >= (
    SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY mental_health_score) 
    FROM student_media_usage
);
SELECT 
    education_level,
    gender,
    COUNT(*) AS sleep_deprived_count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER())::numeric, 2) AS pct_of_total_deprived
FROM student_media_usage
WHERE sleep_hours < 6.0
GROUP BY education_level, gender
ORDER BY sleep_deprived_count DESC;
SELECT 
    CASE 
        WHEN (mental_health_score + physical_health_score) / 2 >= 85 THEN 'Optimal (85+)'
        WHEN (mental_health_score + physical_health_score) / 2 BETWEEN 70 AND 84.99 THEN 'Moderate (70-84)'
        ELSE 'Needs Attention (<70)'
    END AS wellness_tier,
    COUNT(*) AS student_count,
    ROUND(AVG(daily_social_media_hours)::numeric, 2) AS avg_social_media_hrs,
    ROUND(AVG(daily_ai_tool_usage_hours)::numeric, 2) AS avg_ai_hrs
FROM student_media_usage
GROUP BY 1
ORDER BY student_count DESC;