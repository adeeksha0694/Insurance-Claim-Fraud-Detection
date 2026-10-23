# Insurance Claim & Fraud Detection

## Exploratory Data Analysis (EDA) Report

### 1. Executive Summary

This project explores insurance claims to identify patterns associated with fraudulent claims, examine financial outcomes, assess data quality, and develop insights for insurance claim analysis.

The dataset contains 100,000 claims, with 79,958 non-fraudulent claims (79.96%) and 20,042 fraudulent claims (20.04%). SQL was used for structured validation and analysis, followed by Python-based exploratory data analysis, statistical comparisons, and correlation analysis.

The analysis identified differences in fraud-label rates across accident severity and several investigation-related indicators. It also revealed unusually strong relationships between the fraud label and `fraud_risk_score`, `claim_status`, `approved_amount`, and `payout_amount`.

These relationships raise significant concerns about potential target leakage or rules used to generate the dataset. The available evidence does not establish how the labels were created.

The findings are useful for descriptive analysis, but the dataset's label-generation process and the timing of predictor availability should be investigated before predictive modeling.

### 2. Project Objectives

* Validate the dataset's structure, completeness, and integrity.
* Analyze insurance claim amounts and financial outcomes.
* Explore fraud-label patterns across customer, policy, vehicle, and incident characteristics.
* Identify missing values, outliers, and potential financial inconsistencies.
* Investigate statistical relationships between claim characteristics and the fraud label.
* Identify potential target leakage.
* Prepare insights for an interactive Power BI report.

### 3. Dataset Overview

| Attribute                                | Result           |
| ---------------------------------------- | ---------------- |
| Total claims                             | 100,000          |
| Columns in the current working DataFrame | 71               |
| Duplicate claim IDs                      | 0                |
| Non-fraudulent claims                    | 79,958           |
| Non-fraudulent percentage                | 79.96%           |
| Fraudulent claims                        | 20,042           |
| Fraudulent percentage                    | 20.04%           |
| Earliest claim date                      | January 1, 2021  |
| Latest claim date                        | January 10, 2026 |
| Column with missing values               | `vehicle_damage` |
| Missing `vehicle_damage` values          | 16,527 (16.53%)  |

The current DataFrame includes eight known engineered columns: `reporting_delay_days`, `age_group`, `income_group`, `credit_score_group`, `claim_month`, `claim_year`, `fraud_flag`, and `vehicle_damage_missing`.

Before exporting the final dataset, the current columns should be compared against the complete original schema. The original CSV must remain unchanged.

### 4. Methodology

The analysis included:

1. Data structure and data-type validation.
2. Missing-value and duplicate checks.
3. Descriptive statistics for numeric variables.
4. IQR-based outlier exploration.
5. Fraud-rate comparisons across customer, policy, vehicle, and incident categories.
6. Monthly and yearly claim analysis.
7. Correlation analysis.
8. Mann–Whitney U tests for selected numeric comparisons.
9. A chi-square test and Cramér's V for accident severity.
10. Financial consistency checks and targeted potential-leakage investigations.

These methods describe patterns in the observed dataset. Statistical significance does not automatically imply a large practical effect, and association does not establish causation.

### 5. Data Quality Findings

#### 5.1 Record integrity

The final integrity check confirmed:

* 100,000 records.
* Zero duplicate claim IDs.
* 79,958 non-fraudulent claims.
* 20,042 fraudulent claims.
* A fraud-label distribution of approximately 80% non-fraudulent and 20% fraudulent.

These checks support the structural integrity of the records, but do not independently validate the correctness of every field or fraud label.

#### 5.2 Missing values

The `vehicle_damage` column contains 16,527 missing values, representing 16.53% of records.

The missing-value rate was approximately:

* 16.63% among non-fraudulent claims.
* 16.12% among fraudulent claims.

The source appears to use the literal value `"None"`, which pandas interprets as missing.

**Recommendation:** Do not automatically interpret missing vehicle-damage information as no damage. Confirm its meaning before recoding it. If the meaning remains unknown, retain it as an explicit unknown or unrecorded category for reporting.

#### 5.3 Financial consistency

The analysis identified the following potential inconsistencies:

* 19,936 records where payout exceeds approved amount.
* Some denied claims with positive payouts.
* 653 records where payout exceeds coverage amount.

The checks also found no negative financial values in the reviewed fields, and `approved_amount` did not exceed `claim_amount`.

The `exceeds_coverage` indicator matched the comparison between claim amount and coverage amount.

These observations should be investigated against documented business rules. They should not automatically be treated as errors because the dataset does not specify every rule governing approvals and payouts.

#### 5.4 Outlier analysis

IQR-based analysis identified potential outliers in:

| Variable        | Percentage flagged |
| --------------- | -----------------: |
| Claim amount    |              7.63% |
| Approved amount |              8.58% |
| Payout amount   |              9.47% |
| Repair cost     |              9.70% |
| Medical cost    |             17.97% |

