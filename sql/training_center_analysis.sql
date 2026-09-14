USE tech_it;


# ======================
-- 1. Total counts
SELECT 
    (SELECT COUNT(*) FROM centers) AS total_centers,
    (SELECT COUNT(*) FROM courses) AS total_courses,
    (SELECT COUNT(*) FROM students) AS total_students,
    (SELECT COUNT(*) FROM enrollments) AS total_enrollments,
    (SELECT COUNT(*) FROM payments) AS total_payments,
    (SELECT COUNT(*) FROM attendance) AS total_attendance_records,
    (SELECT COUNT(*) FROM assignments) AS total_assignments,
    (SELECT COUNT(*) FROM student_assignments) AS total_submissions;

-- 2. Enrollment status distribution
SELECT status, COUNT(*) AS count, 
       ROUND(COUNT(*) / (SELECT COUNT(*) FROM enrollments) * 100.0, 2) AS percentage
FROM enrollments
GROUP BY status;

# ===== CTE version =====
WITH status_count AS (
	SELECT
		status,
        COUNT(*) AS count
	FROM enrollments
    GROUP BY status
),
total_enrollment AS(
	SELECT
		COUNT(*) AS total_enrollment
	FROM enrollments
)
SELECT
	s.status,
	s.count,
	ROUND(s.count/t.total_enrollment * 100.0, 2) AS pct_status
FROM status_count s
JOIN total_enrollment t;



-- 3. Payment status distribution
SELECT payment_status, COUNT(*) AS count
FROM payments
GROUP BY payment_status;

-- 4. Quick sanity check: Do all enrollments have at least one payment?
SELECT e.enrollment_id, e.status, COUNT(p.payment_id) AS payment_count
FROM enrollments e
LEFT JOIN payments p ON e.enrollment_id = p.enrollment_id
GROUP BY e.enrollment_id, e.status
HAVING payment_count = 0;


WITH center_base AS (
    -- Step 1: Get all enrollments with center and course info
    SELECT 
        c.center_id,
        c.center_name,
        e.enrollment_id,
        e.status,
        e.deposit_amount,
        crs.total_fee
    FROM centers c
    JOIN enrollments e ON c.center_id = e.center_id
    JOIN courses crs ON e.course_id = crs.course_id
),
completion_stats AS (
    -- Step 2: Calculate strict completion rate per center
    -- completed / (completed + dropped_out) * 100
    SELECT 
        center_id,
        center_name,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
        SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END) AS dropped_count,
        ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)/NULLIF((SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) + SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END)), 0), 2) AS completion_rate
    FROM center_base
    GROUP BY center_id, center_name
),
deposit_stats AS (
    -- Step 3: Calculate average deposit as % of course fee
    SELECT 
        center_id,
        ROUND(100.0 * AVG(deposit_amount / total_fee), 2) AS avg_deposit_pct
    FROM center_base
    GROUP BY center_id
),
payment_stats AS (
    -- Step 4: Calculate payment default rate per center
    SELECT 
        cb.center_id,
        ROUND(100.0 * SUM(CASE WHEN p.payment_status = 'defaulted' THEN 1 ELSE 0 END) / NULLIF(COUNT(p.payment_id), 0), 2) AS default_rate
    FROM center_base cb
    JOIN payments p ON cb.enrollment_id = p.enrollment_id
    GROUP BY cb.center_id
),
attendance_stats AS (
    -- Step 5: Calculate attendance rate per center
    SELECT 
        cb.center_id,
        ROUND(100.0 * SUM(CASE WHEN a.status = 'present' THEN 1 ELSE 0 END) / NULLIF(COUNT(a.attendance_id), 0), 2) AS attendance_rate
    FROM center_base cb
    JOIN attendance a ON cb.enrollment_id = a.enrollment_id
    GROUP BY cb.center_id
)
-- Step 6: Combine everything
SELECT 
    cs.center_name,
    cs.completed_count,
    cs.dropped_count,
    cs.completion_rate,
    ds.avg_deposit_pct,
    ps.default_rate,
    ats.attendance_rate
