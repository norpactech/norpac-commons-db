-- --------------------------------------------------------------------------------------
-- Validate us_phone - United State Phone without Extension
-- --------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS norpac_commons.is_us_phone;
CREATE FUNCTION norpac_commons.is_us_phone(
  IN in_attribute TEXT,
  IN in_value     TEXT
) 
RETURNS norpac_commons.pg_val
AS $$
DECLARE

  v_result pareto.pg_val;

BEGIN
  
  -- -------------------------------------------
  -- Null validations are checked elsewhere
  -- -------------------------------------------
  IF (in_value IS NULL) THEN
    v_result := (TRUE, in_attribute, NULL);
    return v_result;
  END IF;

  IF (in_value ~ '^\d{3}-\d{3}-\d{4}$') THEN
    v_result := (TRUE, in_attribute, NULL);
  ELSE
    v_result := (FALSE, in_attribute, 'Invalid US Phone. Only ###-###-#### is Valid');
  END IF;

  RETURN v_result;

END;
$$ LANGUAGE plpgsql;


