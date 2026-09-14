# Tech/IT Training Centre Performance Analysis

## Project Overview

This project analyses enrollment, financial, student outcome and demographic data from a fictional Tech/IT training centre operating across multiple locations.

The objective is to understand enrollment performance, financial collection, student outcomes and the characteristics of the students enrolling in the training programmes.

The analysis was completed using My SQL for extracting the datas, Python, Excel and Power BI, with the final Power BI dashboard providing an interactive view of the centre's performance.

## Business Questions

The analysis focuses on four main areas:

1. **Enrollment:** How are enrollments distributed across courses, centres and referral sources?
2. **Financial Performance:** How much is owed, how much has been collected and what remains outstanding?
3. **Student Outcomes:** What proportion of decided enrollments are completed versus dropped out?
4. **Student Profile:** What are the demographic and socioeconomic characteristics of enrolled students?

## Tools Used

* Python — data cleaning, transformation and analysis
* Pandas — data manipulation
* Matplotlib — exploratory visualisation
* Excel — reporting and dashboard development
* Power BI — interactive dashboard and business reporting
* MySQL — data preparation and analysis

## Executive Summary

The analysis of 35 enrollments provides an overview of enrollment performance, financial collection, student outcomes and student characteristics across the training centre's courses and locations.

Enrollment is concentrated in Full Stack Web Development and TechHub Ikeja, while Walk-in is the largest referral source. Financially, the centre has collected 81.37% of the ₦12.3 million in fees due, leaving ₦2.29 million outstanding. Among the 18 enrollments that have reached a final outcome, 9 completed and 9 dropped out, resulting in a 50% completion rate and 50% dropout rate. Completion performance also varies across centres and courses, although the relatively small number of decided enrollments means these differences should be investigated further before making major decisions.

The findings suggest that management should focus on understanding what drives strong enrollment performance, strengthening payment monitoring and collection, investigating the factors associated with student dropout, and comparing performance across centres, referral sources and payment plans. Rather than relying on overall rankings or headline percentages, decisions should be based on deeper investigation of the factors behind the results and adapted to the circumstances of individual centres and student groups.



## Business Insights

## 1. Enrollment Concentration

### Finding

Enrollment is concentrated in Full Stack Web Development and at TechHub Ikeja.

### Evidence

Full Stack Web Development recorded 18 of the 35 enrollments, making it the largest course by enrollment volume. TechHub Ikeja recorded 16 of the 35 enrollments, making it the highest-volume centre.

### Business Meaning

The business currently relies heavily on a small number of courses and locations for enrollment volume. Strong demand in these areas is positive, but the concentration also creates potential dependency risk if demand or operational capacity changes.

### Recommendation

Management should investigate the factors driving strong performance in Full Stack Web Development and TechHub Ikeja and determine whether successful practices can be replicated across other courses and centres. At the same time, performance in lower-volume courses should be monitored to identify opportunities for growth.

## 2. Strong Collection Rate with Outstanding Fees

### Finding

The training centre has collected 81.37% of total fees due, while ₦2,291,197.72 remains outstanding.

### Evidence

Total fees due are ₦12,300,000, of which ₦10,008,802.28 has been collected. This leaves an outstanding balance of ₦2,291,197.72.

### Business Meaning

The collection rate indicates that most fees due have been collected, which is positive for the centre's cash collection performance. However, the outstanding balance represents a significant amount of fees that remain uncollected and may affect cash flow if collection is delayed.

### Recommendation

Management should monitor outstanding balances closely and strengthen follow-up on unpaid or overdue installments. Payment-plan monitoring can also help identify students who may require earlier intervention before balances become significantly overdue.

## 3. Equal Completion and Dropout Among Decided Outcomes

### Finding

Among enrollments that have reached a final outcome, completion and dropout are evenly split at 50% each.

### Evidence

There are 18 decided enrollments: 9 completed and 9 dropped out. A further 17 enrollments are still active or suspended and therefore have not yet reached a final outcome.

### Business Meaning

The 50% completion rate indicates that half of the enrollments that have reached a final outcome successfully completed their programmes, while the other half dropped out. Although the current completion performance provides a useful baseline, the dropout level indicates an opportunity to improve student retention and programme completion.

The 17 enrollments still in progress should be monitored separately because their eventual outcomes are not yet known.

### Recommendation

