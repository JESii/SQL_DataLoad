@echo of
ECHO "=======>Creating timesheet tables"
sqlcmd -S %server_name% -i create_time_header.sql
sqlcmd -S %server_name% -i insert_time_header.sql
sqlcmd -S %server_name% -i create_timesheet_lines_view.sql
sqlcmd -S %server_name% -i create_time_entry.sql
sqlcmd -S %server_name% -i insert_time_entry.sql
echo "=======>Testing views"
sqlcmd -S %server_name% -i test_views.sql

