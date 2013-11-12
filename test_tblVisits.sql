/*
 * Various tests of tblVisits
 */
use XYZBTRS_SQL
select * from tblVisits V
	where v.PONumber is null
select * from tblVisits V
	where v.JobId is null
select * from tblVisits V
	left join tblPOSContracts PC ON PC.JobID = v.JobId
	where PC.PONumber is null	
select * from tblPOSContracts
	where PONumber is null	
select * from tblPOSContracts
	where JobID is null	

/*
 * List missing Visits
 */
select V.* from tblVisits V
  left join mors_time_entry TE on TE.visitid = V.id
  where TE.visitid is null
