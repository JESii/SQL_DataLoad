/* =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-16
 * $Description:	Create several views to access contract (POS Number) information from BTRS
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
 *			is specified for more than one client (dual-rate POS'). So we create one view
 *        with the raw data, one view with the duplicates, and one (using EXCEPT) with uniques
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-20 jes - Initial create script
 * 2013-01-31 jes - Remove reference to unused table
 * =======================================================================================
 */
USE [XYZBTRS_SQL]

DROP VIEW [dbo].[vw_btrs_contracts]
GO
/* =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-16
 * $Description:	View to access contract (POS Number) information from BTRS
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
 *			is specified for more than one client. 
 *		> This is the raw data INCLUDING duplicates
 *		> See vw_btrs_contracts_{duplicates/uniques} for more selective results
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-16 jes	- initial creation
 * 2012-12-18 jes	- Added additional fields in case needed
 * =======================================================================================
 */
CREATE VIEW [dbo].[vw_btrs_contracts]
AS
SELECT DISTINCT PC.PONumber AS pos_number, PC.ClientID AS client_number, 
		MAX(PC.Dept) AS pos_dept, MAX(PC.Category) AS pos_category, MAX(PC.Type) AS pos_type,
		MAX(PC.POS_Start_Date) as pos_start_date, MAX(PC.POS_End_Date) as pos_end_date,
		MAX(REPLACE(C.Client_Name,'"','')) as client_name, MAX(PCI.contact) as contact_name, 
		MAX(PCI.contact_phone) as contact_phone, MAX(PC.bill_rate) as bill_rate, MAX(PC.pay_rate) as pay_rate
FROM         dbo.tblPOSContracts PC
join dbo.tblClients C on C.ClientID = PC.ClientID
join dbo.XYZ_POSContracts_Import PCI on PCI.Client# = PC.ClientID
WHERE     (PC.PONumber IS NOT NULL) AND (PC.ClientID IS NOT NULL) 
GROUP BY PC.PONumber, PC.ClientID
/*** Replace 2013-02-09
SELECT DISTINCT PO_Number AS pos_number, Client# AS client_number, 
		MAX(Dept) AS pos_dept, MAX(Category) AS pos_category, MAX(Type) AS pos_type,
		MAX(POS_Start_Date) as pos_start_date, MAX(POS_End_Date) as pos_end_date,
		MAX(REPLACE(Client_Name,'"','')) as client_name, MAX(contact) as contact_name, 
		MAX(contact_phone) as contact_phone, MAX(bill_rate) as bill_rate, MAX(pay_rate) as pay_rate
FROM         dbo.XYZ_POSContracts_Import
WHERE     (PO_Number IS NOT NULL) AND (Client# IS NOT NULL) 
GROUP BY PO_Number, Client#
*/
GO

DROP VIEW [dbo].[vw_btrs_contracts_duplicates]
GO
/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date: 2012-12-16
 * $Description:	View to access unique worker information from BTRS
 *					Uses the vw_btrs_contracts view	
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
 *				is specified for more than one client. That's what's in this view
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-16 jes	- initial creation
 * =======================================================================================
 */

CREATE VIEW [dbo].[vw_btrs_contracts_duplicates]
	(pos_number, client_number, pos_dept, pos_category, pos_type,
	 pos_start_date, pos_end_date,
	 client_name, contact_name, contact_phone, bill_rate, pay_rate )
AS 
	SELECT * FROM vw_btrs_contracts
	WHERE pos_number IN (SELECT pos_number
		FROM vw_btrs_contracts
		GROUP BY pos_number
		HAVING COUNT(*) > 1)
GO

DROP VIEW [dbo].[vw_btrs_contracts_uniques]
GO
/*
 =======================================================================================
 $Author:		Jon Seidel
 $Create date: 2012-12-16
 $Description:	View to access unique worker information from BTRS
					Uses the vw_btrs_contracts view	
 =======================================================================================
 $ISSUES / 2DOs:
 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
				is specified for more than one client. 
				* This view eliminates all dups!
 =======================================================================================
 $CHANGE LOG:
 2012-12-16 jes	- initial creation
 =======================================================================================
 */

CREATE VIEW [dbo].[vw_btrs_contracts_uniques]
	(pos_number, client_number, pos_dept, pos_category, pos_type,
	 pos_start_date, pos_end_date,
	 client_name, contact_name, contact_phone, bill_rate, pay_rate )
AS 
	SELECT * FROM vw_btrs_contracts
	EXCEPT 
	SELECT * from vw_btrs_contracts_duplicates
GO
