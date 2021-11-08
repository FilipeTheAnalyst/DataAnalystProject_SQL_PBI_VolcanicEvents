WITH CTE_VolcanoEvents as
(SELECT 
	   [Year]
      ,[Month]
      ,[Day]
      ,[Name]
      ,[Location]
      ,[Country]
      ,[Latitude]
      ,[Longitude]
      ,[Elevation (m)]
      ,Case
			When Type like '%volcanoes' THEN REPLACE(Type, 'volcanoes', 'volcano')
			ELSE Type
		END AS Type
      ,[VEI] as 'Volcanic Explosivity Index (VEI)'
	  ,Case
			When VEI = 0 THEN 'Gentle'
			When VEI = 1 THEN 'Effusive'
			When VEI = 2 THEN 'Explosive'
			When VEI = 3 THEN 'Catastrophic'
			When VEI = 4 THEN 'Cataclysmic'
			When VEI = 5 THEN 'Paroxysmic'
			When VEI = 6 THEN 'Colossal'
			When VEI = 7 THEN 'Super-colossal'
			ELSE 'Unknown'
		END AS 'Volcanic Explosivity Index (VEI) Description' -- VEI description for visualization purposes
      ,[Agent] AS 'Agent Fatalities Code'
	  ,Case
			When LEN(Agent) - LEN(REPLACE(Agent, ',', '')) = 0 THEN Agent
			ELSE LEFT(Agent, CHARINDEX(',', Agent) - 1)
		END AS 'Agent 1' --Split to isolate first Agent type from Agent column
		,Case
			When LEN(Agent) - LEN(REPLACE(Agent, ',', '')) = 1 THEN RIGHT(Agent, CHARINDEX(',', Agent) - 1)
			When LEN(Agent) - LEN(REPLACE(Agent, ',', '')) >= 2 THEN SUBSTRING(Agent, CHARINDEX(',', Agent) + 1, CHARINDEX(',', Agent, CHARINDEX(',', Agent) + 1) - CHARINDEX(',', Agent) - 1)
			ELSE NULL
		END AS 'Agent 2' --Split to isolate second Agent type from Agent column
		,Case
			When LEN(Agent) - LEN(REPLACE(Agent, ',', '')) = 2 THEN RIGHT(Agent, CHARINDEX(',', Agent) - 1)
			When LEN(Agent) - LEN(REPLACE(Agent, ',', '')) >= 3 THEN SUBSTRING(Agent, CHARINDEX(',', Agent) +  CHARINDEX(',', Agent) + 1, CHARINDEX(',', Agent, CHARINDEX(',', Agent) + 1) - CHARINDEX(',', Agent) - 1)
			ELSE NULL
		END AS 'Agent 3' --Split to isolate third Agent type from Agent column
		,Case
			When LEN(Agent) - LEN(REPLACE(Agent, ',', '')) = 3 THEN RIGHT(Agent, CHARINDEX(',', Agent) - 1)
			ELSE NULL
		END AS 'Agent 4' --Split to isolate fourth Agent type from Agent column
      ,[Deaths]
	  ,[Death Description]
      ,Case
			When [Death Description] = 0 THEN '0'
			When [Death Description] = 1 THEN '1-50'
			When [Death Description] = 2 THEN '51-100'
			When [Death Description] = 3 THEN '101-1000'
			When [Death Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Number of Deaths from Eruption' --Number of Deaths from Eruption categorized for visualization purposes
      ,[Missing]
      ,[Missing Description]
	  ,Case
			When [Missing Description] = 0 THEN '0'
			When [Missing Description] = 1 THEN '1-50'
			When [Missing Description] = 2 THEN '51-100'
			When [Missing Description] = 3 THEN '101-1000'
			When [Missing Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Number of Missings from Eruption' --Number of Missings from Eruption categorized for visualization purposes
      ,[Injuries]
      ,[Injuries Description]
	  ,Case
			When [Injuries Description] = 0 THEN '0'
			When [Injuries Description] = 1 THEN '1-50'
			When [Injuries Description] = 2 THEN '51-100'
			When [Injuries Description] = 3 THEN '101-1000'
			When [Injuries Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Number of Injuries from Eruption' --Number of Injuries from Eruption categorized for visualization purposes
      ,[Damage ($Mil)]
      ,[Damage Description]
	  ,Case
			When [Damage Description] = 0 THEN '0'
			When [Damage Description] = 1 THEN 'Less than $1 million'
			When [Damage Description] = 2 THEN '$1 to $5 million'
			When [Damage Description] = 3 THEN '$5 to $25 million'
			When [Damage Description] = 4 THEN '$25 million or more'
			ELSE 'Unknown'
		END AS 'Damage ($Mil) from Eruption' --Number of Damage ($Mil) from Eruption categorized for visualization purposes
      ,[Houses Destroyed]
      ,[Houses Destroyed Description]
	  ,Case
			When [Houses Destroyed Description] = 0 THEN '0'
			When [Houses Destroyed Description] = 1 THEN '1-50'
			When [Houses Destroyed Description] = 2 THEN '51-100'
			When [Houses Destroyed Description] = 3 THEN '101-1000'
			When [Houses Destroyed Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Number of Houses Destroyed from Eruption' --Number of Houses Destroyed from Eruption categorized for visualization purposes
      ,[Total Deaths]
      ,[Total Death Description]
	  ,Case
			When [Total Death Description] = 0 THEN '0'
			When [Total Death Description] = 1 THEN '1-50'
			When [Total Death Description] = 2 THEN '51-100'
			When [Total Death Description] = 3 THEN '101-1000'
			When [Total Death Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Total Number of Deaths' --Total Number of Deaths categorized for visualization purposes
      ,[Total Missing]
      ,[Total Missing Description]
	  ,Case
			When [Total Missing Description] = 0 THEN '0'
			When [Total Missing Description] = 1 THEN '1-50'
			When [Total Missing Description] = 2 THEN '51-100'
			When [Total Missing Description] = 3 THEN '101-1000'
			When [Total Missing Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Total Number of Missings' --Total Number of Missings categorized for visualization purposes
      ,[Total Injuries]
      ,[Total Injuries Description]
	  ,Case
			When [Total Injuries Description] = 0 THEN '0'
			When [Total Injuries Description] = 1 THEN '1-50'
			When [Total Injuries Description] = 2 THEN '51-100'
			When [Total Injuries Description] = 3 THEN '101-1000'
			When [Total Injuries Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Total Number of Injuries' --Total Number of Injuries categorized for visualization purposes
      ,[Total Damage ($Mil)]
      ,[Total Damage Description]
	  ,Case
			When [Total Damage Description] = 0 THEN '0'
			When [Total Damage Description] = 1 THEN 'Less than $1 million'
			When [Total Damage Description] = 2 THEN '$1 to $5 million'
			When [Total Damage Description] = 3 THEN '$5 to $25 million'
			When [Total Damage Description] = 4 THEN '$25 million or more'
			ELSE 'Unknown'
		END AS 'Total Damage ($Mil) Categories' --Total Damage ($Mil) categorized for visualization purposes
      ,[Total Houses Destroyed]
      ,[Total Houses Destroyed Description]
	  ,Case
			When [Total Houses Destroyed Description] = 0 THEN '0'
			When [Total Houses Destroyed Description] = 1 THEN '1-50'
			When [Total Houses Destroyed Description] = 2 THEN '51-100'
			When [Total Houses Destroyed Description] = 3 THEN '101-1000'
			When [Total Houses Destroyed Description] = 4 THEN 'Over 1000'
			ELSE 'Unknown'
		END AS 'Total Number of Houses Destroyed' --Total Number of Houses Destroyed categorized for visualization purposes
  FROM [VolcanoProject].[dbo].[VolcanoEvents]
)
SELECT *
		,Case
			When [Agent 1] = 'A' THEN 'Avalanche'
			When [Agent 1] = 'E' THEN 'Electrical'
			When [Agent 1] = 'F' THEN 'Floods'
			When [Agent 1] = 'G' THEN 'Gas'
			When [Agent 1] = 'I' THEN 'Indirect Deaths'
			When [Agent 1] = 'L' THEN 'Lava Flows'
			When [Agent 1] = 'M' THEN 'Mudflows/Lahars'
			When [Agent 1] = 'm' THEN 'Secondary Mudflows'
			When [Agent 1] = 'P' THEN 'Pyroclastic Flows'
			When [Agent 1] = 'S' THEN 'Seismic/Volcanic Earthquake'
			When [Agent 1] = 'T' THEN 'Tephra'
			When [Agent 1] = 'W' THEN 'Waves/Tsunami'
			ELSE 'Unknown'
		END AS 'Agent Fatality 1' --Agent that caused Fatalities categorized for visualization purposes
		,Case
			When [Agent 2] = 'A' THEN 'Avalanche'
			When [Agent 2] = 'E' THEN 'Electrical'
			When [Agent 2] = 'F' THEN 'Floods'
			When [Agent 2] = 'G' THEN 'Gas'
			When [Agent 2] = 'I' THEN 'Indirect Deaths'
			When [Agent 2] = 'L' THEN 'Lava Flows'
			When [Agent 2] = 'M' THEN 'Mudflows/Lahars'
			When [Agent 2] = 'm' THEN 'Secondary Mudflows'
			When [Agent 2] = 'P' THEN 'Pyroclastic Flows'
			When [Agent 2] = 'S' THEN 'Seismic/Volcanic Earthquake'
			When [Agent 2] = 'T' THEN 'Tephra'
			When [Agent 2] = 'W' THEN 'Waves/Tsunami'
			ELSE NULL
		END AS 'Agent Fatality 2' --Agent that caused Fatalities categorized for visualization purposes
		,Case
			When [Agent 3] = 'A' THEN 'Avalanche'
			When [Agent 3] = 'E' THEN 'Electrical'
			When [Agent 3] = 'F' THEN 'Floods'
			When [Agent 3] = 'G' THEN 'Gas'
			When [Agent 3] = 'I' THEN 'Indirect Deaths'
			When [Agent 3] = 'L' THEN 'Lava Flows'
			When [Agent 3] = 'M' THEN 'Mudflows/Lahars'
			When [Agent 3] = 'm' THEN 'Secondary Mudflows'
			When [Agent 3] = 'P' THEN 'Pyroclastic Flows'
			When [Agent 3] = 'S' THEN 'Seismic/Volcanic Earthquake'
			When [Agent 3] = 'T' THEN 'Tephra'
			When [Agent 3] = 'W' THEN 'Waves/Tsunami'
			ELSE NULL
		END AS 'Agent Fatality 3' --Agent that caused Fatalities categorized for visualization purposes
		,Case
			When [Agent 4] = 'A' THEN 'Avalanche'
			When [Agent 4] = 'E' THEN 'Electrical'
			When [Agent 4] = 'F' THEN 'Floods'
			When [Agent 4] = 'G' THEN 'Gas'
			When [Agent 4] = 'I' THEN 'Indirect Deaths'
			When [Agent 4] = 'L' THEN 'Lava Flows'
			When [Agent 4] = 'M' THEN 'Mudflows/Lahars'
			When [Agent 4] = 'm' THEN 'Secondary Mudflows'
			When [Agent 4] = 'P' THEN 'Pyroclastic Flows'
			When [Agent 4] = 'S' THEN 'Seismic/Volcanic Earthquake'
			When [Agent 4] = 'T' THEN 'Tephra'
			When [Agent 4] = 'W' THEN 'Waves/Tsunami'
			ELSE NULL
		END AS 'Agent Fatality 4' --Agent that caused Fatalities categorized for visualization purposes
FROM CTE_VolcanoEvents;
