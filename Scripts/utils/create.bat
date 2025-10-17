@ECHO OFF
REM ----------------------------------------------------------------------------
REM © 2025 Northern Pacific Technologies, LLC.
REM 
REM See LICENSE file in the project root for full license information.
REM
REM To capture all psql output use the following command:
REM  tester.bat > tester.log 2>&1
REM
REM ---------------------------------------------------------------------------

IF NOT DEFINED PGHOST (
  SET PGHOST=localhost
)

IF NOT DEFINED PGPORT (
  SET PGPORT=5432
)

REM 1) norpac user must already exist in the database
REM    ... CREATE ROLE norpac WITH SUPERUSER LOGIN PASSWORD 'CHANGEME';
REM 2) norpac database must already exist in the database
REM    ... CREATE DATABASE norpac OWNER norpac;

SET PGUSER=norpac

SET PGHOST=v02.norpactech.com
SET PGPASSWORD=CHANGEME!

REM SET PGHOST=localhost
REm PGPASSWORD=password

ECHO Beginning Global Definitions
REM goto start
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f ".\bootstrap.sql" || goto exception

CD ..\ddl\table
CALL create_table.bat || goto exception
CD ..\..\utils

CD ..\ddl\validation
CALL create_validation.bat || goto exception
CD ..\..\utils

CD ..\ddl\insert
CALL create_insert.bat || goto exception
CD ..\..\utils

CD ..\ddl\update
CALL create_update.bat || goto exception
CD ..\..\utils

CD ..\ddl\delete
CALL create_delete.bat || goto exception
CD ..\..\utils

CD ..\ddl\active
CALL create_active.bat || goto exception
CD ..\..\utils

psql -d norpac -h %PGHOST% -p %PGPORT% -f ".\views.sql" || goto exception

REM See pareto-factory-db for user definitions

ECHO Create Completed Successfully
EXIT /b 0

REM ---------------------------------------------------------------------------
REM Exception! Stopping Execution
REM ---------------------------------------------------------------------------
:exception
ECHO Create Failed!
EXIT /b 1
