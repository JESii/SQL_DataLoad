/*
 * Testing queries for getting Bill_Rate and Pay_Rate for Jobs...
 *	NOTE!!! The COUNT(*) stuff doesn't work... There are Jobs with different values
 *				(See jobID #40, #47, ...)
 *	have to fix this
 */
use MHCBTRS_SQL
select COUNT(*), Z.jobid, z.pay_rate from (
	select  distinct top 100 percent A.JobID, A.Pay_Rate from tblAssignments A
		where A.jobid is not null
		order by a.JobID
) Z
	group by z.jobid, z.pay_rate
	having count(z.jobid) > 1
select COUNT(*), Z.jobid, z.bill_rate from (
	select distinct top 100 percent A.JobID, A.bill_rate from tblAssignments A
		where A.jobid is not null
		order by a.JobID
) Z
	group by z.jobid, z.bill_rate
	having count(z.jobid) > 1
select count(*), z.jobid, z.bill_rate, z.pay_rate from (
	select distinct top 100 percent A.jobid, A.bill_rate, A.pay_rate from tblAssignments A
		where A.jobid is not null
		order by a.JobID
) Z
	group by z.JobID, z.Bill_Rate, z.Pay_Rate
	having COUNT(jobid) > 1
	order by z.JobID
select distinct A.jobid, A.bill_rate, A.pay_rate from tblAssignments A
	where A.jobid is not null
	order by a.JobID

return

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ID]
      ,[AssignmentID]
      ,[PONumber]
      ,[JobID]
      ,[ClientID]
      ,[xxxClient_Name]
      ,[xxxContact]
      ,[ApplicantID]
      ,[xxxContact_Phone]
      ,[xxxAppl_First_Name]
      ,[xxxAppl_Last_Name]
      ,[xxxAppl_Middle_Name]
      ,[xxxAppl_Home_Phone]
      ,[xxxAppl_SSN]
      ,[xxxAppl_Cell_Phone]
      ,[Asgn_Status]
      ,[xxxApplicant_Status]
      ,[Job_Status]
      ,[Asgn_End_Date]
      ,[Asgn_Start_Date]
      ,[Asgn_End_Time]
      ,[Asgn_Start_Time]
      ,[Asgn_Total_Hours]
      ,[Dept]
      ,[Category]
      ,[Bill_Rate]
      ,[Pay_Rate]
      ,[Progress_Date]
      ,[upsize_ts]
  FROM [MHCBTRS_SQL].[dbo].[tblAssignments]
  
