/*
 * test loss of data in mors_time_entry
 *	Counts drop off when joining mors_time_header
 */
USE [XYZBTRS_SQL]

 select COUNT(*),'MEX' from mors_employee_xref
 select COUNT(*),'MC' from mors_contract 
 select COUNT(*),'MTH' from mors_time_header 
 select COUNT(*),'V - exclude NULL PONumber' from tblVisits V
	where V.PONumber is not null	
 select COUNT(*),'V - join POSC on Jobid' from tblVisits V
    JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
 select COUNT(*),'V - join POSC on Jobid, MEX on name' from tblVisits V
    JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
 select COUNT(*),'V - join POSC on Jobid,  MEX on name, MC on POS #' from tblVisits V
    JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	JOIN mors_contract MC ON V.PONumber = MC.pos_authorization_number
select COUNT(*),'V - join POSC on Jobid,  MEX on name, MC on POS #, MTH on E#, MC.id, PIDate' from tblVisits V
    JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	JOIN mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
			AND MTH.contract_id = MC.id AND CONVERT(VARCHAR(10), MTH.BTRS_progress_date,111) = CONVERT(VARCHAR(10), V.Progress_Date, 111)
SELECT V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date, PC.PONumber AS pos_number, V.ClientID AS client_number, MEX.employee_id
	,MEX.BTRS_full_name AS appl_full_name, MC.id as contract_id, MTH.id as time_header_id
	,CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time
	,V.pay_hours
	FROM  dbo.tblVisits AS V 
    JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
			AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)
GO
select * from mors_time_header MTH
	order by mth.contract_id -- mth.BTRS_employee_number
select * from mors_contract MC
	order by MC.id
select * from mors_employee_xref MEX
	order by  mex.BTRS_employee_number
