/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date:	2013-01-02
 * $Description:  Remove spurious records; cleanup data
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-01-02 jes	- initial creation
 * 2013-01-03 jes - Fix bad JOIN on PC.ClientID => S/B PC.JobID when pusing POS Numbers
 *                into tblVisits & ttmpVisits_Rates
 * =======================================================================================
 */
USE XYZBTRS_SQL

-- Remove records in tblVisits / ttmpVisits_Rates which are empty
PRINT '==> NOTE: Some results may be zero if this procedure has already been run'
PRINT '==> Removing empty rows from tblVisits'
DELETE FROM tblVisits
  WHERE ClientID IS NULL
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' NULL rows deleted from tblVisits'  
PRINT '==> Removing empty rows from ttmpVisits_Rates'
DELETE FROM ttmpVisits_Rates
  WHERE Client_ID IS NULL
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' NULL rows deleted from ttmpVisits_Rates'  

-- Get rid of double-quotes in name fields
PRINT '==> Removing double-quotes from names in tblVisits'
UPDATE tblVisits
  SET xxxApplicant_Name = REPLACE(xxxApplicant_Name,'"','')
  WHERE xxxApplicant_Name LIKE '%"%'
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' quoted applicant names updated in tblVisits'
PRINT '==> Removing double-quotes from names in ttmpVisits_Rates'
UPDATE ttmpVisits_Rates
  SET Applicant_Name = REPLACE(Applicant_Name,'"','')
  WHERE Applicant_Name LIKE '%"%'
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' quoted applicant names updated in ttmpVisits_Rates'
PRINT '==> Removing double-quotes from names in tblClients'
UPDATE tblClients
  SET Client_Name = REPLACE(Client_Name,'"','')
  WHERE Client_Name LIKE '%"%'
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' quoted client names updated in tblClients'

-- Push POS Numbers into tblVisits & ttmpVisits_Rates when available in tblPOSContracts
DECLARE @cnt1 INT 
PRINT '==> Updating NULL POS Numbers in tblVisits from tblPOSContracts'
UPDATE tblVisits
  SET PONumber = PC.PONumber
  FROM tblVisits V
  JOIN tblPOSContracts PC ON PC.JobID = V.JobID
	WHERE PC.PONumber IS NOT NULL and V.PONumber IS NULL
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' NULL POS Numbers updated in tblClients'
SET @cnt1 = (SELECT COUNT(*) FROM tblVisits
	WHERE PONumber IS NULL)
PRINT '==> ' + CAST(@cnt1 AS VARCHAR(8)) + ' remaining tblVisits records with NULL POS Number'

PRINT '==> Updating NULL POS Numbers in ttmpVisits_Rates from tblPOSContracts'
UPDATE ttmpVisits_Rates
  SET PO_Number = PC.PONumber
  FROM ttmpVisits_Rates V
  JOIN tblPOSContracts PC ON PC.JobID = V.Job_ID
	WHERE PC.PONumber IS NOT NULL and V.PO_Number IS NULL
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(8)) + ' NULL POS Numbers updated in ttmpVisits_Rates'
SET @cnt1 = (SELECT COUNT(*) FROM ttmpVisits_Rates
	WHERE PO_Number IS NULL)
PRINT '==> ' + CAST(@cnt1 AS VARCHAR(8)) + ' remaining ttmpVisits_Rates records with NULL POS Number'
