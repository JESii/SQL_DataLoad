/*
 * Script to create update client uci number for items that
 * cannot be matched by name
 */
USE [XYZBTRS_SQL]

DECLARE @remittance TABLE (
  consumer_name         VARCHAR(60),
  uci_no                VARCHAR(20),
  pos_authorization_no  VARCHAR(20),
  BTRS_UCI_match_name   VARCHAR(60)
  )

INSERT INTO [remittance]
SELECT MR.consumer_name, MR.uci_no, MR.pos_authorization_no, MR.BTRS_UCI_match_name 
  FROM mors_remittance MR
	LEFT JOIN mors_client_xref MCX ON MR.btrs_uci_match_name = MCX.btrs_uci_match_name
	WHERE mcx.btrs_uci_match_name IS NULL

UPDATE mors_client
  SET uci_number = MR.uci_no
  FROM @remittance MR
  JOIN mors_contract MCT ON MR.pos_authorization_no = MCT.pos_authorization_number
  JOIN mors_client MC ON MCT.BTRS_client_number = MC.BTRS_client_number
  WHERE MC.uci_number IS NULL
