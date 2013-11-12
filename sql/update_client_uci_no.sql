/*  
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-26
 * $Description:	Update MORS client UCI numbers from remittance table
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-26 jes	- initial creation
 * 2012-12-29 jes - Set uci_number to NULL, not ''
 * =======================================================================================
 */
USE XYZBTRS_SQL

/* Remove any existing UCI numbers from the client table */
UPDATE mors_client
  SET uci_number = NULL
PRINT '==> Cleared old UCI numbers from client table'

GO  

/* Now update UCI numbers from the remittance table */  
UPDATE mors_client
	SET uci_number = MR.uci_no
	FROM mors_remittance AS MR
	JOIN mors_client_xref AS MCX ON MCX.btrs_uci_match_name = MR.btrs_uci_match_name
	JOIN mors_client MC on MC.BTRS_client_number = MCX.BTRS_client_number

PRINT '==> Added UCI numbers to clients'
DECLARE @counter INT
SET @counter = (SELECT COUNT(*) FROM mors_client MC WHERE MC.uci_number IS NULL)
PRINT '===> ' + CONVERT(VARCHAR(6), @counter) + ' clients have no UCI number'
