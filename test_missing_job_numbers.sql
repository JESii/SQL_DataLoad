/*
 * Queries to select the records of JobIDs which are on the 1741 list 
 *	but which are not in the Duplicated POS Number set of JobIDs
 */
select distinct D.pos_number from vw_btrs_contracts_duplicates D
Declare @tbl_in table (jobid int)
insert into @tbl_in
select distinct Z.job_number from 
(select distinct mcj.job_number as job_number from mors_contract_job MCJ
union
select distinct jobid from tblposContracts where ponumber in (select distinct D.pos_number from vw_btrs_contracts_duplicates D)
)	Z
/* Not needed; they are one and the same
	and PONumber not in (select MC.job_number from mors_contract_job MC)
	*/
--select * from  @tbl
declare @tbl_out table (jobid int)
insert into @tbl_out	
select distinct JobID from tblPOSContracts where JobID not in (select * from @tbl_in)

select distinct 'Missing JobIDs used in WorkShifts (Visits' as title, jobid from tblVisits where JobId in (select * from @tbl_out)	
select 'Missing JobIDs in tblPOSContracts' as title, 
	* from tblPOSContracts where JobID in (select * from @tbl_out)
select 'Missing JobIDs in tblVisits' as title, 
	[VisitID],[ClientID],convert(varchar(10),[Work_Date],111) as work_date,[Work_Day],convert(varchar(10),[Start_Time],108) as start_time
      ,convert(varchar(10),[End_Time],108) as end_time,[xxxApplicant_Name],[WorkerID],[Pay_Hours],[PONumber]
      ,[Description],[Type],[Category],[Work_Month],[JobId],convert(varchar(10),[Progress_Date],111) as progress_date 
      from tblVisits where JobId in (select * from @tbl_out)