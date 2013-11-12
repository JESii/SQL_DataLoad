/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date:  2012-12-13 
 * $Description:	Create & link contract_job table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2013-01-02 jes - POSHrs has fewer items than does POSContracts!!!
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-15 jes - Updates to link contract/contract_job
 * 2013-01-02 jes - Update to select first from tblPOSContracts (more data than POSHrs)
 *                and then update from ttmpVisits_Rates
 * 2013-01-18 jes - Update to add start/end dates & allotted hours
 * =======================================================================================
 */

USE XYZBTRS_SQL

DELETE [mors_contract_job] 

INSERT INTO [mors_contract_job] 
SELECT
	 Z.MCID AS [contract_id]
	,Z.JobId AS [job_number]
  ,Z.PONumber AS [BTRS_job_number]
	,CASE WHEN Z.[Work_Month] IS NOT NULL THEN Z.Work_Month ELSE 0 END AS [month]
	,0 AS [year]
	,CASE WHEN Z.POS_Start_Date IS NULL THEN '1900-01-01' ELSE CONVERT(varchar(10),Z.POS_Start_Date,111)END AS [start_date]
	,CASE WHEN Z.POS_End_Date IS NULL THEN '1900-01-01' ELSE  CONVERT(varchar(10),Z.POS_End_Date,111) END AS [end_date]
	,0 AS [authorized_units]
	,GETDATE() AS [date_created]
	,GETDATE() AS [date_updated]
	,0 AS [created_by_user_id]
	,0 AS [updated_by_user_id]
	FROM (SELECT DISTINCT MC.id as MCID, JobId, PONumber, Work_Month, Hours_Allotted,POS_Start_Date,POS_End_Date
      FROM tblPOSContracts AS P
	    JOIN [mors_contract] AS MC ON P.PONumber = MC.pos_authorization_number
    ) Z

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_contract_job]'
DECLARE @tmp INT  = (SELECT count(*) FROM tblPOSContracts )
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' rows in tblPOSContracts table'

UPDATE mors_contract_job
	SET authorized_units = PH.Hours_Allotted
	FROM tblPOSHrs PH
	JOIN mors_contract_job MCJ on PH.JobId = MCJ.job_number

SET @tmp = (select COUNT(*) from mors_contract_job
	where authorized_units = 0)
PRINT '==> ' + CAST(@tmp AS varchar(8)) + ' contract_job records with missing authorized units'	
SET @tmp = (select count(*) from mors_contract_job
	where start_date like '1900%' or end_date like '1900%')
PRINT '==> ' + CAST(@tmp AS varchar(8)) + ' contract_job records with missing Start/End dates'	
  
