use MHCBTRS_SQL

/*	
Testing results of name matching versus client_number
Needs more work
*/
SELECT count(*) FROM mors_remittance AS MR
	JOIN mors_client_xref AS MCX ON MCX.btrs_uci_match_name = MR.btrs_uci_match_name
	JOIN mors_client MC on MC.BTRS_client_number = MCX.BTRS_client_number

SELECT count(*) FROM mors_remittance AS MR
	JOIN mors_contract AS MCT ON MCT.pos_authorization_number = MR.pos_authorization_no
	JOIN mors_client MC on MC.BTRS_client_number = MCT.BTRS_client_number

