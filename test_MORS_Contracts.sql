/*
 * List POS Contracts in BTRS and not in CareTrack
 ***	Note: NULL POS Numbers are excluded
 ***	As it turns out, these are the same ones in the vw_btrs_contracts_duplicates
 */
use XYZBTRS_SQL
select distinct PC.PONumber from tblPOSContracts PC where PONumber is not null and JobID is not null
except
select distinct  MC.pos_authorization_number from mors_contract MC where pos_authorization_number is not null

