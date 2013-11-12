@echo off
REM #!/usr/bin/env bash
REM REM -- This is part 2 of the createmors process
@echo ^=======^> Beginning part 2 of the CREATEMORS process
REM The ^ is the DOS 'escape' character used to allow the 
REM redirection > character in the bat file echo (dumb DOS)
cd C:/XYZ/DataLoad/

REM Initial setup
SET server_name="\SQLEXPRESS"
echo ^=======^> Servername = %server_name%
echo ^=======^>Creating remittance files/tables
sqlcmd -S %server_name% -i create_remittance.sql
sqlcmd -S %server_name% -i insert_remittance.sql
sqlcmd -S %server_name% -i update_client_uci_no.sql

echo ^=======^> Exporting various test/validation files
sqlcmd -S %server_name% -i export_visits_NullPOJobNumbers.sql
echo ^=======^> Final statistics
sqlcmd -S %server_name% -i print_table_stats.sql
