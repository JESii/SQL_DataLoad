/*
 * Test/count various visits table results
 */
use XYZBTRS_SQL
declare @tmp table (visit_id int)
declare @visits table (visit_id int)

select COUNT(*),'MTE' as ttl from mors_time_entry
select COUNT(*),'MTE zero pay hours' as ttl from mors_time_entry MTE
	where mte.hours = 0.0
select COUNT(*),'Visits' as ttl from tblVisits V
insert into @tmp
select v.VisitID from tblVisits V 
	where v.VisitID not in (select mte.BTRS_visit_id from mors_time_entry MTE)
select COUNT(*), 'Visits missing from MTE' as ttl from (select * from tblVisits V 
	where v.VisitID not in (select mte.BTRS_visit_id from mors_time_entry MTE)) Z 
delete @tmp
insert into @tmp
select v.VisitID from tblVisits V
	where v.Pay_Hours = 0.0 and v.PONumber is not null and v.JobId is not null
select COUNT(*),'Visits with zero PayHrs' as ttl from @tmp
	--or v.PONumber is null --or v.jobid is null
insert into @visits 
	select * from @tmp
delete @tmp
insert into @tmp
	select v.VisitID from tblvisits V where v.ponumber is null	
select count(*),'Visits with NULL POS number (see following table)' as ttl from @tmp
select * from tblVisits V where v.VisitID in (select * from @tmp)
insert into @visits
	select * from @tmp
delete @tmp	
select COUNT(*), 'POSContracts with jobs matching Visis with NULL POS numbers (see following table)' as ttl from tblPOSContracts PC where pc.JobID in (select v.jobid from tblVisits V where v.PONumber is null)
select * from tblPOSContracts PC where pc.JobID in (select v.jobid from tblVisits V where v.PONumber is null)
select 0,'MTE entries with doubled Visits IDs (should be zero)' as ttl
select mte.BTRS_visit_id, count(*) from mors_time_entry MTE
	group by mte.BTRS_visit_id
	having COUNT(*) > 1
insert into @tmp
	select V.VisitID from tblvisits V where V.PONumber in (select pos_number from vw_btrs_contracts_duplicates)
	and v.PONumber is not null and v.Pay_Hours <> 0.0 and v.JobId is not null
insert into @visits select * from @tmp
delete @tmp	
select COUNT(*), 'Identified missing visits' as ttl from @visits
insert into @tmp
select v.VisitID from tblVisits V
	where v.VisitID not in (select mte.BTRS_visit_id from mors_time_entry MTE)
	  and v.VisitID not in (select * from @visits)
select COUNT(*), 'Unidentified missing visits (see following table)' as ttl from @tmp
select * from tblVisits V
	where v.VisitID in (select * from @tmp)  