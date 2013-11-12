:: Following demonstrates that sqlcmd returns 0 even after error
@echo off
echo "command 1"
sqlcmd -S "\SQLEXPRESS" -i test.sql || goto :error
echo %errorlevel%
echo "command 2"
sqlcmd -S "\SQLEXPRESS" -i test.sql || goto :error
echo %errorlevel%

goto :EOF
:error
echo ^========================^> Failed with error #%errorlevel%.
exit /b %errorlevel%
