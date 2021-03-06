/***
 * Determine the 'best' pos number to use for any given job number by selecting the highest value found in
 * any of the tables. We will then merge that value back into all the related records, thus reducing mis-matches.
 * ================================================
 * $CHANGE LOG:
 * 2013-01-29 jes - Initial creation/testing
 * 2013-01-31 jes - Create as view for selection purposes
 * ================================================
 */
use MHCBTRS_SQL
DROP VIEW dbo.[vw_job2pos_fixup]
GO

CREATE VIEW dbo.[vw_job2pos_fixup]
AS
select X.JobID, X.poshigh, X.poslow from
(select Y.JobId, y.poshigh, y.poslow, (case when POSLOW = POShigh then '' else 'diff' end) as diff from 
(select Z.JobID, max(Z.PONumber) as POShigh , MIN(z.poNumber) as POSlow from 
(select 'Visits' as tblName, V.JobId, case when V.PONumber is not null then v.PONumber else 0 end as PONumber from tblVisits V
union
select 'Hrs', PH.JobId, case when PH.PONumber is not null then PH.PONumber else 0 end from tblPOSHrs PH
union
select 'Cntrcts', PC.JobID, case when PC.PONumber is not null then PC.PONumber else 0 end from tblPOSContracts PC
union
select 'Assgn', A.JobID, case when A.PONumber is not null then A.PONumber else 0 end from tblAssignments A) Z
where JobId is not null
group by jobid
) Y
) X
where diff <> ''
GO
