
--Cleaning Data 

--The purpose of this step is to transform the original table displaying the major sector, the sector number as lookup code
-- and the sector description as indvidual columns. 

SELECT *
INTO SBA_NAICS_sector_codes
FROM(
	SELECT 
		  [NAICS Industry Description],
		   IIF([NAICS Industry Description] LIKE '%–%', SUBSTRING([NAICS Industry Description], 8, 2), '') AS LOOKUP_CODES,
		   IIF([NAICS Industry Description] LIKE '%–%', LTRIM(SUBSTRING([NAICS Industry Description], CHARINDEX('–', [NAICS Industry Description]) +1 , LEN([NAICS Industry Description]))), '') SECTOR
	   
	  FROM [PortfolioDB].[dbo].[sba_industry_standards]
	  WHERE [NAICS Codes] = ''
) MAIN
WHERE  
	LOOKUP_CODES != ''


SELECT TOP (1000) [NAICS Industry Description]
      ,[LOOKUP_CODES]
      ,[SECTOR]
  FROM [PortfolioDB].[dbo].[SBA_NAICS_sector_codes]
  ORDER BY LOOKUP_CODES

	INSERT INTO [dbo].[SBA_NAICS_sector_codes]
  VALUES
	('Sector 31 – 33 – Manufacturing', 32, 'Manufacturing'),
	('Sector 31 – 33 – Manufacturing', 33, 'Manufacturing'),
	('Sector 44 - 45 – Retail Trade', 45, 'Retail Trade'),
	('Sector 48 - 49 – Transportation and Warehousing', 49, 'Transportation and Warehousing')
	
	UPDATE [dbo].[SBA_NAICS_sector_codes]
	SET SECTOR = 'Manufacturing'
	WHERE LOOKUP_CODES = 31