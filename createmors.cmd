@echo off
REM Run the createmors process
@echo ^=======^> Start CREATEMORS process
SET /p reply=Have you installed SQLSharp for a new database (y/n)?:
IF "%reply%" == "y" GOTO:OK
@echo Exiting createmors; run createmors_sqlsharp.cmd
pause
GOTO:EOF
:OK
@echo ^=======^> Restarting SQL Server
cmd /X /D /C "restart_sqlserver"
@echo ^=======^> Starting CREATEMORS1 process
cmd /X /D /C "createmors1 > createmors.out"
@echo ^=======^> Restarting SQL Server
cmd /X /D /C "restart_sqlserver"
@echo ^=======^> Starting CREATEMORS2 process
cmd /X /D /C "createmors2 >> createmors.out"
@echo ^=======^> Finish CREATEMORS process
