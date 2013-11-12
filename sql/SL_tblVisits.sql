/* ShortCut list of tblVisits */
USE XYZBTRS_SQL
SELECT [VisitID]
,[ClientID],convert(varchar(10),[Work_Date],111) WorkDate ,[Work_Day] ,convert(varchar(8),[Start_Time],108) StartTime ,convert(varchar(8),[End_Time],108) 'EndTime' ,[xxxApplicant_Name] ,[WorkerID]
,[Pay_Hours] ,[PONumber] ,[Description] ,[Type] ,[Category] ,[Work_Month] ,[JobId] ,convert(varchar(10),[Progress_Date],111) 'ProgDate'
FROM [XYZBTRS_SQL].[dbo].[tblVisits]

--where xxxapplicant_name like '%/%'