FROM completion_stats cs
JOIN deposit_stats ds ON cs.center_id = ds.center_id
JOIN payment_stats ps ON cs.center_id = ps.center_id
JOIN attendance_stats ats ON cs.center_id = ats.center_id
ORDER BY cs.completion_rate ASC;




SELECT
	c.center_id,
	c.center_name,
    s.student_id,
    e.deposit_amount,
    e.payment_plan,
    s.referral_source
FROM centers c 
JOIN enrollments e 
	ON e.center_id = c.center_id
JOIN students s 
	ON s.student_id = e.student_id
WHERE c.center_name IN ('CodeBase Abuja','TechHub Ikeja');

    
SELECT * FROM students;


# What explains Abuja's success despite low deposits?
# 1. ====== Student profile by Center

SELECT 
    c.center_name,
    s.employment_status,
    s.referral_source,
    COUNT(*) AS student_count
FROM centers c
JOIN enrollments e ON c.center_id = e.center_id
JOIN students s ON e.student_id = s.student_id
WHERE c.center_name IN ('TechHub Ikeja', 'CodeBase Abuja')
GROUP BY c.center_name, s.employment_status, s.referral_source
ORDER BY c.center_name, student_count DESC;


# 2. ======== Payment Plan Distribution by Center

SELECT 
    c.center_name,
    e.payment_plan,
    COUNT(*) AS plan_count,
    ROUND(AVG(e.deposit_amount / crs.total_fee) * 100, 2) AS avg_deposit_pct
FROM centers c
JOIN enrollments e ON c.center_id = e.center_id
JOIN courses crs ON e.course_id = crs.course_id
WHERE c.center_name IN ('TechHub Ikeja', 'CodeBase Abuja')
GROUP BY c.center_name, e.payment_plan
ORDER BY c.center_name, plan_count DESC;

# 3. ======== Course mix by center

SELECT 
    c.center_name,
    crs.course_name,
    COUNT(*) AS enrollments,
    ROUND(AVG(CASE WHEN e.status = 'completed' THEN 1 ELSE 0 END) * 100, 2) AS completion_rate
FROM centers c
JOIN enrollments e ON c.center_id = e.center_id
JOIN courses crs ON e.course_id = crs.course_id
WHERE c.center_name IN ('TechHub Ikeja', 'CodeBase Abuja')
GROUP BY c.center_name, crs.course_name
ORDER BY c.center_name, enrollments DESC;



# ========
# "Which course has the worst financial performance, and is it because of the course price, 
# the course length, or the student profile it attracts?"

WITH course_base AS (
    SELECT 
        c.course_id,
        c.course_name,
        e.enrollment_id,
        e.status,
        e.deposit_amount,
        s.employment_status,
        c.total_fee
    FROM courses c
    JOIN enrollments e ON e.course_id = c.course_id
    JOIN students s ON e.student_id = s.student_id
),
enrollment_count AS (
    SELECT 
        course_id,
        COUNT(*) AS enrollment_count
    FROM course_base
    GROUP BY course_id
),
completion_stats AS (
    SELECT 
        course_id,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
        SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END) AS dropped_count,
        ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) 
            / NULLIF(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) 
            + SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END), 0), 2) AS completion_rate_pct
    FROM course_base
    GROUP BY course_id
),
default_stats AS (
    SELECT 
        cb.course_id,
        COUNT(p.payment_id) AS total_payments,
        SUM(CASE WHEN p.payment_status = 'defaulted' THEN 1 ELSE 0 END) AS defaulted_count,
        ROUND(100.0 * SUM(CASE WHEN p.payment_status = 'defaulted' THEN 1 ELSE 0 END) 
            / NULLIF(COUNT(p.payment_id), 0), 2) AS default_rate
    FROM course_base cb
    JOIN payments p ON p.enrollment_id = cb.enrollment_id
    GROUP BY cb.course_id
),
deposit_stats AS (
    SELECT 
        course_id,
        ROUND(100.0 * AVG(deposit_amount / total_fee), 2) AS avg_deposit_pct
    FROM course_base
    GROUP BY course_id
),
employment_stats AS (
    SELECT 
        course_id,
        SUM(CASE WHEN employment_status = 'Unemployed' THEN 1 ELSE 0 END) AS unemployed_count,
        ROUND(100.0 * SUM(CASE WHEN employment_status = 'Unemployed' THEN 1 ELSE 0 END) 
            / COUNT(*), 2) AS unemployed_pct
    FROM course_base
    GROUP BY course_id
)
-- Final SELECT: courses is the base table. No nested query needed.
SELECT 
    crs.course_id,
    crs.course_name,
    crs.duration_weeks,
    crs.total_fee,
    ec.enrollment_count,
    cs.completion_rate_pct,
    ds.default_rate,
    dep.avg_deposit_pct,
    es.unemployed_pct
