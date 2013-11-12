USE XYZBTRS_SQL
/****************
 * Attempted to match tblVisits to tblAssignments in order to insert Worker Id into tblVisits
 * and improve matching... unfortunately, even with all the fields you see below, it never came close enough
 * (For example, many of the Assignments entries have an end_date 1 day after the start_date)
 *
 * The final select statement does the matching and then tests to see if there are rows with the same VisitID
 *	Testing on 2013-02-11 showed:
 *		tblVisits has 109956 rows
 *		the matching has 105406 rows
 */
 
select top 100 * from tblPOSContracts
select top 100 * from XYZ_POSContracts_Import
select COUNT(*) from tblVisits
select count(*) from tblAssignments
select COUNT(*) from tblAssignments  
/* Try the matching */
select  distinct A.ApplicantID, v.* 
	from tblVisits V
	left join tblAssignments A on a.JobID = v.JobId
						 and V.xxxApplicant_Name = XYZbtrs_sql.dbo.fn_collect_name(A.xxxAppl_First_Name, A.xxxAppl_Middle_Name, A.xxxAppl_Last_Name)
						 and  A.ClientID = V.ClientID 
						 and cast(A.Asgn_Start_Time as time) = cast(V.Start_Time as time)
						 and cast(A.Asgn_End_Time as time) = cast(v.End_Time as time)
						 and convert(varchar(10), a.Asgn_Start_Date,108) = convert(varchar(10), v.Work_Date,108)
						 --and convert(varchar(10), a.Asgn_End_Date,108) = convert(varchar(10), v.Work_Date,108)
	where a.AssignmentID is not null
/* See if we have duplicate visitids */
select * from tblvisits 
where visitid in 
 (select visitid from 
 ( select  distinct A.ApplicantID, v.* 
	from tblVisits V
	left join tblAssignments A on a.JobID = v.JobId
						 and V.xxxApplicant_Name = XYZbtrs_sql.dbo.fn_collect_name(A.xxxAppl_First_Name, A.xxxAppl_Middle_Name, A.xxxAppl_Last_Name)
						 and  A.ClientID = V.ClientID 
						 and cast(A.Asgn_Start_Time as time) = cast(V.Start_Time as time)
						 and cast(A.Asgn_End_Time as time) = cast(v.End_Time as time)
						 and convert(varchar(10), a.Asgn_Start_Date,108) = convert(varchar(10), v.Work_Date,108)
						 --and convert(varchar(10), a.Asgn_End_Date,108) = convert(varchar(10), v.Work_Date,108)
	where a.AssignmentID is not null
	) Z
	group by visitid
	having COUNT(*) > 1
	--ClientID, JobID, Work_Date,Start_Time, End_Time
	)					 