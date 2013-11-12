:: #!/usr/bin/env bash
:: -- This is part 1 of the createmors process
@echo ^=======^> Beginning part 1 of the CREATEMORS process
:: The ^ is the DOS 'escape' character used to allow the 
:: redirection > character in the bat file echo (dumb DOS)
@echo off
cd C:/XYZ/DataLoad/

:: Initial setup
SET server_name="\SQLEXPRESS"
echo ^=======^> Servername = %server_name%

::This must have previously been installed; causes hangs otherwise
::sqlcmd -S %server_name% -i SQLSharp_SETUP.sql

@echo off
sqlcmd -S %server_name% -i create_1Tfn_collapse_name.sql
sqlcmd -S %server_name% -i create_1Tproc_bcp_columns.sql
sqlcmd -S %server_name% -i create_1Tfn_split_names.sql

:: Make sure we can use xp_cmdshell
sqlcmd -S %server_name% -i "1T_configure_xp_cmdshell.sql"

echo ^=======^> Applying cleanup_tables
sqlcmd -S %server_name% -i cleanup_tables.sql
echo ^=======^> Applying apply_assignments_fixup
sqlcmd -S %server_name% -i apply_assignments_fixup.sql
echo ^=======^> Applying pos_fixup data from JohnDoe1's s/sheet
sqlcmd -S %server_name% -i create_pos_fixup_table.sql
sqlcmd -S %server_name% -i apply_pos_fixup_data.sql
echo ^=======^> Applying JohnDoe2's jobid fixup data (see apply_job_id_fixup_data.out)
echo ^=======^> NOTE1: Use allotted hours from "2+ clients" worksheet
echo ^=======^> NOTE2: Update client name when merging jobs.
echo ^////////////// Running ruby create_jobid_updates.rb > apply_jobid_fixup_data.out
ruby create_jobid_updates.rb "Duplicate POSs Completed Set_V2013_01_30.xls" >> apply_jobid_fixup_data.out
echo ^////////////// Running sqlcmd apply_jobid_fixup_data.sql >> apply_jobid_fixup_data.out
sqlcmd -S %server_name% -i apply_jobid_fixup_data.sql >> apply_jobid_fixup_data.out
:::: Not needed; applied directly below
:: echo ^=======^> Creating Job2POS Fixup View
:: sqlcmd -S %server_name% -i create_job2pos_fixup_view.sql
echo ^=======^> Applying Job2POS Fixup Changes
sqlcmd -S %server_name% -i apply_job2pos_fixups.sql

sqlcmd -S %server_name% -i export_clients.sql
ruby create_client_xref.rb export_clients.txt
sqlcmd -S %server_name% -i create_client_xref.sql
sqlcmd -S %server_name% -i insert_client_xref.sql
@echo off
:: Create the primary views
ECHO ^=======^> Creating primary views
sqlcmd -S %server_name% -i create_contracts_views.sql
sqlcmd -S %server_name% -i create_jobs_views.sql
sqlcmd -S %server_name% -i create_workers_views.sql
echo ^////////////// Running sqlcmd apply_jobid_fixup_deletions.sql >> apply_jobid_fixup_data.out
sqlcmd -S %server_name% -i apply_jobid_fixup_deletions.sql >> apply_jobid_fixup_data.out
ECHO ^=======^> Creating client tables
sqlcmd -S %server_name% -i create_client.sql
sqlcmd -S %server_name% -i insert_client.sql
ECHO ^=======^> Creating contract tables
sqlcmd -S %server_name% -i create_job_rates.sql
sqlcmd -S %server_name% -i insert_job_rates.sql
sqlcmd -S %server_name% -i create_contract.sql
sqlcmd -S %server_name% -i insert_contract.sql
sqlcmd -S %server_name% -i create_contract_job.sql
sqlcmd -S %server_name% -i insert_contract_job.sql
sqlcmd -S %server_name% -i update_contract_dates.sql
ECHO ^=======^> Creating employee tables
sqlcmd -S %server_name% -i create_employee.sql
sqlcmd -S %server_name% -i insert_employee.sql
sqlcmd -S %server_name% -i create_employee_xref.sql
sqlcmd -S %server_name% -i insert_employee_xref.sql
sqlcmd -S %server_name% -i create_employee_assignment.sql
sqlcmd -S %server_name% -i insert_employee_assignment.sql
ECHO ^=======^> Creating timesheet views
sqlcmd -S %server_name% -i create_timesheets_view.sql
ECHO ^=======^> Creating timesheet tables
sqlcmd -S %server_name% -i create_time_header.sql
sqlcmd -S %server_name% -i insert_time_header.sql
sqlcmd -S %server_name% -i create_timesheet_lines_view.sql
sqlcmd -S %server_name% -i create_time_entry.sql
sqlcmd -S %server_name% -i insert_time_entry.sql
echo ^=======^> Testing views
sqlcmd -S %server_name% -i test_views.sql
echo ^======^> Parsing remittance files
ruby process_remittances.rb "c:/XYZ/accounting" >remittance.out
