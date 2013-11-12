/* 
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-14
 * $Description:	Create MORS Employee table from BTRS data view
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-14 jes	- initial creation
 *	NOTE			- added [middle_name] field for name/id matching
 * 2013-01-13 jes - add BTRS_match_name
 * 2013-01-31 jes - Remove reference to unused table
 * =======================================================================================
 */
USE XYZBTRS_SQL

DELETE [mors_employee]

INSERT INTO [mors_employee] 
SELECT
	1 AS [status]
	,appl_number AS [employee_number]
	,'' AS [title]
	,Appl_First_Name AS [first_name]
	,Appl_Middle_Name AS [BTRS_middle_name]
	,Appl_Last_Name AS [last_name]
  ,[BTRS_full_name]
  ,dbo.fn_collapse_name([BTRS_full_name]) AS [BTRS_match_name]
	,'' AS [company]
	,'' AS [email_address]
	,'' AS [address]
	,'' AS [address2]
	,'' AS [city]
	,'' AS [state]
	,'' AS [zip]
	,'' AS [country]
	,'' AS [day_phone]
	,'' AS [home_phone]
	,'' AS [fax]
	,'' AS [notes]
	,GETDATE() AS [date_created]
	,GETDATE() AS [date_updated]
	,0 AS [created_by_user_id]
	,0 AS [updated_by_user_id]
	FROM vw_btrs_workers

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_employee]'


