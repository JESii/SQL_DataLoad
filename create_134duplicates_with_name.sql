use XYZBTRS_SQL
declare @cmd varchar(1000)
drop table tblPOSContracts_temp
select * into tblPOSContracts_temp from XYZ_POSContracts_Import
delete tblPOSContracts_temp
bulk insert tblPOSContracts_temp
from 'c:\XYZ\dataload\testContracts.txt'
with (
	rows_per_batch = 1000,
	fieldterminator = '\t',
	rowterminator = '\n'
	)
