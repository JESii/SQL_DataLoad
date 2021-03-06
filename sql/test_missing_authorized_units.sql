/*
 * Test zero authorized_units items in mors_contract_jobs
 */
use MHCBTRS_SQL
declare @tmp table (jobid int, PONumber varchar(16), hours_allotted real)
insert into @tmp
	select MCJ.job_number, MCJ.BTRS_pos_number, MCJ.authorized_units from mors_contract_job MCJ
			--join tblPOSHrs PH ON PH.JobId = MCJ.job_number
			where MCJ.authorized_units = 0.0
PRINT '==> ' + cast(@@rowcount as varchar(8)) + ' "zero" auth-units records in mors_contract_jobs'
select * from @tmp
select PH.Hours_Allotted, MCJ.* from mors_contract_job MCJ
		join tblPOSHrs PH on PH.JobId = MCJ.job_number
		where mcj.job_number in (select JobId from @tmp)
PRINT '==> ' + cast(@@rowcount as varchar(8)) + ' "zero" records in MCJ with matching tblPOSHrs records'
PRINT '==> Remaining records have no matching tblPOSHrs record, therefore no source for auth-units'
return			
SELECT TOP 1000 MCJ.[id],PH.Hours_Allotted
      ,[contract_id]
      ,[job_number]
      ,[BTRS_pos_number]
      ,MCJ.[month]
      ,[year]
      ,[start_date]
      ,[end_date]
      ,[authorized_units]
      ,[date_created]
      ,[date_updated]
      ,[created_by_user_id]
      ,[updated_by_user_id]
  FROM [MHCBTRS_SQL].[dbo].[mors_contract_job] MCJ
  join tblposhrs PH on PH.JobId = MCJ.job_number
  where authorized_units = 0
  order by cast(job_number as int)