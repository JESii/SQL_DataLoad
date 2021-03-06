/***
 * Determine the 'best' pos number to use for any given job number by selecting the highest value found in
 * any of the tables. We will then merge that value back into all the related records, thus reducing mis-matches.
 * ================================================
 * $CHANGE LOG:
 * 2013-01-29 jes - Initial creation
 * ================================================
 */
use MHCBTRS_SQL
select COUNT(*), 'tblVisits' from tblVisits V where V.JobId in (select jobid from vw_job2pos_fixup)
select COUNT(*), 'tblAssignments' from tblAssignments  where JobId in (select jobid from vw_job2pos_fixup)
	and  CAST([Asgn_Start_Date] AS datetime) >= '2011-11-01'
select COUNT(*), 'tblPOSContracts' from tblPOSContracts where JobId in (select jobid from vw_job2pos_fixup)
select COUNT(*), 'tblPOSHrs' from tblPOSHrs  where JobId in (select jobid from vw_job2pos_fixup)