Management should investigate the reasons behind student dropout, particularly whether financial difficulties, payment issues, programme-related factors or student characteristics are associated with withdrawal. Early intervention and closer monitoring of students showing signs of disengagement could help improve future completion rates.

## 4. Completion Performance Varies by Centre

### Finding

Completion rates differ substantially across the three training centres, with CodeBase Abuja recording the highest completion rate at 75%, compared with 50% at DevCenter PH and 40% at TechHub Ikeja.

### Evidence

Among decided enrollments, CodeBase Abuja recorded a 75% completion rate, DevCenter PH recorded 50%, and TechHub Ikeja recorded 40%.

### Business Meaning

The difference suggests that student outcomes may vary by centre. The stronger performance at CodeBase Abuja provides an opportunity to investigate which operational or student-support practices may be contributing to its higher completion rate.

However, centre-level completion rates should be interpreted alongside the number of decided enrollments because the groups are relatively small.

### Recommendation

Management should investigate the practices, student support processes, payment patterns and programme mix associated with higher completion at CodeBase Abuja. Successful practices should then be assessed for possible adaptation at centres with lower completion rates rather than assuming that identical measures will produce the same results.

## 5. Enrollment Sources Show Different Acquisition Channels

### Finding

Students enroll through multiple referral channels, with Walk-in generating the highest number of enrollments.

### Evidence

Walk-in recorded 15 enrollments, followed by Social Media with 10, Website with 6 and Referral with 4.

### Business Meaning

The distribution of enrollments across referral sources shows that the training centre attracts students through different acquisition channels. Walk-in currently contributes the largest volume of enrollments, but volume alone does not determine the value of a referral source.

The business should also consider factors such as completion rates, payment behaviour, student retention and acquisition costs when evaluating the effectiveness of each channel.

### Recommendation

Management should investigate the quality and performance of students from each referral source, including financial outcomes and completion rates. Marketing investment decisions should be based on both enrollment volume and student outcomes rather than volume alone.

## 6. Payment Plan Adoption Varies

### Finding

Most enrollments use installment-based payment plans, with the two-installment plan being the most common.

### Evidence

The two-installment plan accounts for 15 enrollments, followed by the three-installment plan with 12. Monthly payment is used by 6 enrollments, while only 2 enrollments use full payment.

### Business Meaning

The distribution indicates that students generally prefer spreading their payments rather than paying their full fees upfront. However, adoption alone does not establish which payment plan is most beneficial to the business.

Payment-plan performance should also be evaluated against collection rates, overdue payments, outstanding balances and student outcomes. Adoption may also differ between centres, so an overall payment-plan view may not represent the behaviour of every location.

### Recommendation

Management should compare payment performance and student outcomes across payment plans and centres before deciding whether to promote a particular plan more heavily. The objective should be to balance affordability for students with predictable cash collection for the business.

## 7. Course Completion Rates Require Context

### Finding

Completion rates vary across courses, with Full Stack Web Development recording the highest completion rate among the courses analysed.

### Evidence

Full Stack Web Development recorded a 64% completion rate, Cybersecurity Fundamentals recorded 50%, while Data Science & Analytics and UI/UX Design Professional recorded 0% among their decided enrollments.

### Business Meaning

The differences in completion rates provide a useful basis for comparing student outcomes across programmes. However, the rates should not be interpreted in isolation because courses have different numbers of decided enrollments. Smaller groups can produce large percentage differences from relatively few students.

Other factors may also contribute to differences in completion, including student characteristics, payment behaviour, programme structure and support provided during training.

### Recommendation

Management should monitor course-level completion alongside the number of decided enrollments and investigate the factors associated with stronger or weaker outcomes. Courses with lower completion rates should be examined further before making decisions about programme performance or changes.

## Recommendation 1: Investigate and Leverage High-Demand Areas

Management should investigate the factors driving the strong enrollment performance of Full Stack Web Development and TechHub Ikeja before increasing investment in either area.

The investigation should consider pricing and payment plans, course availability, advertising and outreach, course duration, and whether the programme is delivered online or physically at the centre.

If the analysis confirms that these factors are contributing to stronger demand, management can consider increasing promotion for Full Stack at TechHub Ikeja. The business should also identify which successful practices can be adapted to lower-volume courses and other centres rather than assuming that the same approach will work everywhere.

## Recommendation 2: Strengthen Payment Monitoring and Collection

Management should establish a structured follow-up process for students with outstanding or overdue balances. This could include payment reminders, regular monitoring of unpaid installments and an escalation process for prolonged non-payment.

