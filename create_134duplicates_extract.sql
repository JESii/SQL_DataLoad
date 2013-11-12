DECLARE @RC int
DECLARE @SQLBody varchar(5000)
DECLARE @sWhere varchar(8000)
DECLARE @sOrder varchar(2000)
DECLARE @DataPath nvarchar(500)
DECLARE @FileName nvarchar(50)
set @SQLBody = 	'select * from XXXBTRS_SQL.dbo.tblPOSContracts PC where PC.JobID in (select distinct PC.JobID from XXXBTRS_SQL.dbo.tblposcontracts PC ' +
	'where PC.PONumber in (select distinct pos_number from XXXBTRS_SQL.dbo.vw_btrs_contracts_duplicates))' +
	'order by pc.PONumber, pc.JobID '
set @sWhere = ''
set @sOrder = ''
set @DataPath = 'c:\XXX\dataload\'
set @FileName = 'testContracts.txt'

-- TODO: Set parameter values here.
use XXXBTRS_SQL
EXECUTE @RC = [XXXBTRS_SQL].[dbo].[sp_Generic_frm_Dynamic_SQL_Export] 
   @SQLBody
  ,@sWhere
  ,@sOrder
  ,@DataPath
  ,@FileName
GO


