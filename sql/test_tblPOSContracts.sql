/*
 * Various tests for tblPOSContracts
 */

select COUNT(*) from (select DISTINCT PONumber from tblPOSContracts) PC
select COUNT(*) from mors_contract MC
select PC.* 
	from (select DISTINCT PONumber from tblPOSContracts) PC 
	left join mors_contract MC ON PC.PONumber = MC.pos_authorization_number
	where MC.pos_authorization_number is null
	order by PC.PONumber
select PC.* 
	from (select DISTINCT pos_number from vw_btrs_contracts) PC 
	left join mors_contract MC ON PC.pos_number = MC.pos_authorization_number
	where MC.pos_authorization_number is null
	order by PC.pos_number	