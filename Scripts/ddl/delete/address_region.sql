-- -------------------------------------------------------
-- Delete address_region
-- ------------------------------------------------------
DROP FUNCTION IF EXISTS norpac_commons.d_address_region;
CREATE FUNCTION norpac_commons.d_address_region(
  IN p_id_address UUID, 
  IN p_id_region UUID
)
RETURNS norpac_commons.pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'd_address_region';

  v_metadata     JSONB := '{}'::JSONB;
  v_response     norpac_commons.pg_resp;
  v_message      TEXT;  
  v_updates      INT;
  v_count        INT;

  -- Primary Key Field(s)
  v_id_address uuid := p_id_address;
  v_id_region uuid := p_id_region;
    
BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_address', p_id_address, 
    'id_region', p_id_region
  );
  
  -- ------------------------------------------------------
  -- Delete
  -- ------------------------------------------------------

  DELETE FROM norpac_commons.address_region 
    WHERE id_address = v_id_address
      AND id_region = v_id_region
  ;
  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    -- Record was deleted
    v_response := (
      'OK', 
      jsonb_build_object('id_address', v_id_address, 'id_region', v_id_region), 
      NULL, 
      '00000',
      'Delete was successful', 
      NULL, 
      NULL
    );
    CALL norpac_commons.i_logs('INFO', v_response.message, c_service_name, 'unknown', v_metadata);    
  ELSE  
      -- Record does not exist
      v_response := (
        'ERROR', 
        NULL, 
        NULL, 
        '00002',
        'No records were found matching the query.',
        'Check the query parameters or ensure data exists.',
        'The requested resource does not exist in the database.'          
      );
      CALL norpac_commons.i_logs(v_response.status, v_response.message, c_service_name, 'unknown', v_metadata);
  END IF;    

  RETURN v_response;
 
  -- ------------------------------------------------------
  -- Exceptions
  -- ------------------------------------------------------
  
  EXCEPTION
    WHEN OTHERS THEN
      v_response := (
        'ERROR', 
        NULL, 
        NULL, 
        SQLSTATE, 
        'An unexpected error occurred', 
        'Check database logs for more details', 
        SQLERRM
      );
      CALL norpac_commons.i_logs(v_response.status, v_response.message, c_service_name, 'unknown', v_metadata);
      RETURN v_response;
  
END;
$$ LANGUAGE plpgsql;

