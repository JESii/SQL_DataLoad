/*
 * Various tests for tblPOSHrs
 */
SELECT  [job_id]
      ,[PO_Number]
      ,[Hours_Allotted]
  FROM [MHCBTRS_SQL].[dbo].[ttmpJob_Allotted_Hours]
  
SELECT [ID],[ClientId],[xxxClient_Name],[JobId],[Hours_Used],[Hours_Bal_Fwd],[Hours_Current],
	[Hours_Allotted],[Balance],[PONumber],[Progress_Date]
  FROM [MHCBTRS_SQL].[dbo].[tblPOSHrs]
  where Hours_Allotted = 0 or Hours_Allotted is null  