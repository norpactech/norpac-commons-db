@echo off
rem ----------------------------------------------------------------------------
rem © 2025 Northern Pacific Technologies, LLC. All Rights Reserved. 
rem 
rem See LICENSE file in the project root for full license information.
rem
rem To capture all psql output use the following command:
rem  tester.bat > tester.log 2>&1
rem
rem ---------------------------------------------------------------------------

if not defined PGHOST (
  set PGHOST=localhost
)

if not defined PGPORT (
  set PGPORT=5432
)

echo Beginning Create Active Functions


echo Completed Create Active Functions Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Execution Failed - Stopping!
rem ---------------------------------------------------------------------------
:exception
echo Create Active Functions Failed!
exit /b 1
