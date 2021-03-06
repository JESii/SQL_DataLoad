/*
 * Update mors_contract table with start & end dates and start-of-contract date
 * plus number of months.
 * Obtained by getting earliest start date and latest end date from contract table
 * ================================================================================
 * $CHANGE LOG:
 * 2013-02-07 jes - initial creation; creation of mors_contract table changing so
 *                so that these values are NULL or '1900-01-01' until set here
 * 2013-02-10 jes - Correct date calculation error: we can't handle the '1900-01-01'
 *                items here as they cause tinyint overflow
 * ================================================================================
 */
use MHCBTRS_SQL

UPDATE mors_contract
	SET [date_of_contract] = Z.start_date,
		start_date = Z.start_date,
		end_date = Z.end_date,
		number_of_months = DATEDIFF(MONTH, z.start_date, z.end_date)
FROM (		
SELECT mcj.btrs_pos_number, MIN(mcj.start_date) as start_date, MAX(mcj.end_date) as end_date
	FROM mors_contract_job MCJ  
	GROUP BY mcj.BTRS_pos_number) Z
	WHERE Z.BTRS_pos_number = mors_contract.pos_authorization_number
	  AND Z.start_date <> '1900-01-01'

