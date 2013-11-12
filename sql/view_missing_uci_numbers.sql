/*  
 * =======================================================================================
 * $Author:			Jon Seidel
 * $Create date:	2012-12-26
 * $Description:	Simple test/view of missing UCI numbers - will need manual adjustments
 *                Sample selection of blank uci numbers and possible matches in remittance
 *                ... Some don't match; some have name differences but should match
 * =======================================================================================
 * $ISSUES / 2DOs:
 * =======================================================================================
 * $CHANGE LOG:
 * 2012-12-26 jes	- initial creation
 * =======================================================================================
 */

USE XYZBTRS_SQL

SELECT * FROM mors_client
	WHERE uci_number = ''
	ORDER BY btrs_client_name
	
SELECT * FROM mors_remittance
	WHERE btrs_uci_match_name LIKE '%abcde%'
	ORDER BY consumer_name	
