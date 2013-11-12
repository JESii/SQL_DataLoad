EXEC master.sys.xp_readerrorlog 0, 1, '', '', NULL, NULL, N'desc' 
return
/*
 * Procedure to read the SQL Server error logs
 * From: http://www.mssqltips.com/sqlservertip/1476/reading-the-sql-server-log-files-using-tsql/
 */
/*
use master
DROP PROC dbo.[sp_readerrorlog]
GO
CREATE PROC dbo.[sp_readerrorlog](
*/
declare   @p1  as   INT = 1
declare   @p2  as   INT = NULL
declare   @p3  as   VARCHAR(255) = NULL
declare   @p4  as   VARCHAR(255) = NULL
/*
AS
BEGIN

   IF (NOT IS_SRVROLEMEMBER(N'securityadmin') = 1)
   BEGIN
      RAISERROR(15003,-1,-1, N'securityadmin')
      RETURN (1)
   END
   
   IF (@p2 IS NULL)
       EXEC sys.xp_readerrorlog @p1
   ELSE
*/   
       EXEC master..xp_readerrorlog @p1,@p2,@p3,@p4
--END