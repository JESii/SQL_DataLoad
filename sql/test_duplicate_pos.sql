/*
 * Display Basic info on Duplicate POS entries and related Visits items.
 */
use [MHCBTRS_SQL]
SELECT *    FROM [MHCBTRS_SQL].[dbo].[vw_btrs_contracts_duplicates]
	order by client_number
select V.* from tblvisits V where V.PONumber in (select pos_number from vw_btrs_contracts_duplicates)
select V.* from tblvisits V where V.PONumber in (select pos_number from vw_btrs_contracts_duplicates)
	and v.PONumber is not null and v.Pay_Hours <> 0.0 and v.JobId is not null

/*
 *** Identify/display JobIDs associated with remaining Duplicate POS entries
 *** 1) all JobsIDs
 *** 2) JobIDs with no activity in the Visits table
 */
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
select *, 'All JobIDs from the remaining duplicate POSnumbers' from @tmpall
insert into @tmpnoact
select T.* from @tmp T
	left join tblVisits V on V.JobId = T.jobID
	where v.VisitID is null
	order by jobID
select *,'JobIDs with no visits from the remaining duplicate POSnumbers' from @tmpnoact
declare @tmpact table (jobID int, clientID int, PONumber int)
insert into @tmpact
select * from @tmpall
except
select * from @tmpnoact
select distinct TA.PONumber, TA.clientID, 'Summary of active POS Numbers' from  @tmpact TA
	order by PONumber

select PONumber, COUNT(*), MAX('Remaining Dup POS Numbers') from (select distinct TA.PONumber, TA.clientID from  @tmpact TA) Z
	group by PONumber
	having COUNT(*) > 1

declare @tmpduppos table (PONumber int)
insert into @tmpduppos
select PONumber from (select distinct TA.PONumber, TA.clientID from  @tmpact TA) Z
	group by PONumber
	having COUNT(*) > 1
	
select * from 	@tmpact
	where PONumber in (select * from @tmpduppos)
	order by PONumber
select * from tblVisits V
	where V.PONumber in (
		select TA.PONumber  from @tmpact TA
	where PONumber in (select * from @tmpduppos)
	)
	order by PONumber