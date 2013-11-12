use XYZBTRS_SQL
select PC.* from tblVisits V
	JOIN tblPOSContracts PC ON V.JobId = PC.JobID
	WHERE V.PONumber is null
select PC.* from tblPOSContracts PC
	join (select distinct v.JobId
		from tblVisits V where V.PONumber is null) TMP	on TMP.jobid = PC.JobID
	where PC.PONumber is NULL	


select * from tblVisits V
	where JobId in (4035, 4063, 4075)	
		
select * from tblPOSContracts PC
	where PC.PONumber is null	
