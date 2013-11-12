
/*
 * Test mors_time_entry
 */
use XYZBTRS_SQL
select 'MISSING' ID, COUNT(*) from tblvisits as V
	left join mors_time_entry AS MTE on mte.BTRS_visit_id = V.VisitID
	where mte.btrs_visit_id is null 
select 'NULL PO' ID, COUNT(*) from tblvisits as V
	left join mors_time_entry AS MTE on mte.BTRS_visit_id = V.VisitID
	where mte.btrs_visit_id is null and V.PONumber is null
select 'DUPS' ID, V.* from tblvisits as V
	left join mors_time_entry AS MTE on mte.BTRS_visit_id = V.VisitID
	where mte.btrs_visit_id is null and V.PONumber in (select distinct BCD.pos_number from vw_btrs_contracts_duplicates BCD)
	order by v.PONumber
select 'NDUPS' ID, V.* from tblvisits as V
	left join mors_time_entry AS MTE on MTE.BTRS_visit_id = V.VisitID
	where mte.btrs_visit_id is null and V.PONumber not in (select distinct BCD.pos_number from vw_btrs_contracts_duplicates BCD)
	order by v.PONumber
