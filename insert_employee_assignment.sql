/* 
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-15
 * $Description:  Create MORS employee assignment table from BTRS	
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-15 jes - initial creation
 * 2013-01-31 jes - Add selection to ignore assignments before 2011/11/01
 * 2013-02-08 jes - Change ignore date to 2011/10
 * =======================================================================================
 */

USE XYZBTRS_SQL

INSERT INTO [mors_employee_assignment] 
SELECT
	 Z.employee_id AS [employee_id]
  ,Z.ApplicantID AS [BTRS_employee_number]
	,Z.MCID AS [contract_id]
	,1 AS [status]
	,Z.Asgn_Start_Date AS [start_date]
	,Z.Asgn_End_Date AS [end_date]
	,GETDATE() AS [date_created]
	,GETDATE()  AS [date_updated]
	,0 AS [created_by_user_id]
	,0 AS [updated_by_user_id]
  FROM (SELECT DISTINCT employee_id, ApplicantID, MCJ.id as MCID, Asgn_Start_Date, Asgn_End_Date 
		FROM tblAssignments A
		JOIN [mors_employee_xref] MEX ON A.ApplicantID = MEX.BTRS_employee_number
		JOIN [mors_contract_job] MCJ ON A.PONumber = MCJ.BTRS_pos_number
      AND A.JobId = MCJ.job_number
      WHERE CAST([Asgn_Start_Date] AS datetime) >= '2011-10-01'
		) Z

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_employee_assignments]'  
DECLARE @tmp INT = (SELECT count(*) FROM tblAssignments )
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' rows in tblAssignments table'
