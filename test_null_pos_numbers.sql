/*
 * Test for NULL/empty POS Numbers
 * The two selects show that even if the POSContract or POSHrs table are there, the PONumber is NULL there
 */
DECLARE @cmd varchar(2000)
exec xp_cmdshell 'bcp "select * from XYZbtrs_sql.dbo.tblVisits where PONumber IS NULL" queryout "C:\XYZ\DataLoad\tblVisits_errors.txt" -c -T -S + ' @@servername

select * from tblPOSContracts where JobID in ( select JobID from tblVisits where PONumber is null)
select * from tblPOSHrs where JobID in ( select JobID from tblVisits where PONumber is null)
return
SET @cmd = 'bcp "select * from XYZbtrs_sql.dbo.tblVisits where PONumber IS NULL" out "C:\XYZ\DataLoad\tblVisits_errors.txt"   -c -S' + @@servername + ' -T'
exec master..xp_cmdshell @cmd
select * from tblVisits where PONumber IS NULL or PONumber = ''
select COUNT(*) from tblVisits
