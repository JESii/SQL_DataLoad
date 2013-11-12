USE [XYZBTRS_SQL]

/*
 * $DESCRIPTION: Update data for those jobs which reference more than 1 Name
 *** DOESN'T WORK -- multiple workers per JobID ***
 *
 * $NOTES:
 * 1) Identify those jobids with multiple Names
 * 2) Put them into a temp table
 * 3) Use that temp table to select all the relevant entries from Assignments
 **** May need an interim step to get the latest date or do that in (1)
 * 4) Select the Name associated with the latest (max) date
 * 5) Stuff that back into the Assignments table.
 * =======================================================================
 * $CHANGE LOG:
 * 2013-02-18 jes - Created from apply_job2pos_fixups.sql
 * =======================================================================
 */
declare @job2pos table (jobid int, poshigh varchar(60), poslow varchar(60), latest_date smalldatetime, latest_pos_number varchar(10))
declare @detail table (title varchar(12), jobid int, Appl_Name varchar(60), start_date smalldatetime, end_date smalldatetime)
insert into @detail
select 'Visits' as tblName, V.JobId, case when V.xxxApplicant_Name is not null then v.xxxApplicant_Name else '' end as Appl_Name,
			 V.Work_Date as start_date, v.Work_Date as end_date from tblVisits V
			 where Work_Date >= '2011-10-01'
union
select 'Assgn' as tblName, A.JobID, case when dbo.fn_collect_name(A.xxxAppl_First_Name, xxxAppl_Middle_Name, xxxAppl_Last_Name) is not null then dbo.fn_collect_name(A.xxxAppl_First_Name, xxxAppl_Middle_Name, xxxAppl_Last_Name) else NULL end as Appl_Name,
			A.asgn_start_date as start_date, A.asgn_end_date as end_date from tblAssignments A
			where A.Asgn_Start_Date >= '2011-10-01'
insert into @job2pos
select X.JobID, X.poshigh, X.poslow, convert(varchar(10), latest_date,111) as latest_date, NULL as latest_pos_number from
(select Y.JobId, y.poshigh, y.poslow, (case when POSLOW = POShigh then '' else 'diff' end) as diff, latest_date from 
(select Z.JobID, max(Z.Appl_Name) as POShigh , MIN(z.Appl_Name) as POSlow, MAX(end_date) as latest_date
		, NULL as latest_pos_number from @detail Z

where JobId is not null
group by jobid
) Y
) X
where diff <> ''
select * from @job2pos
return
DECLARE @cnt2 INT = (SELECT COUNT(*) FROM tblVisits)
PRINT '==> (WRONG!!!) ' + CAST( @cnt2 AS VARCHAR(8)) + ' JobIDs with multiple POS Numbers'

-- Get the 'latest' POS Numbers
update @job2pos
	set latest_pos_number = D.Appl_Name
	FROM @detail D where [@job2pos].latest_date = D.end_date and [@job2pos].jobid = D.jobid
-- Backfill in case we still get zero	
/*
select 'zeros' as title, * from @detail
	where jobid in (select jobid from @job2pos JP where JP.latest_pos_number = 0)
*/
update @job2pos
	set latest_pos_number = D.Appl_Name
	from @detail D where [@job2pos].jobid = D.jobid and [@job2pos].latest_pos_number = 0 and D.Appl_Name <> ''
/*
select '@job2pos' as title, * from @job2pos
	order by jobid
select 'Assgn' as title, A.JobID, * from tblAssignments A
	join @job2pos J2P ON J2P.latest_date = A.Asgn_Start_Date and A.JobID = J2P.jobid
	order by A.JobID
select 'Visits' as title, V.JobId, * from tblVisits V
	where V.JobId in (select JobId from @job2pos)
	order by V.JobId	
*/
/* TEST before maiking updates!!!
 */
 return
 
 
update tblVisits
	set PONumber = JP.latest_pos_number
	from @job2pos JP where tblVisits.JobId = JP.jobid and tblVisits.PONumber <> JP.latest_pos_number
PRINT '==> ' + cast(@@rowcount as varchar(8)) + ' Visits updated'
update tblAssignments
	set PONumber = JP.latest_pos_number
	from @job2pos JP where tblAssignments.JobId = JP.jobid and tblAssignments.PONumber <> JP.latest_pos_number
PRINT '==> ' + cast(@@rowcount as varchar(8)) + ' Assignments updated'
update tblPOSContracts
	set PONumber = JP.latest_pos_number
	from @job2pos JP where tblPOSContracts.JobId = JP.jobid and tblPOSContracts.PONumber <> JP.latest_pos_number 
PRINT '==> ' + cast(@@rowcount as varchar(8)) + ' POSContracts updated'
update tblPOSHrs
	set PONumber = JP.latest_pos_number
	from @job2pos JP where tblPOSHrs.JobId = JP.jobid and tblPOSHrs.PONumber <> JP.latest_pos_number
PRINT '==> ' + cast(@@rowcount as varchar(8)) + ' POSHrs updated'