FROM courses crs
LEFT JOIN enrollment_count ec ON ec.course_id = crs.course_id
LEFT JOIN completion_stats cs ON cs.course_id = crs.course_id
LEFT JOIN default_stats ds ON ds.course_id = crs.course_id
LEFT JOIN deposit_stats dep ON dep.course_id = crs.course_id
LEFT JOIN employment_stats es ON es.course_id = crs.course_id
ORDER BY cs.completion_rate_pct ASC;

# ======= Confirm course employment status
SELECT 
    c.course_name,
    s.employment_status,
    COUNT(*) AS student_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY c.course_id), 2) AS pct_of_course
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN students s ON e.student_id = s.student_id
GROUP BY c.course_id, c.course_name, s.employment_status
ORDER BY c.course_name, student_count DESC;


# Recommendation
# "Data Science has a 0% completion rate, but it's not the course content — it's the student profile. 
# 80% of enrollees are either unemployed or students with no income. 
# They pay the deposit, try for a few weeks, then leave to earn money. 
# Web Development has the same price and length but 64% completion because only 39% of its students are financially vulnerable.
# My recommendation: For the next Data Science cohort, require either full-time employment proof or a 60% deposit for unemployed/student applicants. 
# Target: reduce financially vulnerable share from 80% to under 50%, and measure completion rate in 6 months.

SELECT * FROM enrollments;

# =====================
# 3. What deposit/payment structure reduces default without killing enrollment?
# =====================
# ===== Using payment_plan
WITH enrollment_summary AS (
    SELECT 
        enrollment_id,
        payment_plan,
        status,
        deposit_amount,
        course_id
    FROM enrollments
),
payment_summary AS (
    SELECT 
        enrollment_id,
        COUNT(*) AS total_payments,
        SUM(CASE WHEN payment_status = 'defaulted' THEN 1 ELSE 0 END) AS defaulted_payments
    FROM payments
    GROUP BY enrollment_id
),
-- Join them
joined_data AS (
    SELECT 
        e.payment_plan,
        e.status,
        p.total_payments,
        p.defaulted_payments
    FROM enrollment_summary e
    JOIN payment_summary p ON e.enrollment_id = p.enrollment_id
)
-- Final aggregation by payment_plan
SELECT 
    payment_plan,
    COUNT(*) AS total_enrollments,
    -- Only count completed and dropped_out for completion rate
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END) AS dropped,
    ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) 
        + SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END), 0), 2) AS completion_rate,
    SUM(defaulted_payments) AS defaulted_payments,
    SUM(total_payments) AS total_payments,
    ROUND(100.0 * SUM(defaulted_payments) 
        / NULLIF(SUM(total_payments), 0), 2) AS default_rate
FROM joined_data
GROUP BY payment_plan
ORDER BY completion_rate DESC;

