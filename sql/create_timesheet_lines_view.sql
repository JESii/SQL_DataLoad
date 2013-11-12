USE [XYZBTRS_SQL]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP VIEW [dbo].[vw_btrs_timesheet_lines]
GO
/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date:	2012-12-18
 * $Description:	View to unique 'timesheet line item' information from BTRS
 * 				Uses the the tblVisits table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * **	Items in tblVisits with NULL POS Number are excluded!
 * ** Identifying 'duplicate' visits is very tricky:
 *    1. There are some items that have been reversed with a negative value
 *    2. Sometimes both duplicates are reversed 
 *    3. And sometimes there's a swap from one POS to another
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-18 jes	- initial creation
 * 2012-12-18 jes	- Correct xxxApplicant_Name and add contract & employee Foreign Keys
 * 2013-01-01 jes - Add VisitID for selecting unmatched items
 * 2013-01-02 jes - Remove DISTINCT; need all items, even if duplicates
 *                - Use POSContracts for POS# for better matching
 * 2013-01-13 jes - Use BTRS_match_name for matching data
 * 2013-01-31 jes - Add JobID for later insertion into mors_time_entry
 * =======================================================================================
 */
CREATE VIEW [dbo].[vw_btrs_timesheet_lines]
AS
SELECT V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date, PC.PONumber AS pos_number, V.ClientID AS client_number, MEX.employee_id
	,MEX.BTRS_full_name AS appl_full_name, MC.id as contract_id, MTH.id as time_header_id
	,CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time
	,V.pay_hours, PC.JobID
	FROM  dbo.tblVisits AS V 
  JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
			AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)
GO
