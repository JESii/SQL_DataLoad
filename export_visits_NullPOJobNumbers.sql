/*
 * Export file containing Visits (Work-Shifts) with NULL POS or Job Numbers
 *	Ignore any all-NULL rows
 *
 *	Creates file: tblVisits_NullPOJobNumbers.txt
 *
 *	If need the column headers, then go to: http://www.simple-talk.com/content/print.aspx?article=307
 */
USE XYZBTRS_SQL 
DECLARE @cmd varchar(2000)
SET @cmd = 'bcp ' +
	'"select * from XYZbtrs_sql.dbo.tblVisits V where (V.JobId is null or V.JobId = '''') and v.ClientID is not null" ' +
	'queryout "C:\XYZ\DataLoad\tblVisits_NullPOJobNumbers.txt" -c -S' + @@servername + ' -T'
exec master..xp_cmdshell @cmd

/*
 * Now export the Visits with no POS Number matched back to POSContracts
 */
 
SET @cmd = 'bcp '  +
	'"select PC.* from XYZBTRS_SQL.dbo.tblPOSContracts PC ' +
	'join (select distinct v.JobId ' +
	'	from XYZBTRS_SQL.dbo.tblVisits V where V.PONumber is null) TMP	on TMP.jobid = PC.JobID ' +
	'where PC.PONumber is NULL" ' +
	'queryout "C:\XYZ\DataLoad\tblPOSContracts_NullPOWithVisits.txt" -c -S' + @@servername + ' -T'
exec master..xp_cmdshell @cmd
