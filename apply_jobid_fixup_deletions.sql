/*
 ********** Taken from test_duplicate_pos.sql *********
 *** Identify/display JobIDs associated with remaining Duplicate POS entries
 * 1) all JobsIDs
 * 2) JobIDs with no activity in the Visits table
 * 3) Delete any inactive JobIDs
 *
 *	This must be applied AFTER JohnDoe2's s/sheet fixup is applied
 *                   and AFTER the primary views are created!!!
 */
use XYZBTRS_SQL 
select COUNT(*), 'Remaining "Duplicate POS" items' from vw_btrs_contracts_duplicates
declare @tmp table (jobID int, clientID int, PONumber int)
/*
 *** Following count was zero, meaning tblPOSContracts is a superset of tblPOSHrs
select PH.* from tblPOSHrs PH
	left join tblPOSContracts PC on PC.JobID = PH.JobId
	where PC.JobID is null
 */	
insert into @tmp
select PC.JobID, pc.ClientID, pc.PONumber from tblposcontracts PC 
	where cast(pc.ClientID as varchar(12)) + '/' + cast(PC.PONumber as varchar(12)) 
			in (select cast(CD.client_number as varchar(12)) + '/' + cast(CD.pos_number as varchar(12)) from vw_btrs_contracts_duplicates CD)
declare @tmpall table (jobID int, clientID int, PONumber int)

insert into @tmpall
	select * from @tmp
	order by jobID
declare @tmpnoact table (jobID int, clientID int, PONumber int)
--select *, 'All JobIDs from the remaining duplicate POSnumbers' from @tmpall
insert into @tmpnoact
select T.* from @tmp T
	left join tblVisits V on V.JobId = T.jobID
	where v.VisitID is null
	order by jobID
--select *,'JobIDs with no visits from the remaining duplicate POSnumbers' from @tmpnoact
delete FROM tblPOSContracts
	WHERE JobID in (select JobID FROM @tmpnoact )
PRINT '==> ' + CAST(@@ROWCOUNT as varchar(8)) + ' inactive JobIDs deleted'