These are statistical flags, not confirmed data errors. Large claims and medical expenses may be legitimate. Records should not be removed solely because they fall outside IQR limits.

### 6. Key Exploratory Findings

#### 6.1 Claim amounts

The average claim amount was approximately 7,066.21.

The comparison by fraud label showed:

* Average non-fraudulent claim amount: 6,632.70.
* Average fraudulent claim amount: 8,795.70.
* Median non-fraudulent claim amount: 3,424.16.
* Median fraudulent claim amount: 4,428.21.

The fraudulent-claim median was approximately 29.3% higher.

The Mann–Whitney U test found a statistically significant difference in the distributions (p ≈ 2.42 × 10⁻¹¹⁵). However, the normalized U statistic was approximately 0.552, indicating modest distributional separation despite the very small p-value.

**Interpretation:** Fraudulent claims have higher claim amounts in this dataset, but claim amount alone does not strongly distinguish the two groups.

#### 6.2 Medical costs

Medical costs were zero in 72,995 claims and positive in 27,005 claims.

| Metric                             | Non-fraudulent | Fraudulent |
| ---------------------------------- | -------------: | ---------: |
| Claims with positive medical costs |         25.61% |     32.56% |
| Average medical cost               |       1,020.93 |   1,317.55 |

Fraudulent claims had higher average medical costs and a higher proportion of positive medical expenses.

This is an observed association, not evidence that medical expenses cause fraud.

#### 6.3 Accident severity

| Accident severity | Total claims | Fraudulent claims | Fraud rate |
| ----------------- | -----------: | ----------------: | ---------: |
| Total Loss        |       10,007 |             2,844 |     28.42% |
| Major             |       19,992 |             4,910 |     24.56% |
| Minor             |       39,979 |             7,063 |     17.67% |
| Moderate          |       30,022 |             5,225 |     17.40% |

The fraud-label rate was highest for Total Loss and Major incidents.

The chi-square test produced:

* Chi-square statistic: approximately 964.08.
* Degrees of freedom: 3.
* p-value: approximately 1.11 × 10⁻²⁰⁸.
* Cramér's V: approximately 0.098.

Although the association was statistically significant, Cramér's V indicates a weak association.

#### 6.4 Investigation-related indicators

| Indicator               | Category | Claims | Fraud rate |
| ----------------------- | -------- | -----: | ---------: |
| Suspicious documents    | Yes      |  8,127 |     92.94% |
| Suspicious documents    | No       | 91,873 |     13.59% |
| Identity verified       | No       |  8,119 |     69.05% |
| Identity verified       | Yes      | 91,881 |     15.71% |
| GPS location match      | No       | 12,032 |     48.71% |
| GPS location match      | Yes      | 87,968 |     16.12% |
| Inconsistent statements | Yes      |  9,046 |     50.24% |
| Inconsistent statements | No       | 90,954 |     17.04% |
| Repair shop verified    | No       | 15,144 |     28.96% |
| Repair shop verified    | Yes      | 84,856 |     18.45% |
| Delayed reporting       | Yes      |  5,126 |     38.51% |
| Delayed reporting       | No       | 94,874 |     19.04% |

Suspicious documents showed the strongest association among these indicators. Identity verification failures, GPS mismatches, inconsistent statements, unverified repair shops, and delayed reporting also showed higher fraud-label rates.

However, some of these fields may be recorded during or after an investigation. Their usefulness for early detection depends on when they become available.

#### 6.5 Reporting delay

The average reporting delay was approximately 1.55 days, while the median was one day.

The Mann–Whitney U test found a distributional difference between fraud classes (p ≈ 1.68 × 10⁻⁴⁵). The normalized U statistic was approximately 0.531, indicating modest separation.

The fraud-label rate was 38.51% for delayed reporting and 19.04% for non-delayed reporting.

The very small p-value should be interpreted alongside the modest effect size.

#### 6.6 Customer and policy characteristics

Fraud-label rates were broadly similar across most demographic and policy categories.

Examples include:

* Gender-group rates were generally around 20%.
* Income-band rates ranged from approximately 19.75% to 20.44%.
* Credit-score-band rates ranged from approximately 19.79% to 20.16%.
* Policy-type rates ranged from approximately 19.86% to 20.17%.
* Incident-location rates ranged from approximately 19.87% to 20.18%.
* Age-group rates ranged from approximately 19.79% to 20.43%.

These small differences do not indicate strong separation in the descriptive analysis.

#### 6.7 Previous claims

Fraud-label rates were approximately 18.7%–19.2% for customers with zero, one, or two previous claims. The rates increased to around 40% for customers with three or four previous claims.

Groups with five or more previous claims were small, so their rates are less stable.