To reduce future outstanding balances, management should also investigate payment-plan performance and identify which plans, centres or student groups are associated with higher levels of overdue or unpaid amounts.

The objective should be to improve cash collection while identifying payment arrangements that remain manageable for students and sustainable for the business.

## Recommendation 3: Investigate and Address Student Dropout

Management should investigate the reasons behind student dropout and compare the characteristics and experiences of dropped-out students with those who completed their programmes.

The analysis should look for recurring patterns across factors such as payment behaviour, payment plans, course, centre, referral source and student characteristics. Identifying factors associated with dropout can help management determine where earlier intervention may be needed.

The findings should then be used to strengthen retention strategies for future students and to identify students currently in progress who may benefit from additional support or monitoring.

## Recommendation 4: Identify and Adapt High-Performing Centre Practices

Management should conduct a deeper comparison of the three centres to understand the factors associated with differences in completion performance.

The investigation should consider operational management, advertising and outreach, employee performance, enrollment patterns, payment plans and pricing, centre characteristics and location, as well as student demographics.

CodeBase Abuja's stronger completion performance provides a useful starting point for this investigation. Where the analysis identifies practices that may contribute to better outcomes, management should assess whether those practices can be adapted at lower-performing centres rather than assuming that the same approach will work everywhere.

Because the number of decided enrollments at each centre is relatively small, these findings should be treated as an area for further investigation rather than definitive evidence of centre performance.

## Recommendation 5: Evaluate Referral Sources by Centre and Student Outcomes

Management should evaluate referral sources at the centre level rather than relying on the overall enrollment volume of each channel.

Although Walk-in currently generates the highest number of enrollments, this does not necessarily mean it should be prioritised across every centre. Management should compare referral channels by enrollment volume, student outcomes and payment behaviour, while also considering acquisition costs where that information is available.

This analysis can identify which channels are most effective for each centre and help management allocate marketing resources based on the quality and performance of enrollments rather than volume alone.

## Recommendation 6: Evaluate Payment Plans by Centre

Management should evaluate payment-plan performance separately for each centre rather than assuming that the most widely adopted plan is the most suitable.

The analysis should compare payment-plan adoption, collection performance, outstanding balances, overdue payments and student outcomes across centres. This would help identify whether certain payment plans are better suited to particular locations or student groups.

Based on these findings, management can determine which payment arrangements to prioritise at each centre while maintaining a balance between student affordability and reliable fee collection.

## Recommendation 7: Investigate Course-Level Outcome Differences

Management should avoid making major decisions about course investment based on completion rates alone. The courses have different numbers of decided enrollments, and the overall dataset is relatively small, making large percentage differences sensitive to the number of students involved.

Before reducing investment in courses with lower completion rates, management should investigate factors such as student characteristics, payment behaviour, course structure, centre, and the level of student support provided.

Course completion should therefore be monitored alongside enrollment volume and other relevant business factors before decisions are made about programme investment or changes.

## Project Limitations

Several limitations should be considered when interpreting the findings from this analysis.

### 1. Small Dataset

The analysis is based on 35 enrollments. This relatively small population means that percentage differences, particularly at the course and centre level, can be strongly influenced by a small number of students. The findings should therefore be treated as indicators for further investigation rather than definitive evidence of performance.

### 2. Many Enrollments Are Still in Progress

Of the 35 enrollments, 17 are still active or suspended and have not reached a final outcome. Completion and dropout rates were therefore calculated using only the 18 decided enrollments. The eventual outcomes of the students still in progress may change the overall outcome picture.

### 3. Limited Historical Period

The enrollment data covers approximately one year, from July 2025 to June 2026. This limits the ability to identify long-term trends, seasonal patterns or changes in performance over several years.

### 4. Limited Explanatory Variables

The available data describes enrollment, payments, outcomes and student characteristics, but does not include some factors that could help explain the observed patterns. Examples include advertising expenditure, detailed employee performance, student satisfaction, attendance, academic performance and reasons for dropout.

### 5. Findings Do Not Establish Causation

The analysis identifies patterns and relationships in the available data but does not establish that one factor caused another. For example, differences in completion rates between centres or courses should not automatically be attributed to the centre, course or any individual characteristic without further investigation.

### 6. Payment Data Requires Careful Interpretation

