\# Insurance Claim Fraud Detection



\## Project Overview



This project analyzes insurance claims to explore fraud patterns, claim characteristics, financial discrepancies, customer profiles, and operational trends. It uses Python for data preparation and exploratory data analysis, SQL for data validation and analytical queries, and Power BI to develop an interactive dashboard.



The objective is to identify patterns in the available fraud labels, examine claim-related financial exceptions, and present meaningful insights through data visualization.



\## Objectives



\* Analyze insurance claims and their financial characteristics.

\* Examine fraud-labelled and non-fraud-labelled claims.

\* Explore customer demographics, policy types, and incident characteristics.

\* Identify discrepancies between claimed, approved, and paid amounts.

\* Analyze trends in claims, approvals, and payouts.

\* Build an interactive Power BI report for exploring claim data.



\## Tools and Technologies



\* \*\*Python:\*\* Data cleaning, preparation, and exploratory data analysis.

\* \*\*Pandas:\*\* Data manipulation and analysis.

\* \*\*Jupyter Notebook:\*\* Analysis workflow and documentation.

\* \*\*SQL:\*\* Data validation, financial checks, and analytical queries.

\* \*\*Power BI:\*\* Interactive dashboards and data visualization.

\* \*\*Git and GitHub:\*\* Version control and project hosting.



\## Dataset



The dataset contains 100,000 insurance claim records and 62 original columns. The processed dataset contains 65 columns, including three additional financial exception flags.



The data covers:



\* Claim information and claim status

\* Customer demographics and claim history

\* Insurance policy details

\* Incident and accident characteristics

\* Vehicle information

\* Fraud indicators and fraud risk scores

\* Claim amounts, approved amounts, payouts, and related costs



The raw dataset is retained locally and excluded from the Git repository. The processed dataset is included in the repository.



\## Project Structure



```text

Insurance-Claim-Fraud-Detection/

│

├── data/

│   ├── raw/                         # Original dataset (not uploaded)

│   └── processed/

│       └── insurance\_claim\_fraud\_powerbi.csv

│

├── notebooks/

│   ├── 01\_data\_understanding.ipynb

│   ├── 02\_exploratory\_data\_analysis.ipynb

│   └── 03\_data\_preparation.ipynb

│

├── power bi/

│   └── Insurance\_Claim\_Fraud\_Detection.pbix

│

├── reports/

│   ├── Insurance\_Claim\_Fraud\_Detection\_Final\_Report.pdf

│   └── insurance\_claim\_fraud\_eda\_report.md

│

├── screenshots/

│   ├── Overview.png

│   ├── Fraud Risk Analysis \& Detection.png

│   ├── Insurance claims and financial analysis.png

│   └── Operational insights.png

│

├── sql/

│   ├── 01\_create\_database.sql

│   ├── 02\_data\_validation.sql

│   ├── 03\_financial\_validation.sql

│   ├── 04\_claim\_analysis.sql

│   ├── 05\_fraud\_analysis.sql

│   └── 06\_advanced\_sql\_analysis.sql

│

├── .gitignore

└── README.md

```



\## Exploratory Data Analysis



The analysis explores:



\* Distribution of claim amounts and payouts

\* Claim patterns across policy and incident types

\* Customer demographic characteristics

\* Fraud-label distribution

\* Fraud risk score patterns

\* Financial exceptions involving coverage, approvals, and payouts

\* Trends in claims, approvals, and payouts over time



\## SQL Analysis



The SQL scripts cover database setup, data validation, financial validation, claim analysis, fraud analysis, and advanced analytical queries.



The analyses examine claim distributions, fraud labels, financial discrepancies, and relationships among claim attributes.



\## Power BI Dashboard



The Power BI report is organized into four analytical pages:



\### 1. Insurance Claims Overview



Summarizes overall claim volumes, claim amounts, approvals, payouts, and key claim characteristics.



\### 2. Fraud Risk Analysis \& Detection



Explores fraud-labelled claims, fraud risk categories, incident characteristics, accident severity, and suspicious-document indicators.



\### 3. Insurance Claim Financial Analysis



Compares claimed, approved, and paid amounts; examines cost composition; identifies financial exceptions; and analyzes annual trends.



\### 4. Customer, Policy \& Operational Insights



Explores customer profiles, policy premiums, occupation and policy-type patterns, claim status, and claim amount characteristics.



\### Dashboard Screenshots



\#### Insurance Claims Overview



!\[Insurance Claims Overview](screenshots/Overview.png)



\#### Fraud Risk Analysis \& Detection



!\[Fraud Risk Analysis](screenshots/Fraud%20Risk%20Analysis%20%26%20Detection.png)



\#### Insurance Claim Financial Analysis



!\[Financial Analysis](screenshots/Insurance%20claims%20and%20financial%20analysis.png)



\#### Customer, Policy \& Operational Insights



!\[Operational Insights](screenshots/Operational%20insights.png)



\## Key Findings



\* The dataset contains 100,000 claims.

\* Approximately 20.04% of records are labelled fraudulent, while 79.96% are labelled non-fraudulent.

\* Financial validation identified claims exceeding policy coverage, payouts exceeding approved amounts, and payouts exceeding coverage.

\* Repair costs account for the largest share of the analyzed claim cost components.

\* Fraud risk scores show a strong separation between the dataset's fraud labels.



\*\*Important limitation:\*\* The fraud labels and risk scores exhibit a strong relationship in this dataset. This may indicate target leakage or a label-generation rule. The findings should therefore be interpreted as descriptive patterns in the supplied data, not proof that the risk score independently predicts real-world fraud.



\## How to Use This Project



1\. Clone or download the repository.

2\. Install Python and the required data analysis libraries.

3\. Open the notebooks in Jupyter Notebook or JupyterLab.

4\. Ensure the source dataset is available locally before running the notebooks that depend on it.

5\. Execute the SQL scripts in a compatible SQL environment.

6\. Open the Power BI file in Power BI Desktop.

7\. Use the dashboard filters to explore the claim data and findings.



\## Limitations



\* The analysis depends on the quality and reliability of the supplied dataset.

\* Associations between claim characteristics and fraud labels do not establish causation.

\* The observed fraud rate describes the dataset and should not be interpreted as an industry-wide rate.

\* Potential target leakage limits conclusions about predictive fraud detection performance.

\* Financial exceptions indicate records requiring review; they do not independently establish fraud.



\## Conclusion



This project demonstrates a data analytics workflow combining Python, SQL, and Power BI to investigate insurance claim patterns, financial exceptions, customer characteristics, and fraud-labelled records. It provides an interactive reporting solution and documents important limitations in interpreting the dataset.



\## Author



\*\*Adeeksha Shettigar\*\*



Data Analytics Project | Python | SQL | Power BI



