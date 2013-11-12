/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-15
 * $Description:	Populate MORS table from BTRS
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-16 - Needs work; time_header incomplete
 *            Must be tied to job number
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-15 jes - initial creation
 * 2013-01-02 jes - Updates for POSContracts PONumber and Pay-Hours <> 0
 * 2013-01-27 jes - Add tblVisits ID
 * 2013-01-31 jes - Add JobID
 * =======================================================================================
 */

USE XYZBTRS_SQL

INSERT INTO [mors_time_entry] 
SELECT
	[time_header_id]
	,0 AS [status]
	,'' AS [status_reason_code]
	,TL.visit_date AS [date_of_service]
	,CASE WHEN TL.visit_start_time IS NOT NULL THEN TL.visit_start_time ELSE '0:00' end AS [start_time]
    ,CASE WHEN TL.visit_end_time IS NOT NULL THEN TL.visit_end_time ELSE '0:00' end AS [end_time]
	,TL.pay_hours AS [hours]
	,0 AS [miles]
	,0 AS [reviewed_by_id]
	,NULL AS [reviewed_date]
	,0 AS [approved_by_id]
	,NULL AS [approved_date]
	,TL.progress_date AS [date_paid]
	,NULL AS [date_invoiced]
	,NULL AS [invoice_number]
	,NULL AS [remitted_by_customer]
	,NULL AS [customer_remittance_number]
	,NULL AS [denied_by_customer]
	,GETDATE() AS [date_created]
	,0 AS [created_by_user_id]
	,GETDATE() AS [date_updated]
	,0 AS [updated_by_user_id]
  ,TL.VisitID AS [BTRS_visit_id]
  ,TL.JobID AS [job_number]
  FROM vw_btrs_timesheet_lines TL

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_time_entry]'
DECLARE @tmp INT = (SELECT count(*) 
        FROM (SELECT DISTINCT PC.PONumber, V.Progress_Date, REPLACE(V.xxxApplicant_Name,'"','') as appl_name, V.Work_Date 
          FROM tblVisits V
          JOIN tblPOSContracts AS PC ON PC.JobId = V.JobID
              WHERE PC.PONumber IS NOT NULL
                AND V.Pay_Hours <> 0
      ) Z )
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' candidate rows in tblVisits'
