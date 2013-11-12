/*
 * =======================================================================================
 * $Author:                 Jon Seidel
 * $Create date:  2013-01-07
 * $Description:        Display starting table counts
 *	Need to do this to display basic differences/inconsistencies when starting out
 * =======================================================================================
 * $ISSUES / 2DOs:
 *	NOTE: This procedure requires the free version of SQL# (www.sqlsharp.com)
 * =======================================================================================
 * $CHANGE LOG:
 * 2013-01-07 jes - initial creation
 * 2013-01-12 jes - various additions
 * 2013-01-17 jes - Add count of POSHrs items with no Hours_Allotted value (zero or NULL)
 * 2013-01-18 jes - Add contract_job missing information
 * 2013-01-31 jes - Modify for limited Assignments table selection
 * 2013-02-06 jes - Add count of zero Pay_Hours visits & ignore them from counts
 * 2013-02-11 jes - Reminder for sum of hours/dollars for this report
 * 2013-02-16 jes - Ignore "Duplicate POS" in select orphans.
 * 2013-05-10 jes - Add count of clients without UCI numbers
 * =======================================================================================
 */
USE XYZBTRS_SQL
 
DECLARE @tmp INT
/*
 *** @cnt2xxx = Counts from POSContracts
 */
SET @tmp = (select count(*) from tblPOSContracts)
DECLARE @cnt1 varchar(10) = cast(@tmp AS VARCHAR(10))
/* No longer used; identical to tblPOSContracts
SET @tmp = (select count(*) from XYZ_POSContracts_Import)
DECLARE @cnt1I varchar(10) = cast(@tmp AS VARCHAR(10))
*/
SET @tmp = (select count(*) from vw_btrs_contracts)
DECLARE @cnt1VBC varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from tblPOSContracts_Exceptions)
SET @tmp = (select COUNT(*) from vw_btrs_contracts_duplicates)
DECLARE @cnt1BCD varchar(10) = cast(@tmp as varchar(10))
DECLARE @cnt1IE varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from (select DISTINCT PONumber from tblPOSContracts) Z)
DECLARE @cnt1P varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from mors_contract)
DECLARE @cnt1MC varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from (select DISTINCT JobID from tblPOSContracts) Z)
DECLARE @cnt1J varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from mors_contract_job)
DECLARE @cnt1MCJ varchar(10) = cast(@tmp AS VARCHAR(10))
DECLARE @cnt1MCErr varchar(10) = cast( (cast(@cnt1j as INT)-cast(@cnt1MCJ as INT)) as varchar(10))
DECLARE @cnt1MCJErr varchar(10) = cast( (cast(@cnt1j as INT)-cast(@cnt1MCJ as INT)) as varchar(10))

/*
 *** @cnt2xxx = Counts from tblPOSHrs
 */
SET @tmp = (select count(*) from tblPOSHrs)
DECLARE @cnt2 varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from XYZ_POSHrs_Import)
DECLARE @cnt2I varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from tblPOSHrs_Exceptions)
DECLARE @cnt2IE varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from (select DISTINCT PONumber from tblPOSHrs) Z)
DECLARE @cnt2P varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from (select DISTINCT JobID from tblPOSHrs) Z)
DECLARE @cnt2J varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from (
      select PC.ClientID, PH.JobId from tblPOSContracts PC
               left join tblPOSHrs PH ON PH.JobID = PC.JobID
                  WHERE PH.JobID IS NULL) Z )
DECLARE @cnt2Z varchar(10) = cast(@tmp AS VARCHAR(10))
DECLARE @MissingJobsInPOSHrs TABLE (JobID varchar(10))
INSERT INTO @MissingJobsInPOSHrs
  select PC.JobID from tblPOSContracts PC
  left join tblPOSHrs PH on PH.JobID = PC.JobID
    where PH.JobId IS NULL
SET @tmp = (select count(*) from (
      select V.* from tblVisits V
        join @MissingJobsInPOSHrs MJIPH ON MJIPH.JobID = V.JobID) Z )
DECLARE @cnt2MJIPH varchar(10) = CAST(@tmp as VARCHAR(10))  
SET @tmp = (select count(*) from (
      select DISTINCT V.JobID from tblVisits V
        join @MissingJobsInPOSHrs MJIPH ON MJIPH.JobID = V.JobID) Z )
DECLARE @cnt2MJIPHUnique varchar(10) = CAST(@tmp as VARCHAR(10))  
SET @tmp = (select count(*) from tblPOSHrs PH where PH.Hours_Allotted is null or PH.Hours_Allotted = 0)
DECLARE @cnt2ZHA varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select COUNT(*) from mors_contract_job where authorized_units = 0)
DECLARE @cnt2MissingAllottedHours varchar(10) = CAST(@tmp as VARCHAR(10))  
SET @tmp = (select count(*) from mors_contract_job where start_date like '1900%' or end_date like '1900%')
DECLARE @cnt2MissingStartEndDates varchar(10) = CAST(@tmp as VARCHAR(10))  

