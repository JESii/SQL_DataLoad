No Longer Used
USE [XYZBTRS_SQL]
-- =======================================================================================
-- $Author:		Jon Seidel
-- $Create date: 2012-12-16
-- $Description:	View to access unique worker information from BTRS
--					Uses the vw_btrs_contracts view	
-- =======================================================================================
-- $ISSUES / 2DOs:
-- 2012-12-16	- There are duplicate POS Numbers in this file; i.e., the same POS Number
--				is specified for more than one client. 
--				* This view eliminates all dups!
-- =======================================================================================
-- $CHANGE LOG:
-- 2012-12-16 jes	- initial creation
-- =======================================================================================

ALTER VIEW [dbo].[vw_btrs_contracts_uniques]
	(pos_number, client_number, pos_dept, pos_category, pos_type,
	 pos_start_date, pos_end_date,
	 client_name, contact_name, contact_phone, bill_rate, pay_rate )
AS 
	SELECT * FROM vw_btrs_contracts
	EXCEPT 
	SELECT * from vw_btrs_contracts_duplicates




GO


