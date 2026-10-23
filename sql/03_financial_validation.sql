USE insurance_fraud;

-- checking zero approvals against fraud status

select fraudulent,
	count(*) as total_claims,
    sum(approved_amount = 0) as zero_approved_claims,
    sum(approved_amount > 0) as positive_approved_claims
from insurance_claims
group by fraudulent;

-- comparing financial amounts by fraud status

select fraudulent,
	round(avg(claim_amount), 2) as avg_claim_amount,
    round(avg(approved_amount), 2) as avg_approved_amount,
    round(avg(deductible), 2) as avg_deductible_amount,
    round(avg(repair_cost), 2) as avg_repair_cost,
    round(avg(medical_cost), 2) as avg_medical_cost,
    round(avg(payout_amount), 2) as avg_payout_amount
from insurance_claims
group by fraudulent;

-- check whether incident happend after claim submission date

select
	count(*) as total_records,
    sum(incident_date > claim_date) as incident_after_claim,
	sum(incident_date = claim_date) as same_day_reporting,
    sum(incident_date < claim_date) as claim_after_incident
from insurance_claims;

-- comparing claim reporting delays by fraud status

select fraudulent,
	count(*) as total_claims,
    round(avg(datediff(claim_date, incident_date)), 2) as avg_reporting_delay_days,
    min(datediff(claim_date, incident_date)) as min_reporting_delay_days,
    max(datediff(claim_date, incident_date)) as max_reporting_delay_days
from insurance_claims
GROUP BY fraudulent;

-- checking for duplicate records (like same customer applying for multiple claims) 

select customer_id,
	count(*)  as total_claims,
    sum(fraudulent = 'Yes') as fraudulent_claim
from insurance_claims
group by customer_id
having count(*) > 1
order by total_claims desc
limit 10;
    
-- checking whether frauds rates differ by previous claim history

select previous_claims,
	count(*) as total_claims,
	sum(fraudulent = 'Yes') as fraudulent_claims,
    round(sum(fraudulent = 'Yes') * 100.0/count(*), 2 ) as fraud_rate_percentage
from insurance_claims
group by previous_claims
order by previous_claims;

-- change date type to datetime

SELECT
    COUNT(*) AS total_records,

    SUM(
        claim_date IS NOT NULL
        AND STR_TO_DATE(claim_date, '%Y-%m-%d') IS NULL
    ) AS invalid_claim_dates,

    SUM(
        incident_date IS NOT NULL
        AND STR_TO_DATE(incident_date, '%Y-%m-%d') IS NULL
    ) AS invalid_incident_dates,

    SUM(
        policy_start_date IS NOT NULL
        AND STR_TO_DATE(policy_start_date, '%Y-%m-%d') IS NULL
    ) AS invalid_policy_dates

FROM insurance_claims;


-- checking payouts exceeding against coverage amt

select count(*) as payout_exceeding_amt
from insurance_claims 
where payout_amount > coverage_amount;

-- claim exceeding both coverage and approved amt

select
    count(*) as claims_exceeding_both
from insurance_claims
where payout_amount > coverage_amount
  and payout_amount > approved_amount;