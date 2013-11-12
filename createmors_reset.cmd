:: -- This is part 0 of the createmors process
@echo ^=======^> Beginning Database reset
:: The ^ is the DOS 'escape' character used to allow the 
:: redirection > character in the bat file echo (dumb DOS)
@echo off
cd C:/XYZ/DataLoad/

REM Initial setup
SET server_name="\SQLEXPRESS"
echo ^=======^> Servername = %server_name%

::This can only be run stand-alone, else causes hangs
echo ^=======^> Resetting the database to initial status
sqlcmd -S %server_name% -i Database_Reset.sql
cmd /X /D /C "restart_sqlserver"
