/* 
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date:  2012-12-13 
 * $Description:	Populate MORS client table from BTRS tblClients
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-13 jes - initial creation
 * 2012-12-14 jes - Add BTRS_client_number column
 * NOTE           That [first_name] also contains the middle name as well
 * 2012-12-24 jes - <Argh!> There are some systemic name mis-matches to be handled:
 *                - Trailing single-letter initial
 *                - ...another
 *                - ...another
 *                - ...another
 *                - And with a trailing period
 *                - ...another
 *                - Missing comma after last name
 *                - Missing apostrophe in name
 *                - Wow!
 *                - Extra name in parens (no parens in R/C names)
 *                - Missing space in two-word last name
 *                "" vs ""
 *                - Two-word last name
 *                - No period after Jr.
 *                - Missing space after comma
 *                  + extra space in name
 *                - ...another variant
 *                - Doubled spaces in name
 *                - Names without these special formats were properly not matched:
 * Rules for handling:
 *  1. Replace commas/periods/dashes/apostrophes with spaces in both names
 *  2. Remove trailing single-letter initial in BTRS name
 *  3. Remove any parenthesized names in BTRS name
 *  98. Replace doubled spaces with single space in both names
 *  99. Remove any leading/trailing spaces in both names.
 * =======================================================================================
 */
USE XYZBTRS_SQL

DELETE [mors_client]

INSERT INTO [mors_client] 
SELECT
	1 AS [status]
	,0 AS [uci_number]
  ,CONVERT(varchar(20), ClientID) as BTRS_client_number
  ,[Client_Name] AS [BTRS_client_name]
	,'' AS [title]
	,dbo.fn_split_names(1, Client_Name) as [first_name]
  ,dbo.fn_split_names(2, Client_Name) as [middle_name]
  ,dbo.fn_split_names(3, Client_Name) as [last_name]
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
	FROM tblClients

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_client]'  
DECLARE @tmp int = (SELECT count(*) from tblClients)
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' rows in tblClients'
