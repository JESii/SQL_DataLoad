USE [XYZBTRS_SQL]

/*
 * $DESCRIPTION: Update data for those jobs which reference more than 1 POS number
 *
 * $NOTES:
 * 1) Identify those jobids with multiple POS#
 * 2) Put them into a temp table
 * 3) Use that temp table to select all the relevant entries from Assignments
 **** May need an interim step to get the latest date or do that in (1)
 * 4) Select the POS number associated with the latest (max) date
 * 5) Stuff that back into the Assignments table.
 * =======================================================================
 * $CHANGE LOG:
 * 2013-02-08 jes - Modify to only update records that have the wrong POS Number
 *                - Change selection to 2011-10-01 from 2011-11-01
 * 2013-02-18 jes - Fix selection date; was 2010-11-01
 * =======================================================================
 */
declare @job2pos table (jobid int, poshigh int, poslow int, latest_date smalldatetime, latest_pos_number varchar(10))
declare @detail table (title varchar(12), jobid int, PONumber int, start_date smalldatetime, end_date smalldatetime)
insert into @detail
select 'Visits' as tblName, V.JobId, case when V.PONumber is not null then v.PONumber else 0 end as PONumber,
			 V.Work_Date as start_date, v.Work_Date as end_date from tblVisits V
			 where Work_Date >= '2011-10-01'
union
select 'Assgn' as tblName, A.JobID, case when A.PONumber is not null then A.PONumber else 0 end as PONumber,
			A.asgn_start_date as start_date, A.asgn_end_date as end_date from tblAssignments A
			where A.Asgn_Start_Date >= '2011-10-01'
union			
select 'Cntrcts', PC.JobID, case when PC.PONumber is not null then PC.PONumber else 0 end as PONumber, 
			PC.pos_start_date, PC.pos_end_date from tblPOSContracts PC
			where PC.POS_Start_Date >= '2011-10-01'
union
select 'Hrs', PH.JobId, case when PH.PONumber is not null then PH.PONumber else 0 end as PONumber,
			 '1900-01-01', '1900-01-01' from tblPOSHrs PH	
insert into @job2pos
select X.JobID, X.poshigh, X.poslow, convert(varchar(10), latest_date,111) as latest_date, NULL as latest_pos_number from
(select Y.JobId, y.poshigh, y.poslow, (case when POSLOW = POShigh then '' else 'diff' end) as diff, latest_date from 
(select Z.JobID, max(Z.PONumber) as POShigh , MIN(z.poNumber) as POSlow, MAX(end_date) as latest_date
		, NULL as latest_pos_number from @detail Z

where JobId is not null
group by jobid
) Y
) X
where diff <> ''

DECLARE @cnt2 INT = (SELECT COUNT(*) FROM tblVisits)
PRINT '==> (WRONG!!!) ' + CAST( @cnt2 AS VARCHAR(8)) + ' JobIDs with multiple POS Numbers'

-- Get the 'latest' POS Numbers
update @job2pos
	set latest_pos_number = D.PONumber
	FROM @detail D where [@job2pos].latest_date = D.end_date and [@job2pos].jobid = D.jobid
-- Backfill in case we still get zero	
/*
select 'zeros' as title, * from @detail
	where jobid in (select jobid from @job2pos JP where JP.latest_pos_number = 0)
*/
update @job2pos
	set latest_pos_number = D.PONumber
	from @detail D where [@job2pos].jobid = D.jobid and [@job2pos].latest_pos_number = 0 and D.PONumber <> 0
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

