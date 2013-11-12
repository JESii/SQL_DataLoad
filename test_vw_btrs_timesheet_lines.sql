PRINT '==> [vw_btrs_timesheet_lines]'
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
	
-------------------
PRINT '==> [vw_btrs_timesheet_lines] less mors_time_header'
SELECT V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date, PC.PONumber AS pos_number, V.ClientID AS client_number, MEX.employee_id
	,MEX.BTRS_full_name AS appl_full_name, MC.id as contract_id --, MTH.id as time_header_id
	,CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time
	,V.pay_hours
	FROM  dbo.tblVisits AS V 
  JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	--JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
	--		AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)
-----------------------
PRINT '==> [vw_btrs_timesheet_lines] less mors_time_header & mors_contract'

SELECT V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date, PC.PONumber AS pos_number, V.ClientID AS client_number, MEX.employee_id
	,MEX.BTRS_full_name AS appl_full_name --, MC.id as contract_id --, MTH.id as time_header_id
	,CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time
	,V.pay_hours
	FROM  dbo.tblVisits AS V 
  JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	--JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	--JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
	--		AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)	
-----------------------
PRINT '==> [vw_btrs_timesheet_lines] less mors_time_header & mors_contract & mors_employee_xref'

SELECT V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date, PC.PONumber AS pos_number, V.ClientID AS client_number --, MEX.employee_id
	--,MEX.BTRS_full_name AS appl_full_name --, MC.id as contract_id --, MTH.id as time_header_id
	,CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time
	,V.pay_hours
	FROM  dbo.tblVisits AS V 
  JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	--JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	--JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	--JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
	--		AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)		
----------------
PRINT '==> tblVisits ([vw_btrs_timesheet_lines] less mors_time_header & mors_contract & mors_employee_xref & POSContracts'

SELECT V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date --, PC.PONumber AS pos_number
	, V.ClientID AS client_number --, MEX.employee_id
	--,MEX.BTRS_full_name AS appl_full_name --, MC.id as contract_id --, MTH.id as time_header_id
	,CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time
	,V.pay_hours
	FROM  dbo.tblVisits AS V 
  --JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	--JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	--JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	--JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
	--		AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (V.PONumber IS NOT NULL)	

-----------
PRINT '==> tblVisits with NULL POS Numbers'
SELECT * from tblVisits V where V.PONumber IS NULL

-----------
PRINT '==> tblVisits with un-matched Job Numbers'
SELECT * from tblVisits V 
	left join tblPOSContracts PC ON PC.JobID = V.JobID
	where V.PONumber IS NULL
-----------
PRINT '==> tblVisits all items'
SELECT * from tblVisits

/*
 * Following look at which records are excluded in each join
 */
 
PRINT '==> Missing POSContracts items'
SELECT 'POSContracts'
	,V.VisitID, CONVERT(varchar(10), V.Progress_Date,111) as progress_date,  V.JobID,  V.ClientID AS client_number,V.xxxApplicant_Name, CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time, V.pay_hours
  ,PC.PONumber AS PC_PONumber
  /*
  ,MEX.employee_id AS MEX_EeID ,MEX.BTRS_full_name AS MEX_Name
  ,MC.id as contract_id
  ,MTH.id as time_header_id
  */
	FROM  dbo.tblVisits AS V 
  LEFT JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
  /*
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
	JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
			AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)
  */
  WHERE PC.PONumber IS NULL

PRINT '==> Missing Employee Xref items'
SELECT 'EmployeeXREF'
	,V.VisitID, CONVERT(varchar(10),V.Progress_Date,111) as progress_date,  V.JobID,  V.ClientID AS client_number,V.xxxApplicant_Name, CONVERT(varchar(10), V.Work_Date,111) as visit_date, CONVERT(time(0), V.Start_Time,108) as visit_start_time, CONVERT(time(0), v.End_Time,108) as visit_end_time, V.pay_hours
  ,PC.PONumber AS PC_PONumber
  ,MEX.employee_id AS MEX_EeID ,MEX.BTRS_full_name AS MEX_Name
  /*
  ,MC.id as contract_id
  ,MTH.id as time_header_id
  */
	FROM  dbo.tblVisits AS V 
  LEFT JOIN dbo.tblPOSContracts AS PC ON PC.JobID = V.JobId
	JOIN dbo.mors_employee_xref AS MEX ON dbo.fn_collapse_name(V.xxxApplicant_Name) = MEX.BTRS_match_name
  /*
	JOIN dbo.mors_contract as MC ON V.PONumber = MC.pos_authorization_number
	JOIN dbo.mors_time_header AS MTH ON MTH.BTRS_employee_number = MEX.BTRS_employee_number
			AND MTH.contract_id = MC.id AND MTH.BTRS_progress_date = V.Progress_Date
	WHERE     (PC.PONumber IS NOT NULL)
  */
  WHERE PC.PONumber IS NULL OR MEX.employee_id IS NULL
