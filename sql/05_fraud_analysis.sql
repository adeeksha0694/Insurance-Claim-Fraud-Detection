use insurance_fraud;

-- 1. overall comparison of fraudulent and non-fraudulent claims

select
    fraudulent,
    count(*) as total_claims,
    round(
        count(*) * 100.0 /
        (select count(*) from insurance_claims),
        2
    ) as claim_percentage,
    round(avg(claim_amount), 2) as avg_claim_amount,
    round(avg(approved_amount), 2) as avg_approved_amount,
    round(avg(payout_amount), 2) as avg_payout_amount,
    round(avg(fraud_risk_score), 2) as avg_fraud_risk_score
from insurance_claims
group by fraudulent
order by fraudulent;


-- 2. fraud distribution by claim status

select
    claim_status,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by claim_status
order by fraud_percentage desc;

-- 3. fraud risk score distribution by fraud classification

with ranked_scores as (
    select
        fraudulent,
        fraud_risk_score,
        row_number() over (
            partition by fraudulent
            order by fraud_risk_score
        ) as row_num,
        count(*) over (
            partition by fraudulent
        ) as total_rows
    from insurance_claims
)
select
    fraudulent,
    count(*) as total_claims,
    min(fraud_risk_score) as min_risk_score,
    round(avg(fraud_risk_score), 2) as avg_risk_score,
    max(fraud_risk_score) as max_risk_score,
    max(
        case
            when row_num = ceiling(total_rows * 0.50)
            then fraud_risk_score
        end
    ) as median_risk_score
from ranked_scores
group by fraudulent
order by fraudulent;

-- 4. fraud analysis by incident type

select
    incident_type,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by incident_type
order by fraud_percentage desc;

-- 5. fraud analysis by policy type

select
    policy_type,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by policy_type
order by fraud_percentage desc;

-- 6. fraud analysis by age group

select
    case
        when age < 25 then 'Under 25'
        when age between 25 and 34 then '25-34'
        when age between 35 and 44 then '35-44'
        when age between 45 and 54 then '45-54'
        when age between 55 and 64 then '55-64'
        else '65 and above'
    end as age_group,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by age_group
order by
    case age_group
        when 'Under 25' then 1
        when '25-34' then 2
        when '35-44' then 3
        when '45-54' then 4
        when '55-64' then 5
        when '65 and above' then 6
    end;
    

-- 7. fraud analysis by incident location

select
    incident_location,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by incident_location
order by fraud_percentage desc;

-- 8. fraud analysis by claim amount range

select
    case
        when claim_amount < 1000 then 'Below 1000'
        when claim_amount < 5000 then '1000-4999.99'
        when claim_amount < 10000 then '5000-9999.99'
        when claim_amount < 20000 then '10000-19999.99'
        else '20000 and above'
    end as claim_amount_range,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by claim_amount_range
order by
    case claim_amount_range
        when 'Below 1000' then 1
        when '1000-4999.99' then 2
        when '5000-9999.99' then 3
        when '10000-19999.99' then 4
        when '20000 and above' then 5
    end;
    
-- 9. fraud analysis by risk score range

select
    case
        when fraud_risk_score < 10 then '0-9'
        when fraud_risk_score < 20 then '10-19'
        when fraud_risk_score < 30 then '20-29'
        when fraud_risk_score < 40 then '30-39'
        when fraud_risk_score < 50 then '40-49'
        when fraud_risk_score < 60 then '50-59'
        when fraud_risk_score < 70 then '60-69'
        when fraud_risk_score < 80 then '70-79'
        when fraud_risk_score < 90 then '80-89'
        else '90-100'
    end as risk_score_range,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by risk_score_range
order by
    case risk_score_range
        when '0-9' then 1
        when '10-19' then 2
        when '20-29' then 3
        when '30-39' then 4
        when '40-49' then 5
        when '50-59' then 6
        when '60-69' then 7
        when '70-79' then 8
        when '80-89' then 9
        when '90-100' then 10
    end;
    
    -- 10. financial distribution by fraud classification

select
    fraudulent,
    count(*) as total_claims,
    round(avg(claim_amount), 2) as avg_claim_amount,
    round(min(claim_amount), 2) as min_claim_amount,
    round(max(claim_amount), 2) as max_claim_amount,
    round(avg(deductible), 2) as avg_deductible,
    round(avg(coverage_amount), 2) as avg_coverage_amount
from insurance_claims
group by fraudulent
order by fraudulent;

