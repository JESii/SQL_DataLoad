/*
 * =======================================================================================
 * $Author:		Jon Seidel
 * $Create date:	2013-01-02
 * $Description:  Display differences in counts for various tables
 *    Required because found that POSHrs has way fewer items than POSContracts
 * =======================================================================================
 * $ISSUES / 2DOs:
 * ** As of 2013-01-02, the uniques/duplicates "balance" between MORS/BTRS, even though
 *    the queries below don't exactly reflect that (see @cnt2d for the cheat)
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-01-02 jes	- initial creation
 * =======================================================================================
 */
USE XYZBTRS_SQL
DECLARE @cnt1 int = (
select count(*)
	from (select distinct PH.JobID
	    from tblPOSHrs PH	) Z )
DECLARE @cnt2 int = (
select count(*)
	from (select distinct pc.JobID
	    from tblPOSContracts PC	) Z )
DECLARE @cnt2m int = (
  select count(*)
    from (select distinct MC.job_number
      from mors_contract_job MC ) Z )
DECLARE @cnt3 int = (
select count(*) 
	from (select distinct PH.PONumber
		  from tblPOSHrs PH	) Z )
DECLARE @cnt4 int = (
select count(*) 
	from (select distinct PC.PONumber, PC.ClientID
		  from tblPOSContracts PC
        where pc.PONumber is not null and pc.ClientID is not null) Z )
DECLARE @cnt4d int = (
select count(*)
	from vw_btrs_contracts_duplicates) 
DECLARE @cnt4m int = (
select count(*) 
  from (select distinct MC.pos_authorization_number
    from mors_contract MC ) Z )

PRINT '==> UNIQUE Jobs/Contracts comparison <==' + CHAR(10)
    + '         POSHrs/Jobs:      ' + convert(varchar(10),@cnt1) + CHAR(10)
    + '   POSContracts/Jobs:      ' + convert(varchar(10),@cnt2) + CHAR(10)
    + '           MORS/Jobs:      ' + convert(varchar(10),@cnt2m) + CHAR(10)
    + '         POSHrs/PONumbers: ' + convert(varchar(10),@cnt3) + CHAR(10) 
    + '   POSContracts/PONumbers: ' + convert(varchar(10),@cnt4) + ' (with duplicates)' + CHAR(10)
    + '   POSContracts/PONumbers: ' + convert(varchar(10),@cnt4d)+ ' (duplicates)' + CHAR(10) 
    + '           MORS/PONumbers: ' + convert(varchar(10),@cnt4m)

