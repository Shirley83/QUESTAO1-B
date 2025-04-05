WITH daily_enrollment AS (
    -- Subconsulta para obter a quantidade de alunos por escola e por dia
    SELECT
        sc.name AS school_name,
        st.enrolled_at AS enrollment_date,
        COUNT(st.id) AS num_students
    FROM
        students st
    JOIN
        courses c ON st.course_id = c.id
    JOIN
        schools sc ON c.school_id = sc.id
    WHERE
        c.name ILIKE 'data%'  -- Filtra cursos cujo nome começa com "data"
    GROUP BY
        sc.name, st.enrolled_at
)

SELECT
    school_name,
    enrollment_date,
    num_students,
    SUM(num_students) OVER (PARTITION BY school_name ORDER BY enrollment_date) AS cumulative_sum,  -- Soma acumulada
    AVG(num_students) OVER (PARTITION BY school_name ORDER BY enrollment_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7_days,  -- Média móvel de 7 dias
    AVG(num_students) OVER (PARTITION BY school_name ORDER BY enrollment_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS moving_avg_30_days  -- Média móvel de 30 dias
FROM
    daily_enrollment
ORDER BY
    enrollment_date DESC, school_name;




   