-- 11. fraud analysis by previous claim history

select
    previous_claims,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by previous_claims
order by previous_claims;

-- 12. fraud analysis by statement consistency

select
    inconsistent_statements,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by inconsistent_statements
order by fraud_percentage desc;

-- 13. fraud analysis by gps location match

select
    gps_location_match,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by gps_location_match
order by fraud_percentage desc;

-- 14. fraud analysis by injury status

select
    injuries,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by injuries
order by fraud_percentage desc;

-- 15. fraud analysis by policy activity

select
    policy_active,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by policy_active
order by fraud_percentage desc;

-- 16. fraud analysis by witness count

select
    witnesses,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by witnesses
order by witnesses;

-- 17. fraud analysis by claim status and gps location match

select
    claim_status,
    gps_location_match,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by claim_status, gps_location_match
order by claim_status, gps_location_match;

-- 18. fraud analysis by gps match and statement consistency

select
    gps_location_match,
    inconsistent_statements,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    gps_location_match,
    inconsistent_statements
order by
    gps_location_match,
    inconsistent_statements;
    
-- 19. fraud analysis by gps match and statement consistency within denied claims

select
    gps_location_match,
    inconsistent_statements,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
where claim_status = 'Denied'
group by
    gps_location_match,
    inconsistent_statements
order by
    fraud_percentage desc;
    
-- 20. investigate risk score and potential label leakage

select
    claim_status,
    fraudulent,
    count(*) as total_claims,
    min(fraud_risk_score) as min_risk_score,
    round(avg(fraud_risk_score), 2) as avg_risk_score,
    max(fraud_risk_score) as max_risk_score
from insurance_claims
group by
    claim_status,
    fraudulent
order by
    claim_status,
    fraudulent;
    
    -- 21. investigate fraud label distribution within claim status

select
    claim_status,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    sum(case when fraudulent = 'No' then 1 else 0 end) as non_fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by claim_status
order by fraud_percentage desc;

-- 22. validate financial patterns in fraudulent claims

select
    fraudulent,
    count(*) as total_claims,
    sum(case when approved_amount = 0 then 1 else 0 end) as zero_approved_amount,
    sum(case when payout_amount = 0 then 1 else 0 end) as zero_payout_amount,
    sum(case when approved_amount > 0 then 1 else 0 end) as positive_approved_amount,
    sum(case when payout_amount > 0 then 1 else 0 end) as positive_payout_amount
from insurance_claims
group by fraudulent
order by fraudulent;


-- 23. fraud analysis by claim-to-coverage ratio

select
    case
        when claim_amount / nullif(coverage_amount, 0) < 0.05
            then 'Below 5%'
        when claim_amount / nullif(coverage_amount, 0) < 0.10
            then '5% to below 10%'
        when claim_amount / nullif(coverage_amount, 0) < 0.25
            then '10% to below 25%'
        else '25% or above'
    end as claim_coverage_ratio,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    case
        when claim_amount / nullif(coverage_amount, 0) < 0.05
            then 'Below 5%'
        when claim_amount / nullif(coverage_amount, 0) < 0.10
            then '5% to below 10%'
        when claim_amount / nullif(coverage_amount, 0) < 0.25
            then '10% to below 25%'
        else '25% or above'
    end
order by min(claim_amount / nullif(coverage_amount, 0));

-- 24. fraud analysis by claim amount and claim-to-coverage ratio

select
    case
        when claim_amount < 1000 then 'Below 1000'
        when claim_amount < 5000 then '1000 to below 5000'
        when claim_amount < 10000 then '5000 to below 10000'
        when claim_amount < 20000 then '10000 to below 20000'
        else '20000 or above'
    end as claim_amount_range,
    case
        when claim_amount / nullif(coverage_amount, 0) < 0.05
            then 'Below 5%'
        when claim_amount / nullif(coverage_amount, 0) < 0.10
            then '5% to below 10%'
        when claim_amount / nullif(coverage_amount, 0) < 0.25
            then '10% to below 25%'
        else '25% or above'
    end as claim_coverage_ratio,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    case
        when claim_amount < 1000 then 'Below 1000'
        when claim_amount < 5000 then '1000 to below 5000'
        when claim_amount < 10000 then '5000 to below 10000'
        when claim_amount < 20000 then '10000 to below 20000'
        else '20000 or above'
    end,
    case
        when claim_amount / nullif(coverage_amount, 0) < 0.05
            then 'Below 5%'
        when claim_amount / nullif(coverage_amount, 0) < 0.10
            then '5% to below 10%'
        when claim_amount / nullif(coverage_amount, 0) < 0.25
            then '10% to below 25%'
        else '25% or above'
    end
