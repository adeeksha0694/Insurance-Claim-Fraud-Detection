USE insurance_fraud;

-- checking the table structure 

describe insurance_claims;

-- checking total number of records

select
    count(*) as total_records
from insurance_claims;

-- checking duplicate claim IDs

select claim_id, count(*) as occurences from insurance_claims group by claim_id having count(*) > 1; 

-- checking missing vlaues in important columns

select 
	sum(claim_id is null) as missing_claim_id,
    sum(claim_amount is null) as missing_claim_amt,
    sum(approved_amount is null) as missing_approved_amt,
    sum(claim_date is null) as missing_claim_date,
    sum(incident_date is null) as missing_incident_date,
    sum(fraudulent is null) as missing_fraudulent
from insurance_claims;

-- checking the fraud distribution

select fraudulent, count(*) as total_claims, 
	round(count(*) * 100.0 / (select count(*) from insurance_claims), 2) as percentage 
    from insurance_claims group by fraudulent;
    
-- checking whether claim amounts imported correctly

select
	min(claim_amount) as min_claim,
    max(claim_amount) as max_claim,
    avg(claim_amount) as avg_claim,
    sum(claim_amount is null) as missing_claim_amt
from insurance_claims;
    
-- checking date range

select 
	min(claim_date) as earliest_claim_date,
    max(claim_date) as latest_claim_date,
    sum(claim_date is null) as missing_claim_date
from insurance_claims;

-- checking whether the csv columns were imported correctly

select
    claim_id,
    claim_date,
    incident_date,
    claim_amount,
    approved_amount,
    deductible,
    repair_cost,
    medical_cost,
    payout_amount,
    fraudulent
from insurance_claims
limit 10;


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    