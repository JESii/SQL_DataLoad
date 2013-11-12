/* 
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-14
 * $Description:	Create MORS time_header table from BTRS tblVisits
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-16 - This is a "Timesheet" header, not an employee or job header
 *            Must use the ProgressDate in tblVisits to creat this
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-14 jes	- initial creation
 *	NOTE			- We get the employee_id by matching against name in the employee table
 * 2013-02-06 jes - insert client id into table (vw_btrs_timesheets update also)
 *=======================================================================================
 */

USE XYZBTRS_SQL

DELETE [mors_time_header]

INSERT INTO [mors_time_header] 
SELECT
	Z.MEID AS [employee_id]
  ,Z.employee_number AS [BTRS_employee_number]
	,Z.MPID AS [contract_id]
  ,Z.MCID AS [client_id]
  ,Z.pos_Number AS [BTRS_pos_number]
  ,Z.progress_date AS [BTRS_progress_date]
	,GETDATE() AS [date_created]
	,GETDATE() AS [date_updated]
	,0 AS [created_by_user_id]
	,0 AS [updated_by_user_id]
  FROM (SELECT progress_date as progress_date, pos_number, employee_id AS MEID, 
          employee_number, contract_id AS MPID, client_id as MCID 
        FROM vw_btrs_timesheets BT
        ) Z

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_time_header]'
DECLARE @tmp INT = (SELECT COUNT(*) FROM (
      SELECT DISTINCT PC.PONumber, V.Progress_Date, REPLACE(V.xxxApplicant_Name,'"','') AS appl_name 
        FROM tblVisits V 
        JOIN tblPOSContracts AS PC ON PC.JobID = V.JobID
          WHERE PC.PONumber IS NOT NULL) Z )
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' candidate rows in tblVisits'