order by
    min(claim_amount),
    min(claim_amount / nullif(coverage_amount, 0));
    
-- 25. fraud analysis by incident-to-claim reporting delay

select
    case
        when datediff(claim_date, incident_date) <= 1
            then '0-1 days'
        when datediff(claim_date, incident_date) <= 3
            then '2-3 days'
        when datediff(claim_date, incident_date) <= 7
            then '4-7 days'
        when datediff(claim_date, incident_date) <= 14
            then '8-14 days'
        else 'Above 14 days'
    end as reporting_delay,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    case
        when datediff(claim_date, incident_date) <= 1
            then '0-1 days'
        when datediff(claim_date, incident_date) <= 3
            then '2-3 days'
        when datediff(claim_date, incident_date) <= 7
            then '4-7 days'
        when datediff(claim_date, incident_date) <= 14
            then '8-14 days'
        else 'Above 14 days'
    end
order by min(datediff(claim_date, incident_date));

-- 26. validate delayed reporting indicator against date difference

select
    delayed_reporting,
    count(*) as total_claims,
    round(
        avg(datediff(claim_date, incident_date)),
        2
    ) as avg_reporting_delay_days,
    min(datediff(claim_date, incident_date)) as min_delay_days,
    max(datediff(claim_date, incident_date)) as max_delay_days,
    sum(
        case
            when datediff(claim_date, incident_date) < 0 then 1
            else 0
        end
    ) as negative_delay_claims
from insurance_claims
group by delayed_reporting
order by delayed_reporting;

-- 27. fraud analysis by delayed reporting indicator

select
    delayed_reporting,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by delayed_reporting
order by delayed_reporting;

-- 28. fraud analysis by claim submission time

select
    claim_submitted_at_night,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by claim_submitted_at_night
order by claim_submitted_at_night;

-- 29. fraud analysis by suspicious documents

select
    suspicious_documents,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by suspicious_documents
order by suspicious_documents;

-- 30. fraud analysis by identity verification

select
    identity_verified,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by identity_verified
order by identity_verified;

-- 31. fraud analysis by repair shop verification

select
    repair_shop_verified,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by repair_shop_verified
order by repair_shop_verified;

-- 32. fraud analysis by police report

select
    police_report,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by police_report
order by police_report;

-- 33. fraud analysis by claim history risk

select
    claim_history_risk,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by claim_history_risk
order by claim_history_risk;

-- 34. validate claim history risk against fraud risk score

select
    claim_history_risk,
    count(*) as total_claims,
    round(avg(fraud_risk_score), 2) as avg_fraud_risk_score,
    min(fraud_risk_score) as min_fraud_risk_score,
    max(fraud_risk_score) as max_fraud_risk_score
from insurance_claims
group by claim_history_risk
order by claim_history_risk;

-- 35. fraud analysis by claim history risk and suspicious documents

select
    claim_history_risk,
    suspicious_documents,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    claim_history_risk,
    suspicious_documents
order by
    claim_history_risk,
    suspicious_documents;
    
    -- 36. fraud analysis by identity verification and suspicious documents

select
    identity_verified,
    suspicious_documents,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    identity_verified,
    suspicious_documents
order by
    identity_verified,
    suspicious_documents;
    
    -- 37. fraud analysis by suspicious documents and nighttime submission

select
    suspicious_documents,
    claim_submitted_at_night,
    count(*) as total_claims,
    sum(case when fraudulent = 'Yes' then 1 else 0 end) as fraudulent_claims,
    round(
        sum(case when fraudulent = 'Yes' then 1 else 0 end) * 100.0
        / count(*),
        2
    ) as fraud_percentage
from insurance_claims
group by
    suspicious_documents,
    claim_submitted_at_night
order by
    suspicious_documents,
    claim_submitted_at_night;
    
-- 38. distribution of suspicious documents and nighttime submission

select
    suspicious_documents,
    claim_submitted_at_night,
    count(*) as total_claims,
    round(
        count(*) * 100.0
        / (select count(*) from insurance_claims),
        2
    ) as percentage_of_all_claims
from insurance_claims
group by
    suspicious_documents,
    claim_submitted_at_night
order by
    total_claims desc;