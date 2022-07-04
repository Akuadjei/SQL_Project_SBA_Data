
--Question 1
---What is the summary of all PPP Approved Lending? (there is also servicing Lender)
SELECT COUNT(LoanNumber) AS Loans_Approved, SUM(InitialApprovalAmount) AS Total_Net_Dollars, 
		AVG(InitialApprovalAmount) AS Average_Loan_Size, 
	(SELECT COUNT(DISTINCT (OriginatingLender))
	 FROM[dbo].[sba_public_data])Total_Originating_Lender_Count
 FROM [dbo].[sba_public_data]
ORDER BY 3 DESC


---What is the summary of 2021 PPP Approved Lending?
SELECT COUNT(LoanNumber) AS Loans_Approved, SUM(InitialApprovalAmount) AS Total_Net_Dollars, 
	   AVG(InitialApprovalAmount) AS Average_Loan_Size, 
(SELECT COUNT(DISTINCT (OriginatingLender))
 FROM [dbo].[sba_public_data] 
 WHERE YEAR(DateApproved) = 2021) AS Total_Originating_Lender_Count
FROM [dbo].[sba_public_data]
WHERE YEAR(DateApproved) = 2021
ORDER BY 3 DESC


---What is the summary of 2020 PPP Approved Lending?
SELECT COUNT(LoanNumber) AS Loans_Approved, SUM(InitialApprovalAmount) AS Total_Net_Dollars, 
		AVG(InitialApprovalAmount) AS Average_Loan_Size, 
(SELECT COUNT(DISTINCT (OriginatingLender))
FROM [dbo].[sba_public_data] 
WHERE YEAR(DateApproved) = 2020) AS Total_Originating_Lender_Count
FROM [dbo].[sba_public_data]
WHERE YEAR(DateApproved) = 2020
ORDER BY 3 DESC


--Question 2
---The Summary of 2021 PPP Approved Loans per Originating Lender, loan count, total amount and average
--What is Top 15 Originating Lenders for 2021 PPP Loans?
--Data is ordered by Net_Dollars
SELECT TOP 15 OriginatingLender, COUNT(LoanNumber) AS Loans_Approved, SUM(InitialApprovalAmount) AS Net_Dollars, AVG(InitialApprovalAmount) Average_Loan_Size
FROM [dbo].[sba_public_data]
WHERE year(DateApproved) = 2021
GROUP BY OriginatingLender
ORDER BY 3 DESC

SELECT TOP 15 OriginatingLender, COUNT(LoanNumber) AS Loans_Approved, SUM(InitialApprovalAmount) AS Net_Dollars, AVG(InitialApprovalAmount) Average_Loan_Size
FROM [dbo].[sba_public_data]
WHERE year(DateApproved) = 2020
GROUP BY OriginatingLender
ORDER BY 3 DESC



--Question 3
---What is Top 20 Industries that received the PPP Loans in 2021?
-- To add the NAICS codes to the GitHub Repo, extracted from SQL
WITH CTE AS (

	SELECT ncd.Sector, COUNT(LoanNumber) AS Loans_Approved, SUM(CurrentApprovalAmount) AS Net_Dollars
	FROM [dbo].[sba_public_data] main
	INNER JOIN [dbo].[sba_naics_sector_codes_description] AS ncd
		ON LEFT(CAST(main.NAICSCode AS VARCHAR), 2) = ncd.LookupCode
	WHERE YEAR(DateApproved) = 2021 
	GROUP BY ncd.Sector
	--ORDER BY 3 DESC

)
SELECT 
	sector,Loans_Approved,
	SUM(Net_Dollars) OVER(PARTITION BY sector) AS Net_Dollars,
	--SUM(Net_Dollars) OVER() AS Total,
	CAST(1. * Net_Dollars / SUM(Net_Dollars) OVER() AS DECIMAL(5,2)) * 100 AS "Percent by Amount"  
FROM CTE  
ORDER BY 3 DESC
--WHERE YEAR(DATEAPPROVED) = 2021 



--Question 4
--Displaying the States and Territories
SELECT BorrowerState AS STATE, COUNT(LoanNumber) AS Loan_Count, SUM(CurrentApprovalAmount) AS Net_Dollars
FROM [dbo].[sba_public_data] AS main
--where cast(DateApproved as date) < '2021-06-01'
GROUP BY BorrowerState
ORDER BY 1



--Question 5
---What are the demographics for PPP?
SELECT race, COUNT(LoanNumber) AS Loan_Count, SUM(CurrentApprovalAmount) AS Net_Dollars
FROM [dbo].[sba_public_data]
GROUP BY race
ORDER BY 3

SELECT gender, count(LoanNumber) AS Loan_Count, SUM(CurrentApprovalAmount) AS Net_Dollars
FROM [dbo].[sba_public_data]
GROUP BY gender
ORDER BY 3

SELECT Ethnicity, count(LoanNumber) AS Loan_Count, SUM(CurrentApprovalAmount) AS Net_Dollars
FROM [dbo].[sba_public_data]
GROUP BY Ethnicity
ORDER BY 3

SELECT Veteran, count(LoanNumber) AS Loan_Count, SUM(CurrentApprovalAmount) AS Net_Dollars
FROM [dbo].[sba_public_data]
GROUP BY Veteran
ORDER BY 3


--Question 6---
---How much of the PPP Loans of 2021 have been fully forgiven?
SELECT COUNT(LoanNumber) AS Count_of_Payments,  SUM(ForgivenessAmount)AS Forgiveness_amount_paid
FROM sba_public_data
WHERE year(DateApproved) = 2020 AND ForgivenessAmount <> 0

---Summary of 2021 PPP Approved Lending
SELECT COUNT(LoanNumber) AS Loans_Approved, SUM(InitialApprovalAmount)AS Total_Net_Dollars, SUM(ForgivenessAmount)AS Forgiveness_amount_paid,
(SELECT COUNT(DISTINCT (OriginatingLender))FROM [dbo].[sba_public_data] WHERE YEAR(DateApproved) = 2021) AS Total_Originating_Lender_Count
FROM [dbo].[sba_public_data]
WHERE YEAR(DateApproved) = 2020 
ORDER BY 3 DESC


--Question 7---
--In which month was the highest amount given out by the SBA to borrowers
SELECT YEAR(DateApproved) AS Year_Approved, MONTH(DateApproved) AS Month_Approved, ProcessingMethod, SUM(CurrentApprovalAmount) AS Net_Dollars
FROM sba_public_data
GROUP BY YEAR(DateApproved),  MONTH(DateApproved), ProcessingMethod
ORDER BY 4 DESC