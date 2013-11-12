:: #!/usr/bin/env bash
:: -- This is part 0 of the createmors process
@echo ^=======^> Beginning SQLSharp installation
:: The ^ is the DOS 'escape' character used to allow the 
:: redirection > character in the bat file echo (dumb DOS)
@echo off
cd C:/XYZ/DataLoad/

REM Initial setup
SET server_name="\SQLEXPRESS"
echo ^=======^> Servername = %server_name%

::This can only be run stand-alone, else causes hangs
echo ^=======^> Installing SQLSharp
sqlcmd -S %server_name% -i SQLSharp_SETUP.sql
cmd /X /D /C "restart_sqlserver"
echo ^=======^> Copying main tables
sqlcmd -S %server_name% -i Database_SETUP.sql

