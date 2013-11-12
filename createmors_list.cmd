@echo off
REM Using GNU/Grep
REM http://sourceforge.net/projects/gnuwin32/files/grep/2.5.4
grep -ive "(0 rows\|Changed database\|rows affected" createmors.out | less