# ==== Using deposit_amount
WITH enrollment_deposits AS (
    SELECT 
        e.enrollment_id,
        e.status,
        e.deposit_amount,
        c.total_fee,
        ROUND(100.0 * e.deposit_amount / c.total_fee, 2) AS deposit_pct
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
),
payment_summary AS (
    SELECT 
        enrollment_id,
        COUNT(*) AS total_payments,
        SUM(CASE WHEN payment_status = 'defaulted' THEN 1 ELSE 0 END) AS defaulted_payments
    FROM payments
    GROUP BY enrollment_id
),
binned_data AS (
    SELECT 
        ed.enrollment_id,
        ed.status,
        ed.deposit_pct,
        CASE 
            WHEN ed.deposit_pct <= 20 THEN '0-20%'
            WHEN ed.deposit_pct <= 40 THEN '21-40%'
            WHEN ed.deposit_pct <= 60 THEN '41-60%'
            ELSE '61-100%'
        END AS deposit_bin,
        ps.total_payments,
        ps.defaulted_payments
    FROM enrollment_deposits ed
    JOIN payment_summary ps ON ed.enrollment_id = ps.enrollment_id
)
SELECT 
    deposit_bin,
    COUNT(*) AS total_enrollments,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END) AS dropped_count,
    ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) 
        + SUM(CASE WHEN status = 'dropped_out' THEN 1 ELSE 0 END), 0), 2) AS completion_rate,
    SUM(defaulted_payments) AS total_defaulted_payments,
    SUM(total_payments) AS total_payments,
    ROUND(100.0 * SUM(defaulted_payments) 
        / NULLIF(SUM(total_payments), 0), 2) AS default_rate,
    ROUND(AVG(deposit_pct), 2) AS avg_actual_deposit_pct
FROM binned_data
GROUP BY deposit_bin
ORDER BY deposit_bin;

SELECT * FROM enrollments;


# ===============
# 4. Business Question: The Day 7 At-Risk Score
# We promised the CEO a system to identify high-risk students before they default. 
# Intervention trigger: score >= 70
# ===============

WITH active_enrollments AS (
    -- Only students currently in class
    SELECT * 
    FROM enrollments 
    WHERE status = 'active'
),
student_factors AS (
    -- Pre-enrollment risk factors
    SELECT 
        ae.enrollment_id,
        ae.student_id,
        ae.course_id,
        ae.center_id,
        ae.deposit_amount,
        ae.payment_plan,
        ae.enrollment_date,
        ae.start_date,
        c.total_fee,
        s.employment_status,
        s.referral_source,
        s.full_name,
        ROUND(100.0 * ae.deposit_amount / c.total_fee, 2) AS deposit_pct
    FROM active_enrollments ae
    JOIN students s ON ae.student_id = s.student_id
    JOIN courses c ON ae.course_id = c.course_id
),
week1_attendance AS (
    -- Count absences in first 3 sessions (Week 1: Mon/Wed/Fri)
    SELECT 
        enrollment_id,
        COUNT(*) AS week1_sessions,
        SUM(CASE WHEN status = 'absent' THEN 1 ELSE 0 END) AS week1_absences
    FROM attendance
    WHERE session_number <= 3
    GROUP BY enrollment_id
),
first_assignment_due AS (
    -- Find the first assignment for each course
    SELECT 
        course_id,
        MIN(week_number) AS first_week
    FROM assignments
    GROUP BY course_id
),
first_submission AS (
    -- Did the student submit the first assignment?
    SELECT 
        sa.enrollment_id,
        sa.status AS submission_status,
        sa.submission_date,
        a.due_date
    FROM student_assignments sa
    JOIN assignments a ON sa.assignment_id = a.assignment_id
    JOIN first_assignment_due fad ON a.course_id = fad.course_id 
        AND a.week_number = fad.first_week
),
risk_calculation AS (
    SELECT 
        sf.*,
        COALESCE(wa.week1_absences, 3) AS week1_absences, -- NULL = missed all 3
        COALESCE(fs.submission_status, 'not_submitted') AS first_assignment_status,
        
        -- FILL IN THE RISK SCORE FORMULA HERE
        -- Start with 50, add points for each risk factor
        50 
        + CASE WHEN sf.deposit_pct < 20 THEN 25 ELSE 0 END
        + CASE WHEN sf.employment_status = 'Unemployed' THEN 20 ELSE 0 END
        + CASE WHEN sf.referral_source IN ('Walk-in', 'Social Media') THEN 15 ELSE 0 END
        + CASE WHEN COALESCE(wa.week1_absences, 3) >= 2 THEN 20 ELSE 0 END
        + CASE WHEN COALESCE(fs.submission_status, 'not_submitted') != 'submitted' THEN 15 ELSE 0 END
        AS risk_score
        
    FROM student_factors sf
    LEFT JOIN week1_attendance wa ON sf.enrollment_id = wa.enrollment_id
    LEFT JOIN first_submission fs ON sf.enrollment_id = fs.enrollment_id
)
SELECT 
    enrollment_id,
    full_name,
    course_id,
    center_id,
    deposit_pct,
    employment_status,
    referral_source,
    week1_absences,
    first_assignment_status,
    risk_score,
    CASE 
        WHEN risk_score >= 70 THEN 'INTERVENTION REQUIRED - Call within 24hrs'
        WHEN risk_score >= 50 THEN 'Monitor - Weekly check-in'
        ELSE 'Low risk - Standard tracking'
    END AS recommended_action
