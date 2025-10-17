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

echo Beginning Validations Tables


echo Completed Create Validations Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Execution Failed - Stopping!
rem ---------------------------------------------------------------------------
:exception
echo Create Validations Failed!
exit /b 1
