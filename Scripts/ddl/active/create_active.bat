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

psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "bundle.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "bundle_item.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "coupon.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "coupon_usage.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "customer.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "feature.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "pricing.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "pricing_schedule_mapping.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "pricing_tier.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "product.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "product_category.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "product_feature_mapping.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "product_service_details.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "rt_type.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "rt_values.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "schedule_rule.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "service_order.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "subscription_plan.sql" || goto exception  
psql -d norpac -v ON_ERROR_STOP=ON -h %PGHOST% -p %PGPORT% -f "tenant.sql" || goto exception  

echo Completed Create Active Functions Successfully
exit /b 0

rem ---------------------------------------------------------------------------
rem Execution Failed - Stopping!
rem ---------------------------------------------------------------------------
:exception
echo Create Active Functions Failed!
exit /b 1