FROM risk_calculation
ORDER BY risk_score DESC;


WITH active_enrollments AS (
    SELECT * FROM enrollments WHERE status = 'active'
),
student_factors AS (
    SELECT 
        ae.enrollment_id,
        ae.student_id,
        ae.course_id,
        ae.center_id,
        ae.deposit_amount,
        ae.payment_plan,
        ae.start_date,
        c.total_fee,
        s.employment_status,
        s.referral_source,
        s.full_name,
        ROUND(100.0 * ae.deposit_amount / c.total_fee, 2) AS deposit_pct
    FROM active_enrollments ae
    JOIN students s ON ae.student_id = s.student_id
    JOIN courses c ON ae.course_id = c.course_id
),
week1_attendance_calendar AS (
    -- Count sessions in first 7 calendar days instead of first 3 session numbers
    SELECT 
        a.enrollment_id,
        COUNT(*) AS week1_sessions,
        SUM(CASE WHEN a.status = 'absent' THEN 1 ELSE 0 END) AS week1_absences
    FROM attendance a
    JOIN active_enrollments ae ON a.enrollment_id = ae.enrollment_id
    WHERE a.session_date BETWEEN ae.start_date 
        AND DATE_ADD(ae.start_date, INTERVAL 7 DAY)
    GROUP BY a.enrollment_id
),
first_assignment_due AS (
    SELECT course_id, MIN(week_number) AS first_week
    FROM assignments GROUP BY course_id
),
first_submission AS (
    SELECT 
        sa.enrollment_id,
        sa.status AS submission_status
    FROM student_assignments sa
    JOIN assignments a ON sa.assignment_id = a.assignment_id
    JOIN first_assignment_due fad ON a.course_id = fad.course_id 
        AND a.week_number = fad.first_week
),
risk_calculation AS (
    SELECT 
        sf.*,
        COALESCE(wa.week1_absences, 3) AS week1_absences,
        COALESCE(fs.submission_status, 'not_submitted') AS first_assignment_status,
        50 
        + CASE WHEN sf.deposit_pct < 20 THEN 25 ELSE 0 END
        + CASE WHEN sf.employment_status = 'Unemployed' THEN 20 ELSE 0 END
        + CASE WHEN sf.referral_source IN ('Walk-in', 'Social Media') THEN 15 ELSE 0 END
        + CASE WHEN COALESCE(wa.week1_absences, 3) >= 2 THEN 20 ELSE 0 END
        + CASE WHEN COALESCE(fs.submission_status, 'not_submitted') != 'submitted' THEN 15 ELSE 0 END
        AS risk_score
    FROM student_factors sf
    LEFT JOIN week1_attendance_calendar wa ON sf.enrollment_id = wa.enrollment_id
    LEFT JOIN first_submission fs ON sf.enrollment_id = fs.enrollment_id
)
SELECT 
    enrollment_id,
    full_name,
    deposit_pct,
    employment_status,
    referral_source,
    week1_absences,
    first_assignment_status,
    risk_score,
    CASE 
        WHEN risk_score >= 70 THEN 'INTERVENTION REQUIRED'
        WHEN risk_score >= 50 THEN 'Monitor - Weekly check-in'
        ELSE 'Low risk'
    END AS action
