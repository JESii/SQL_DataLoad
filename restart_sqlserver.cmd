@echo off
:: Stop/start SQL Server to avoid the hang
net stop "SQL Server (SQLEXPRESS)"
net start "SQL Server (SQLEXPRESS)"
:: Wait for 5 seconds; createmors2 complains not started
timeout 5
