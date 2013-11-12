/*
 * Apply POS "Fixup" information from data provided by JohnDoe1/JohnDoe2 in early January
 * WARNING! The results will be zero if this script has already been applied!
 *
 * NOTE: We do not update all the available data... there are names that might
 * be different and there are a few bill/pay rates: ignored.
 * ============================================================================
 * 2013-01-06 jes - initial creation
 * ============================================================================
 */
USE XYZBTRS_SQL

DECLARE @tmp INT
DECLARE @cnt VARCHAR(10)
SET @tmp = (SELECT COUNT(*) FROM mors_fixup_pos_numbers )
PRINT '==> ' + CAST(@tmp AS VARCHAR(10)) + ' rows in pos fixup table'

UPDATE tblPOSContracts
  SET PONumber = MFPN.pos_authorization_number
  FROM mors_fixup_pos_numbers MFPN
  JOIN tblPOSContracts AS PC ON PC.ClientID = MFPN.BTRS_client_number
    WHERE PC.PONumber IS NULL AND ISNUMERIC(MFPN.pos_authorization_number) = 1
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' POSContracts rows updated'    

UPDATE tblPOSHrs
  SET PONumber = MFPN.pos_authorization_number
  FROM mors_fixup_pos_numbers MFPN
  JOIN tblPOSHrs AS PH ON PH.ClientID = MFPN.BTRS_client_number
    WHERE PH.PONumber IS NULL AND ISNUMERIC(MFPN.pos_authorization_number) = 1
PRINT '==> ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' POSHrs rows updated'    

SET @tmp = (SELECT COUNT(*) 
  FROM mors_fixup_pos_numbers MFPN
  LEFT JOIN tblPOSHrs PH ON PH.JobId = MFPN.job_number
    WHERE PH.JobID IS NULL)
DECLARE @cnt1 VARCHAR(10) = CAST(@tmp AS VARCHAR(10))
PRINT '==> ' + @cnt1 + ' fixup records not in POSHrs table'
