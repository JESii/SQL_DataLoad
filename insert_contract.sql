/*
 * =======================================================================================
 * $Author:		    Jon Seidel
 * $Create date:  2012-12-13
 * $Description:	Populate MORS contract table from BTRS tblPOSContracts
 * =======================================================================================
 * $ISSUES / 2DOs:
 * 2012-01-02 - MANY rows have no Pay_Rate in tblPOSContracts
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-13 jes - initial creation
 * 2012-12-14 jes - Add new [BTRS_client_number] column
 * 2013-01-02 jes - Update summary print for improved output (count unique POS #s)
 *                - Update unit_rate column from ttmpVisits_Rates
 * 2013-01-04 jes - Update unit_rate & unit_cost columns from new mors_job_rates table
 * 2013-02-08 jes - Leave start/end date NULL and update later; set contract date to
 *                dummy value and update later; set #months to 0 & update later
 * =======================================================================================
 */

USE XYZBTRS_SQL

DELETE [mors_contract]

INSERT INTO [mors_contract] 
SELECT
	1 AS [customer_id]
	--,CASE WHEN pos_start_Date IS NOT NULL THEN pos_start_Date ELSE '1900-01-01' end [date_of_contract]
	,'1900-01-01' [date_of_contract]
	,CASE  WHEN pos_number IS NOT NULL THEN pos_number ELSE 0 end AS [pos_authorization_number]
	,MCLID AS [client_id]
  ,ClientID AS [BTRS_client_number]
	,'' AS [case_manager_name]
	,'' AS [case_manager_id]
	,CASE pos_type WHEN 'M' THEN 2  WHEN  'Q' THEN 3  WHEN 'O' THEN 1 ELSE 0 end AS [contract_period]
	,CASE [pos_dept] WHEN   2 THEN 1  WHEN  4 THEN 2 ELSE 0 end AS [employee_type]
	,CASE [pos_category] WHEN  4 THEN 1  WHEN  5 THEN 2  WHEN  3 THEN 1 ELSE 0 end AS [service_type]
	--,pos_start_Date AS [start_date]
	,NULL AS [start_date]
	--,pos_end_Date AS [end_date]
	,NULL AS [end_date]
	,'' AS [budget_code]
	,'' AS [account_code]
	--,CASE WHEN DATEDIFF (month , pos_start_Date , pos_end_Date ) > 0 THEN DATEDIFF (month , pos_start_Date , pos_end_Date )  ELSE 0 end AS [number_of_months]
	,0 AS [number_of_months]
	,'' AS [dos_code]
	,'' AS [dos_subcode]
	,0 AS [authorized_units]
	,0.00 AS [unit_rate]
	,0.00 AS [unit_cost]
	,0 AS [contingent_months]
	,GetDate() AS [date_created]
	,GetDate() AS [date_updated]
	,0 AS [created_by_user_id]
	,0 AS [updated_by_user_id]
  FROM (SELECT *, MCL.id as MCLID, C.client_number as ClientID
      FROM vw_btrs_contracts_uniques C
      JOIN [mors_client] as MCL ON MCL.BTRS_client_number = C.client_number
  ) Z

PRINT '==> ' + CONVERT(varchar(10), @@ROWCOUNT) + ' rows inserted into [mors_contract]'  
DECLARE @tmp INT = (SELECT count(*) from (select distinct PONumber from tblPOSContracts) T)
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' unique POS numbers in tblPOSContracts'

/*
 * Now update the unit_rate and unit_cost columns from mors_job_rates
 *
 *  Note that this is 'brute force'. mors_job_rates has already been forced because
 *  there are different rate/cost values in tblAssignments (original source)
 *  and now there may be different costs per job for a POS# so we just take the DISTINCT value
 */

UPDATE [mors_contract]
  SET unit_rate = Z.unit_rate,
      unit_cost = Z.unit_cost
	FROM mors_job_rates Z
		WHERE [mors_contract].pos_authorization_number = Z.pos_authorization_number 
			AND Z.pos_authorization_number IS NOT NULL
DECLARE @cnt1 VARCHAR(8) = CAST(@@ROWCOUNT AS VARCHAR(8))
SET @tmp = (SELECT COUNT(*) FROM mors_contract
                  WHERE unit_rate IS NULL OR unit_cost IS NULL)
DECLARE @cnt3 varchar(8) = CAST(@tmp AS VARCHAR(8))
PRINT '==> ' + @cnt1 + ' unit_rate / unit_cost values updated' + CHAR(10)
  +   '    ' + @cnt3 + ' rows with NULL values remaining.'

PRINT '==> WARNING! The counts above do not match up for some reason!!!' 
