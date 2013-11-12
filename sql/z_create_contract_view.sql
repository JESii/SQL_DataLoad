No Longer Used
/* =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-16
 * $Description:	View to access contract (POS Number) information from BTRS
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
				is specified for more than one client. 
 * This is the raw data INCLUDING duplicates
 * See vw_btrs_contracts_{duplicates/uniques} for more selective results
 * NOTE!!! We use the POSContracts_Import table as it has more data than the BTRS version
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-16 jes	- initial creation
 * 2012-12-18 jes	- Added additional fields in case needed
 * 2013-01-31 jes - Remove reference to unused table
 * =======================================================================================
 */
USE [XYZBTRS_SQL]

ALTER VIEW [dbo].[vw_btrs_contracts]
AS
SELECT DISTINCT PO_Number AS pos_number, Client# AS client_number, 
		MAX(Dept) AS pos_dept, MAX(Category) AS pos_category, MAX(Type) AS pos_type,
		MAX(POS_Start_Date) as pos_start_date, MAX(POS_End_Date) as pos_end_date,
		MAX(REPLACE(Client_Name,'"','')) as client_name, MAX(contact) as contact_name, 
		MAX(contact_phone) as contact_phone, MAX(bill_rate) as bill_rate, MAX(pay_rate) as pay_rate
FROM         dbo.XYZ_POSContracts_Import
WHERE     (PO_Number IS NOT NULL) AND (Client# IS NOT NULL) 
GROUP BY PO_Number, Client#