Financial analysis uses the enrollment-level `Data` table and the installment-level `Payments` table separately because they have different grains. Combining these tables without accounting for the one-to-many relationship could duplicate enrollment-level values and produce misleading financial results.

### Overall Limitation

The analysis provides a useful baseline for understanding the training centre's current performance, but additional data and a larger historical population would allow management to investigate the identified patterns with greater confidence.


## Project Workflow

The project followed a structured data analysis workflow from raw data preparation through business reporting.

### 1. Data Preparation

The source CSV files were inspected and cleaned using Python and Pandas. Data types, missing values, duplicates and key fields were reviewed before analysis.

### 2. Data Transformation and Analysis

The datasets were joined at the appropriate level of detail to create an enrollment-level analytical dataset. Business metrics were calculated using the correct grain for each analysis.

Payment data was kept at installment level where appropriate to avoid duplicating enrollment-level financial values.

### 3. Exploratory Analysis

The analysis examined enrollment trends, course and centre performance, referral sources, financial collection, payment behaviour, student outcomes and demographic characteristics.

### 4. Business Analysis

The results were interpreted from a management perspective, focusing on areas such as enrollment concentration, outstanding fees, student dropout, centre performance, referral channels and payment plans.

### 5. Excel Reporting

An Excel report was created to provide a structured business reporting view of the analysis, including KPIs, tables, charts and interactive filtering.

### 6. Power BI Dashboard

The final interactive dashboard was developed in Power BI across four pages:

* Overview
* Financial Performance
* Student Outcomes
* Student Profile

The dashboard includes interactive filters for centre, course, status and enrollment date.

### 7. Documentation

The findings, recommendations, limitations and analytical decisions were documented in this README to make the project reproducible and understandable to both technical and non-technical users.

---

## Repository Structure

```text
Tech-IT-Training-Centre-Performance-Analysis/
│
├── README.md
│
├── data/
│   ├── raw/
│   │   ├── tech_it_enrollments.csv
│   │   ├── tech_it_students.csv
│   │   ├── tech_it_payments.csv
│   │   ├── tech_it_centers.csv
│   │   └── tech_it_courses.csv
│   │
│   └── processed/
│       └── enrollment_analysis.csv
│
├── python/
│   └── training_centre_analysis.ipynb
│
├── sql/
│   └── training_center_analysis.sql
│
├── excel/
│   └── training_centre_dashboard.xlsx
│
├── powerbi/
│   └── Tech_IT_Training_Centre_Performance_Dashboard.pbix
│
└── images/
    ├── overview.png
    ├── financials.png
    ├── outcomes.png
    └── student_profile.png
```

---

## How to Reproduce

### Requirements

The Python analysis requires:

* Python 3.x
* Pandas
* Matplotlib
* Jupyter Notebook

The SQL analysis requires a MySQL-compatible database environment.

Excel and Power BI are required to open and interact with the corresponding report files.

### Python Analysis

1. Clone or download the repository.
2. Open the project in VS Code or another Python development environment.
3. Open:

```text
python/training_centre_analysis.ipynb
```

4. Ensure the raw datasets are available in:

```text
data/raw/
```

5. Run the notebook from beginning to end.

The processed enrollment-level dataset will be generated in:

```text
data/processed/enrollment_analysis.csv
```

### SQL Analysis

The SQL analysis is available in:

```text
sql/training_center_analysis.sql
```

The script contains the SQL analysis used to investigate the training centre data and answer business questions.

### Excel Report

The completed Excel report is available at:

```text
excel/training_centre_dashboard.xlsx
```

The workbook contains the dashboard, supporting analysis sheets and source data used for reporting.

### Power BI Dashboard

The completed Power BI report is available at:

```text
powerbi/Tech_IT_Training_Centre_Performance_Dashboard.pbix
```

Open the `.pbix` file using Power BI Desktop to explore the interactive dashboard.

---

## Key Analytical Considerations

A major focus of this project was ensuring that calculations were performed at the appropriate level of detail.

The main analytical dataset has a grain of **one row per enrollment**, while the payment dataset has a grain of **one row per payment installment**.

These different grains were deliberately maintained to prevent one-to-many joins from duplicating enrollment-level financial values.

Outcome rates were also calculated using an appropriate denominator. Completion and dropout rates use only enrollments with a decided outcome: completed or dropped out. Active and suspended enrollments remain in progress and are therefore excluded from the decided-outcome denominator.

This approach helps ensure that the reported metrics reflect the underlying business process rather than simply counting rows.