/*
 *** @cnt3xxx = Counts from tblVisits
 */
SET @tmp = (select count(*) from tblVisits)
DECLARE @cnt3 varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from tblVisits_Exceptions)
DECLARE @cnt3E varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select COUNT(*) from tblVisits where Pay_Hours = 0.0)
DECLARE @cnt3ZeroPayHrs varchar(10) = cast(@tmp as varchar(10))
SET @tmp = (select count(*) from ttmpVisits_Rates)
DECLARE @cnt3VR varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select COUNT(*) from tblvisits V 
	where V.PONumber in (select pos_number from vw_btrs_contracts_duplicates))
DECLARE @cnt3BCDV varchar(10) = cast(@tmp as varchar(10))	
SET @tmp = (select count(*) from mors_time_header)
DECLARE @cnt3MTH varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from mors_time_entry)
DECLARE @cnt3MTE varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from tblVisits WHERE PONumber IS NULL)
DECLARE @cnt3VNP varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select COUNT(*) from tblVisits where JobId is null)
DECLARE @cnt3VNJ varchar(10) = cast(@tmp as varchar(10))
SET @tmp = (select COUNT(*) from tblVisits 
	where Pay_Hours <> 0.0 and PONumber is not null and JobId is not null)
DECLARE @cnt3CandidateVisits varchar(10) = cast(@tmp as varchar(10))	
/*** Cannot use this approach as there may be overlapping values	
DECLARE @cnt3CandidateVisits varchar(10) = CAST( cast(@cnt3 as int) - cast(@cnt3ZeroPayHrs as int) 
			- cast(@cnt3vnJ as int) - cast(@cnt3vnp as int) as varchar(10))
*/			

DECLARE @cnt3MTErr varchar(10) = CAST((CAST(@cnt3CandidateVisits AS INT) - CAST (@cnt3MTE AS INT)) AS varchar(10))
SET @tmp = (select COUNT(*) from tblVisits V
	left join mors_time_entry MTE on MTE.BTRS_visit_id = V.VisitID
	where mte.BTRS_visit_id is null
	   and v.Pay_Hours <> 0.0 and v.PONumber is not null and v.JobId is not null
	   and v.PONumber not in (select vbcu.pos_number from vw_btrs_contracts_duplicates VBCU))
DECLARE @cnt3MTErrSelect varchar(10) = cast(@tmp as varchar(10))
SET @tmp = (select COUNT(*) from mors_time_entry MTE where MTE.hours = 0.0)
DECLARE @cnt3MTEZeroPayHours varchar(10) = CAST(@tmp as varchar(10))
SET @tmp = (SELECT COUNT(*) FROM (SELECT BTRS_Visit_id, COUNT(*) as [counter] FROM mors_time_entry
  GROUP BY BTRS_Visit_id
  HAVING COUNT(*) > 1) Z)	
DECLARE @cnt3DupMTE varchar(10) = cast(@tmp as varchar(10))     
/*
 * Doesn't behave as others; see procAppendNonNumericPONumbers_Visits 
 * SET @tmp = (select count(*) from XYZ_Visits_Import)
 * DECLARE @cnt3I varchar(10) = cast(@tmp AS VARCHAR(10))
 */
SET @tmp = (select count(*) from tblAssignments
            WHERE CAST([Asgn_Start_Date] AS datetime) >= '2011-10-01')
DECLARE @cnt4 varchar(10) = cast(@tmp AS VARCHAR(10))
SET @tmp = (select count(*) from XYZ_Assignments_Import
            WHERE CAST([Asgn_Start_Date] AS datetime) >= '2011-10-01')
DECLARE @cnt4I varchar(10) = cast(@tmp AS VARCHAR(10))
-- Have to clean up the date data as SQL doesn't have a short-circuit AND function
SET @tmp = (select count(*) from tblAssignments_Exceptions
            WHERE CASE WHEN ISDATE([Asgn_Start_Date]) <> 1 THEN '1900-01-01'
             ELSE CAST([Asgn_Start_Date] AS datetime) END >= '2011-10-01')
DECLARE @cnt4E varchar(10) = cast(@tmp as VARCHAR(10))
SET @tmp = (select count(*) from tblClients)

/*
 * Statistics from MORS_client table
 */