FROM risk_calculation
ORDER BY risk_score DESC;


# =======================
# Business Question #5: Which students are on track to default in the next 30 days?
# =======================

WITH today AS (
    SELECT CURDATE() AS todays_date
),
active_enrollments AS (
    SELECT 
        e.enrollment_id,
        e.student_id,
        e.course_id,
        e.center_id,
        e.payment_plan,
        e.deposit_amount,
        c.total_fee,
        c.course_name,
        ctr.center_name,
        s.full_name,
        s.phone,
        s.employment_status,
        s.referral_source,
        ROUND(100.0 * e.deposit_amount / c.total_fee, 2) AS deposit_pct
    FROM enrollments e
    JOIN students s ON e.student_id = s.student_id
    JOIN courses c ON e.course_id = c.course_id
    JOIN centers ctr ON e.center_id = ctr.center_id
    WHERE e.status = 'active'
),
upcoming_dues AS (
    -- Payments due in next 30 days that are NOT paid
    SELECT 
        p.enrollment_id,
        SUM(p.amount_due - p.amount_paid) AS upcoming_balance,
        COUNT(*) AS upcoming_count,
        MIN(p.due_date) AS next_due_date
    FROM payments p
    CROSS JOIN today t
    WHERE p.due_date BETWEEN t.todays_date AND DATE_ADD(t.todays_date, INTERVAL 30 DAY)
      AND p.payment_status IN ('pending', 'overdue')
    GROUP BY p.enrollment_id
),
payment_history AS (
    -- Have they defaulted or paid late before?
    SELECT 
        enrollment_id,
        SUM(CASE WHEN payment_status = 'defaulted' THEN 1 ELSE 0 END) AS prior_defaults,
        SUM(CASE WHEN payment_status = 'paid_late' THEN 1 ELSE 0 END) AS prior_late
    FROM payments
    GROUP BY enrollment_id
),
balance_summary AS (
    -- Total remaining balance across entire enrollment
    SELECT 
        enrollment_id,
        SUM(amount_due - amount_paid) AS remaining_balance
    FROM payments
    GROUP BY enrollment_id
)
SELECT 
    ae.enrollment_id,
    ae.full_name,
    ae.phone,
    ae.center_name,
    ae.course_name,
    ae.payment_plan,
    ae.deposit_pct,
    ae.employment_status,
    ud.next_due_date,
    ud.upcoming_balance,
    bs.remaining_balance,
    COALESCE(ph.prior_defaults, 0) AS prior_defaults,
    COALESCE(ph.prior_late, 0) AS prior_late_payments,
    
    -- DEFAULT RISK SCORE
    (CASE WHEN ae.deposit_pct < 20 THEN 25 ELSE 0 END
     + CASE WHEN ae.employment_status = 'Unemployed' THEN 20 ELSE 0 END
     + CASE WHEN ae.referral_source IN ('Walk-in', 'Social Media') THEN 10 ELSE 0 END
     + COALESCE(ph.prior_defaults, 0) * 15
     + COALESCE(ph.prior_late, 0) * 5
     + CASE WHEN ud.upcoming_balance > (ae.total_fee * 0.25) THEN 15 ELSE 0 END
    ) AS default_risk_score,
    
    -- URGENCY LEVEL
    CASE 
        WHEN (CASE WHEN ae.deposit_pct < 20 THEN 25 ELSE 0 END
              + CASE WHEN ae.employment_status = 'Unemployed' THEN 20 ELSE 0 END
              + CASE WHEN ae.referral_source IN ('Walk-in', 'Social Media') THEN 10 ELSE 0 END
              + COALESCE(ph.prior_defaults, 0) * 15
              + COALESCE(ph.prior_late, 0) * 5
              + CASE WHEN ud.upcoming_balance > (ae.total_fee * 0.25) THEN 15 ELSE 0 END
             ) >= 60 THEN 'URGENT: Call within 48 hours'
        WHEN (CASE WHEN ae.deposit_pct < 20 THEN 25 ELSE 0 END
              + CASE WHEN ae.employment_status = 'Unemployed' THEN 20 ELSE 0 END
              + CASE WHEN ae.referral_source IN ('Walk-in', 'Social Media') THEN 10 ELSE 0 END
              + COALESCE(ph.prior_defaults, 0) * 15
              + COALESCE(ph.prior_late, 0) * 5
              + CASE WHEN ud.upcoming_balance > (ae.total_fee * 0.25) THEN 15 ELSE 0 END
             ) >= 30 THEN 'HIGH: Call within 1 week'
        ELSE 'MEDIUM: Monitor'
    END AS urgency_level