The `previous_claims` field did not always match the number of earlier claims visible within the dataset. This may reflect claims that occurred before the dataset's date range; it is not confirmed to be a data error.

#### 6.8 Temporal patterns

The dataset covers claims from January 2021 through January 10, 2026.

* Annual fraud-label rates for 2021–2025 remained close to 20%.
* Monthly fraud-label rates ranged from approximately 19.63% to 20.40%.
* No clear seasonal pattern was observed.
* The 2026 data contains only 49 claims and should not be compared directly with complete years.

### 7. Critical Finding: Potential Target Leakage

The analysis identified unusually strong relationships between the target label and several fields.

#### 7.1 Fraud risk score

Every claim with a `fraud_risk_score` below 22 is labelled non-fraudulent. Every claim with a score of 22 or above is labelled fraudulent.

This is perfect separation across all observed scores.

#### 7.2 Claim status

All 20,042 fraudulent claims are marked `Denied`.

No fraudulent labels appear in Approved, Closed, Pending, or Under Review claims. Among denied claims, 55.61% are labelled fraudulent.

#### 7.3 Approved amount and payout

The analysis found:

* All fraudulent claims have an approved amount of zero.
* All non-fraudulent claims have positive approved amounts.
* All fraudulent claims have a payout of zero.
* Positive payouts occur only among non-fraudulent claims.

These patterns raise concerns about potential target leakage or shared rules used to generate the dataset.

The current analysis cannot determine whether the fraud label was derived from these fields, the fields were derived from the label, or both were generated using a shared rule.

#### 7.4 Implications

For a predictive model intended to flag fraud when a claim is submitted:

* Exclude `fraud_risk_score` from an initial baseline until its generation method is understood.
* Do not use `claim_status`, `approved_amount`, or `payout_amount` unless their availability at the intended prediction point is justified.
* Investigate when suspicious-document findings, identity verification, inconsistent statements, GPS matching, and repair-shop verification become available.
* Verify the fraud-label generation process if source documentation is available.
* Do not claim real-world predictive validity until leakage has been addressed and the labels have been independently validated.

For descriptive Power BI reporting, these fields can be included with appropriate explanations of their limitations.

### 8. Recommended Power BI Dashboard

#### Page 1: Claims Overview

Suggested visuals:

* Total claims.
* Fraudulent claims and observed fraud-label rate.
* Total claim amount.
* Total approved amount and payout.
* Claims by status.
* Claim volume by month and year.

#### Page 2: Fraud Analysis

Suggested visuals:

* Fraud-label rate by accident severity.
* Fraud-label rate by incident type.
* Fraud-label rate by reporting delay.
* Fraud-label rates for investigation-related indicators.
* Fraud-label rate by previous-claim group, with small groups identified.

#### Page 3: Financial Analysis

Suggested visuals:

* Claim amount versus approved amount.
* Approved amount versus payout.
* Payouts exceeding approved amounts.
* Payouts exceeding coverage.
* Financial distributions and high-value claims.

The report should describe these as observed fraud-label rates, not independently validated real-world fraud probabilities.

### 9. Business Recommendations

1. Investigate how the fraud label and `fraud_risk_score` were generated.
2. Define the intended prediction point and document when each field becomes available.
3. Review payouts exceeding approved amounts or coverage against documented business rules.
4. Clarify the meaning of missing `vehicle_damage` values.
5. Review investigation-related indicators cautiously because association does not establish causation.
6. Avoid overinterpreting demographic differences, which were generally small.
7. If predictive modeling proceeds, report precision, recall, F1-score, confusion matrix, and precision–recall AUC in addition to accuracy.
8. Preserve the raw CSV and export a separate processed dataset only after the source schema and transformation choices are documented.

### 10. Limitations

* The dataset is described as synthetic; results may not generalize to real insurance claims.
* The fraud-label and risk-score generation processes have not been independently verified.
* Several fields may reflect decisions made after claim submission or may encode the target.
* Field availability at the intended prediction point is not documented.
* Some financial exceptions may be valid under business rules that were not supplied.
* The meaning of missing `vehicle_damage` values remains unresolved.
* The 2026 period contains only 49 claims.
* Large samples can produce very small p-values for modest effects.
* Descriptive associations do not establish causation.

### 11. Conclusion

The EDA established an overview of the 100,000-claim dataset and identified descriptive patterns, missing values, financial exceptions, and potential leakage.

Accident severity and selected investigation-related indicators show differences in fraud-label rates, while most demographic, policy, and temporal groups show relatively little variation.

The most important finding is the perfect separation between the fraud label and `fraud_risk_score`, together with the relationships involving claim status, approved amount, and payout. These relationships must be explained before the dataset is used to train or evaluate a predictive fraud-detection model.

The next stage is to verify the source schema, preserve the raw data, prepare a documented Power BI export, and build dashboards that communicate both the findings and the limitations transparently.
