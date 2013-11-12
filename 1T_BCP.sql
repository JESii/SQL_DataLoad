-- BCP Output
USE XYZBTRS_SQL
DECLARE @cmd varchar(1000)
-- Create the format file
SET @cmd = 'bcp XYZBTRS_SQL.dbo.tblClients format nul -c  -fc:\XYZ\DataLoad\export_clients.fmt -S' + @@servername + ' -T '
exec master..xp_cmdshell @cmd

-- Create the command to export the data
SET @cmd = 'bcp XYZBTRS_SQL.dbo.tblClients out C:\XYZ\DataLoad\export_clients.txt -fc:\XYZ\DataLoad\export_clients.fmt  -c -S' + @@servername + ' -T'
PRINT @cmd
-- And do it!
exec master..xp_cmdshell @cmd
