--Delete First Row with NULL Values
DELETE
FROM VolcanoProject.dbo.Volcanoes
WHERE Number is NULL and Country is NULL;

--Standardize Status values
Update VolcanoProject.dbo.Volcanoes
SET Status = REPLACE(Status, '?', '')
;

--Standardize Status values
Update VolcanoProject.dbo.Volcanoes
SET Status = ISNULL(Status, 'Unknown')
;

--Standardize Status values
Update VolcanoProject.dbo.Volcanoes
SET Status = REPLACE(Status, 'Unknown', 'Uncertain')
;

--Standardize Last Known Eruption values
Update VolcanoProject.dbo.Volcanoes
SET [Last Known Eruption] = 
	(Case 
		When [Last Known Eruption] IN ('?', 'Unknown', 'P') THEN 'U'
		When [Last Known Eruption] like 'U%' THEN 'U'
		ELSE [Last Known Eruption]
	END)
;

--Categorize Last Known Eruption Code into Periods for better visualization
SELECT *
,Case
	When [Last Known Eruption] = 'D1' THEN '1964 or later'
	When [Last Known Eruption] = 'D2' THEN '1900-1963'
	When [Last Known Eruption] = 'D3' THEN '1800-1899'
	When [Last Known Eruption] = 'D4' THEN '1700-1799'
	When [Last Known Eruption] = 'D5' THEN '1500-1699'
	When [Last Known Eruption] = 'D6' THEN 'A.D. 1-1499'
	When [Last Known Eruption] = 'D7' THEN 'B.C. (Holocene)'
	When [Last Known Eruption] = 'Q' THEN 'Quaternary eruption'
	ELSE 'Unknown'
	END AS [Last Known Eruption Period]
FROM VolcanoProject.dbo.Volcanoes;