DECLARE @cnt5 varchar(10) = cast(@tmp as VARCHAR(10))
SET @tmp = (select count(*) from mors_client)
DECLARE @cnt5MCC varchar(10) = cast(@tmp as VARCHAR(10))
SET @tmp = (select count(*) from (select DISTINCT ClientID FROM tblAssignments) Z)
DECLARE @cnt5A varchar(10) = cast(@tmp as VARCHAR(10))
DECLARE @cnt5MCErr varchar(10) = CAST((CAST(@cnt5 AS INT) - CAST (@cnt5MCC AS INT)) AS varchar(10))
SET @tmp = (SELECT COUNT(*) FROM mors_client MC WHERE MC.uci_number IS NULL)
DECLARE @cnt5MissingUCI varchar(10) = CAST(@tmp as VARCHAR(10))
SET @tmp = (select count(*) from (select DISTINCT ApplicantID FROM tblAssignments) Z)

/*
 * Statistics from MORS_employee table
 */
DECLARE @cnt6 varchar(10) = cast(@tmp as VARCHAR(10))
SET @tmp = (select count(*) from mors_employee)
DECLARE @cnt6ME varchar(10) = cast(@tmp as VARCHAR(10))
DECLARE @cnt6MEErr varchar(10) = CAST((CAST(@cnt6 AS INT) - CAST (@cnt6ME AS INT)) AS varchar(10))

PRINT '==> Summary statistics from Data Load'
PRINT ' NOTE That we exclude assignments prior to 2011/10/01'
PRINT '    POSContracts:             ' + SQL#.String_PadLeft(@cnt1 ,8,' ') + CHAR(10) +
--    '    POSContracts Import:      ' + SQL#.String_PadLeft(@cnt1I ,8,' ') + CHAR(10) +
      '    POSContracts Exceptions:  ' + SQL#.String_PadLeft(@cnt1IE ,8,' ') + ' (U/Staff => BTRS rejections)' + CHAR(10) +
      '    POSContracts (POS Nbrs):  ' + SQL#.String_PadLeft(@cnt1VBC ,8,' ') + ' (select DISTINCT PONumber from vw_btrs_contracts)' + CHAR(10) +
      '    POSContracts (POS Nbrs):  ' + SQL#.String_PadLeft(@cnt1P ,8,' ') + ' (select DISTINCT PONumber from tblPOSContracts)' + CHAR(10) +
      '    POS Number Duplicates:    ' + SQL#.String_PadLeft(@cnt1BCD ,8,' ') + ' (select * from vw_btrs_contracts_duplicates)' + CHAR(10) +
      '    MORS Contracts (MC):      ' + SQL#.String_PadLeft(@cnt1MC ,8,' ') + CHAR(10) +
      '    POSContracts (Job Nbrs):  ' + SQL#.String_PadLeft(@cnt1J ,8,' ') + ' (select DISTINCT JobID from tblPOSContracts)' + CHAR(10) +
      '    MORS Contract Jobs (MCJ): ' + SQL#.String_PadLeft(@cnt1MCJ ,8,' ') + CHAR(10) +
      '    MCJ Missing AllottedHrs:  ' + SQL#.String_PadLeft(@cnt2MissingAllottedHours,8,' ') + CHAR(10) +
      '    MCJ Missing St/En Dates:  ' + SQL#.String_PadLeft(@cnt2MissingStartEndDates ,8,' ') + CHAR(10) +
      '  * POSNumbers vs. MC:        ' + SQL#.String_PadLeft(@cnt1MCErr ,8,' ') + ' (Missing/Errors)' + CHAR(10) +
      '  * POSJobs vs. MCJ:          ' + SQL#.String_PadLeft(@cnt1MCJErr ,8,' ') + ' (Missing/Errors)' + CHAR(10) +
      '    POSHrs:                   ' + SQL#.String_PadLeft(@cnt2 ,8,' ') + CHAR(10) +
--    '    POSHrs Import:            ' + SQL#.String_PadLeft(@cnt2I ,8,' ') + CHAR(10) +
      '    POSHrs Exceptions:        ' + SQL#.String_PadLeft(@cnt2IE ,8,' ') + ' (U/Staff => BTRS rejections)' + CHAR(10) +
      '    POSHrs (POS Nbrs):        ' + SQL#.String_PadLeft(@cnt2P ,8,' ') + ' (select DISTINCT PONumber from tblPOSHrs)' + CHAR(10) +
      '    POSHrs (Job Nbrs):        ' + SQL#.String_PadLeft(@cnt2J ,8,' ') + ' (select DISTINCT JobID from tblPOSHrs)' + CHAR(10) +
      '    POSHrs w/o Allot/Hrs:     ' + SQL#.String_PadLeft(@cnt2ZHA ,8,' ') + ' (Missing/Errors)' + CHAR(10) +
      '  * Jobs not in POSHrs:       ' + SQL#.String_PadLeft(@cnt2Z ,8,' ') + CHAR(10) +
      '  * Visits using those Jobs:  ' + SQL#.String_PadLeft(@cnt2MJIPH ,8,' ') + CHAR(10) +
      '  * Unique Jobs in the Visits:' + SQL#.String_PadLeft(@cnt2MJIPHUnique ,8,' ') + CHAR(10) +
      '  * Visits with Pay_Hours=0:  ' + SQL#.String_PadLeft(@cnt3ZeroPayHrs ,8,' ') + ' (Ignoring)' + CHAR(10) +
      '    Visits (Work-Shifts):     ' + SQL#.String_PadLeft(@cnt3 ,8,' ') + CHAR(10) +
      '    Visits_Rates:             ' + SQL#.String_PadLeft(@cnt3VR ,8,' ') + CHAR(10) +