FROM active_enrollments ae
JOIN upcoming_dues ud ON ae.enrollment_id = ud.enrollment_id
LEFT JOIN payment_history ph ON ae.enrollment_id = ph.enrollment_id
LEFT JOIN balance_summary bs ON ae.enrollment_id = bs.enrollment_id
ORDER BY default_risk_score DESC, ud.next_due_date ASC;


# =====================
# Business Question #6: Earliest Reliable Signal of Disengagement
# At what point does a dropout's behavior diverge from a completer's? 
# If we can spot the divergence early, we can intervene before the student ghosts.
# ====================

WITH student_outcomes AS (
    SELECT 
        enrollment_id,
        status,
        start_date
    FROM enrollments
    WHERE status IN ('completed', 'dropped_out')
),
weekly_attendance AS (
    SELECT 
        a.enrollment_id,
        so.status,
        a.session_number,
        CASE WHEN a.status = 'present' THEN 1 ELSE 0 END AS was_present
    FROM attendance a
    JOIN student_outcomes so ON a.enrollment_id = so.enrollment_id
),
weekly_summary AS (
    SELECT 
        enrollment_id,
        status,
        session_number,
        ROUND(100.0 * SUM(was_present) / COUNT(*), 2) AS weekly_rate
    FROM weekly_attendance
    GROUP BY enrollment_id, status, session_number
),
grouped_by_week AS (
    SELECT 
        session_number AS week,
        AVG(CASE WHEN status = 'completed' THEN weekly_rate END) AS completed_avg,
        AVG(CASE WHEN status = 'dropped_out' THEN weekly_rate END) AS dropped_avg
    FROM weekly_summary
    GROUP BY session_number
)
SELECT 
    week,
    ROUND(completed_avg, 2) AS completed_avg,
    ROUND(dropped_avg, 2) AS dropped_avg,
    ROUND(completed_avg - dropped_avg, 2) AS gap,
    CASE 
        WHEN completed_avg - dropped_avg > 20 THEN 'EARLY WARNING SIGNAL'
        WHEN completed_avg - dropped_avg > 10 THEN 'WATCH CLOSELY'
        ELSE 'Normal variance'
    END AS alert_level
FROM grouped_by_week
WHERE week <= 8
ORDER BY week;

SELECT * FROM courses;