/*
 * * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-17
 * $Description:	Script to test results of various table creations
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-17 	- Add more tests as needed
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-17 jes	- initial creation
 * 2013-02-09 jes - Updates for better counts/comparisons
 * =======================================================================================
 */
USE XYZBTRS_SQL
SET NOCOUNT ON
DECLARE @cnt1 int
DECLARE @cnt2 int
DECLARE @cnt3 int
DECLARE @cnt4 int
PRINT CHAR(10) + '==> Testing POS contract tables/counts'

SET @cnt1 = (select COUNT(*) from vw_btrs_contracts_uniques)
SET @cnt2 = (select COUNT(*) from mors_contract)
SET @cnt3 = (select COUNT(*) from vw_btrs_contracts)
PRINT '==> unique btrs_contracts: ' + CONVERT(varchar(10), @cnt1) + CHAR(10)
	+ '    mors_contracts:        ' + CONVERT(varchar(10), @cnt2) + CHAR(10)
	+ '    ALL btrs_contracts:    ' + CONVERT(varchar(10), @cnt3)
IF @cnt1 <> @cnt2
BEGIN
PRINT '==> ERROR creating contracts; counts are different!!!'
/*
	SELECT MC.* FROM mors_contract MC
		LEFT JOIN vw_btrs_contracts_uniques BCU ON MC.pos_authorization_number = BCU.pos_number
		WHERE BCU.pos_number IS NULL
*/
END

PRINT CHAR(10) + '==> Testing job info; all three counts must be the same'
DECLARE @table TABLE (val1 varchar(20), val2 varchar(20))

SET @cnt1 = (select COUNT(*) from vw_btrs_jobs )
INSERT @table
	SELECT DISTINCT job_number, POS_number FROM vw_btrs_jobs
SET @cnt2 = (select count(*) from @table)
DELETE @table
INSERT @table
	SELECT DISTINCT job_number, client_number FROM vw_btrs_jobs
SET @cnt3 = (select count(*) from @table)

PRINT '==> vw_btrs_jobs: ' + convert(varchar(10),@cnt1) + CHAR(10)
	+ '    job# vs pos#: ' + convert(varchar(10),@cnt2) + CHAR(10)
	+ '    job# vs Cln#: ' + convert(varchar(10),@cnt3)
IF @cnt1 <> @cnt2 OR @cnt1 <> @cnt3 OR @cnt1 <> @cnt3
BEGIN
  PRINT '==> ERROR Job counts are different!!!'
END  
PRINT CHAR(10) + '==> Testing employee/worker info; all three counts must be the same'
SET @cnt1 = (select COUNT(*) from vw_btrs_workers)
SET @cnt2 = (select COUNT(*) from mors_employee)
SET @cnt3 = (select COUNT(*) from vw_btrs_workers W
	join mors_employee E on E.employee_number = W.appl_number)
	
PRINT '==> Count 1: ' + convert(varchar(10),@cnt1) + CHAR(10)
	+ '    Count 2: ' + convert(varchar(10),@cnt2) + CHAR(10)
	+ '    Count 3: ' + convert(varchar(10),@cnt3)

PRINT CHAR(10) + '==> Testing timesheet data'
SET @cnt1 = (SELECT COUNT(*) FROM vw_btrs_timesheets)
SET @cnt2 = (SELECT COUNT(*) from mors_time_header)
PRINT '==> vw_btrs_timesheets: ' + convert(varchar(10),@cnt1) + CHAR(10)
	+ '    mors_time_header:   ' + convert(varchar(10),@cnt2) + CHAR(10)
--	+ '    Distinct Client#:   ' + convert(varchar(10),@cnt3)
IF @cnt1 <> @cnt2
BEGIN
	PRINT '==> ERROR: Invalid time_header counts'
END

PRINT CHAR(10) + '==> Testing timesheet/lines counts'
SET @cnt1 = (SELECT COUNT(*) FROM vw_btrs_timesheet_lines)
SET @cnt2 = (SELECT COUNT(*) FROM tblVisits
				WHERE PONumber IS NOT NULL AND JOBID IS NOT NULL AND PONUMBER IS NOT NULL
          AND Pay_Hours <> 0.0)
SET @cnt3 = (SELECT COUNT(*) FROM mors_time_entry)
SET @cnt4 = (SELECT COUNT(*) FROM (SELECT BTRS_Visit_id, COUNT(*) as [counter] FROM mors_time_entry
  GROUP BY BTRS_Visit_id
  HAVING COUNT(*) > 1) Z)
PRINT '==> vw_btrs_timesheet_lines:  ' + SQL#.String_PadLeft(@cnt1,8,' ') + CHAR(10)
	+ '    tblVisits (Candidates):     ' + SQL#.String_PadLeft(@cnt2,8,' ') + CHAR(10)
  + '       (i.e., PO# NOT NULL, JOB# NOT NULL, Pay_Hours <> 0.0) ' + CHAR(10)
	+ '    mors_time_entry:          ' + SQL#.String_PadLeft(@cnt3,8,' ') + CHAR(10)
  + '    MTE duplicated Visit_IDs  ' + SQL#.String_PadLeft(@cnt4,8,' ')
  
IF @cnt1 <> @cnt2 OR @cnt2 <> @cnt3 OR @cnt4 <> 0
BEGIN
	PRINT '==> ERROR: Unmatched time_entry counts and/or MTE duplicated Visit_IDs !'
END