--    '    Visits Exceptions:        ' + SQL#.String_PadLeft(@cnt3E ,8,' ') + ' (Not Valid)' + CHAR(10) +
      '    Candidate Visits:         ' + SQL#.String_PadLeft(@cnt3CandidateVisits, 8, ' ') + ' (Ignoring Pay_Hours = 0.0, NULL POS#, NULL Job#)' + CHAR(10) +
      '    POS Duplicates Visits:    ' + SQL#.String_PadLeft(@cnt3BCDV, 8, ' ') + ' (Visits relating to remaining "POS Duplicates")' + CHAR(10) +
      '    MORS Time Headers (MTH):  ' + SQL#.String_PadLeft(@cnt3MTH ,8,' ') +  + CHAR(10) +
      '    MORS Time Entries (MTE):  ' + SQL#.String_PadLeft(@cnt3MTE ,8,' ') +  + CHAR(10) +
      '    MTE VisitID duplicates:   ' + SQL#.String_PadLeft(@cnt3DupMTE ,8,' ') + ' (Error)' + CHAR(10) +
      '///////////////// Review these numbers /////////////////' + char(10) +
      '  * Visits vs. MTE:           ' + SQL#.String_PadLeft(@cnt3MTErr ,8,' ') + ' (Missing/Errors - Count)' + CHAR(10) +
      '  * Orphan Visits:            ' + SQL#.String_PadLeft(@cnt3MTErrSelect ,8,' ') + ' (Missing/Errors - Select)' + CHAR(10) +
      '  * MTE with Pay_Hours=0:     ' + SQL#.String_PadLeft(@cnt3MTEZeroPayHours ,8,' ') + ' (Should not be in MTE)' + CHAR(10) +
      '////////////////////////////////////////////////////////' + char(10) +
      '    Visits w/NULL POS Nbrs:   ' + SQL#.String_PadLeft(@cnt3VNP ,8,' ') + CHAR(10) +
      '    Assignments:              ' + SQL#.String_PadLeft(@cnt4 ,8,' ') + CHAR(10) +
      '    Assignments Import:       ' + SQL#.String_PadLeft(@cnt4I ,8,' ') + CHAR(10) +
      '    Assignments Exceptions:   ' + SQL#.String_PadLeft(@cnt4E ,8,' ') + ' (U/Staff => BTRS rejections)' + CHAR(10) +
      '    Clients:                  ' + SQL#.String_PadLeft(@cnt5 ,8,' ') + CHAR(10) +
      '    Clients (Active/Assign):  ' + SQL#.String_PadLeft(@cnt5A ,8,' ') + CHAR(10) +
      '    MORS Clients:             ' + SQL#.String_PadLeft(@cnt5MCC ,8,' ') + CHAR(10) +
      '  * Clients vs. MORS Clients: ' + SQL#.String_PadLeft(@cnt5MCErr ,8,' ') + ' (Missing/Errors)' + CHAR(10) +      
      '    MORS Clients w/o UCI#     ' + SQL#.String_PadLeft(@cnt5MissingUCI ,8,' ') + CHAR(10) +
      '    Applicants (Act/Assign):  ' + SQL#.String_PadLeft(@cnt6 ,8,' ') + CHAR(10) +
      '    MORS Employees (ME):      ' + SQL#.String_PadLeft(@cnt6ME ,8,' ') + CHAR(10) +
      '  * Applicants vs. ME:        ' + SQL#.String_PadLeft(@cnt6MEErr ,8,' ') + ' (Missing/Errors)' + CHAR(10) +  
      '================================================'
      
PRINT '***** REMINDER: Need hours/dollars summaries *****'      
PRINT '///////// Additions for JohnDoe2''s s/sheet ///////////////////////////'
PRINT '***** NOTE1: Use allotted hours from "2+ clients" worksheet *****'
PRINT '***** NOTE2: Update client name when merging jobs *****'
PRINT '/////////////////////////////////////////////////////////////////'
