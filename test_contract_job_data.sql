use MHCBTRS_SQL
select COUNT(*) from mors_contract_job
	where authorized_units = 0
select count(*) from mors_contract_job
	where start_date like '1900' or end_date like '1900'
DECLARE @tmp varchar(8)
SET @tmp = (select COUNT(*) from mors_contract_job
	where authorized_units = 0)
PRINT '==> ' + CAST(@tmp AS varchar(8)) + ' contract_job records with missing authorized units'	
SET @tmp = (select count(*) from mors_contract_job
	where start_date like '1900%' or end_date like '1900%')
PRINT '==> ' + CAST(@tmp AS varchar(8)) + ' contract_job records with missing Start/End dates'	
  
	
  