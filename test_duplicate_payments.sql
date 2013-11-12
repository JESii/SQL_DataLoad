
/*
 * Potential duplicate payments
 */
use XYZBTRS_SQL 
/*
-- NOTE the different method of calculating 'candidate visits'
 DECLARE @tmp INT = (SELECT count(*) 
        FROM (SELECT  PC.PONumber, V.Progress_Date, REPLACE(V.xxxApplicant_Name,'"','') as appl_name, V.Work_Date 
				FROM tblVisits V
				JOIN tblPOSContracts AS PC ON PC.JobId = V.JobID
					WHERE PC.PONumber IS NOT NULL
					  AND V.Pay_Hours <> 0
					  and v.JobId is not null
      ) Z )
PRINT '==> ' + CONVERT(varchar(10), @tmp) + ' candidate rows in tblVisits'

select COUNT(*), 'Visits candidate rows' as ttl from tblVisits V
	join tblPOSContracts PC on PC.JobID = v.JobId
	where v.Pay_Hours <> 0 
	  and v.PONumber is not null 
	  and v.JobId is not null
-- End of this stuff	
*/  
select PONumber, REPLACE(V.xxxApplicant_Name,'"','') as Applicant_Name, v.Work_Date, sum(v.pay_hours) as sumph, max(v.pay_hours) as maxph, COUNT(*) as visit_count from tblVisits V
	where v.pay_hours <> 0.0 and v.PONumber is not null and v.JobId is not null
	group by PONumber, REPLACE(V.xxxApplicant_Name,'"',''), v.Work_Date
	having COUNT(*) > 1 and sum(v.pay_hours) > 0.0 and SUM(v.pay_hours) <> max(v.pay_hours)
		and MIN(v.Start_Time) = MAX(v.start_time) and MIN(v.End_Time) = MAX(v.End_Time)
	order by PONumber, REPLACE(V.xxxApplicant_Name,'"',''), v.Work_Date
select * from tblVisits v where v.VisitID in ( select V.visitid from tblVisits V
	join (select PONumber, REPLACE(V.xxxApplicant_Name,'"','') as Applicant_Name, v.Work_Date, COUNT(*) as visit_count from tblVisits V
	where v.pay_hours <> 0.0 and v.PONumber is not null and v.JobId is not null
	group by PONumber, REPLACE(V.xxxApplicant_Name,'"',''), v.Work_Date
	having COUNT(*) > 1 and sum(v.pay_hours) > 0.0 and SUM(v.pay_hours) <> max(v.pay_hours)
					    and MIN(v.Start_Time) = MAX(v.start_time) and MIN(v.End_Time) = MAX(v.End_Time)) Z 
				on z.Applicant_Name = REPLACE(V.xxxApplicant_Name,'"','')
				and z.PONumber = v.PONumber
				and z.Work_Date = v.Work_Date)
	and v.pay_hours <> 0.0 and v.PONumber is not null and v.JobId is not null			
	order by v.PONumber, REPLACE(V.xxxApplicant_Name,'"',''), v.Work_Date					

	
select * from tblVisits v where v.PONumber = 99999999 and v.xxxApplicant_Name = 'Doe, John ' 
	and v.Work_Date in ('2012-12-05 00:00:00.000', '2012-12-07 00:00:00.000', '2012-12-04 00:00:00.000','2012-12-03 00:00:00.000','2012-12-06 00:00:00.000')
	order by Work_Date
