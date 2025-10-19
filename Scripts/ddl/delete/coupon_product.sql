-- -------------------------------------------------------
-- Delete coupon_product
-- ------------------------------------------------------
DROP FUNCTION IF EXISTS norpac_commons.d_coupon_product;
CREATE FUNCTION norpac_commons.d_coupon_product(
  IN p_id_product UUID, 
  IN p_id_coupon UUID
)
RETURNS norpac_commons.pg_resp
AS $$
DECLARE

  c_service_name TEXT := 'd_coupon_product';

  v_metadata     JSONB := '{}'::JSONB;
  v_response     norpac_commons.pg_resp;
  v_message      TEXT;  
  v_updates      INT;
  v_count        INT;

  -- Primary Key Field(s)
  v_id_coupon uuid := p_id_coupon;
  v_id_product uuid := p_id_product;
    
BEGIN

  -- ------------------------------------------------------
  -- Metadata
  -- ------------------------------------------------------

  v_metadata := jsonb_build_object(
    'id_product', p_id_product, 
    'id_coupon', p_id_coupon
  );
  
  -- ------------------------------------------------------
  -- Delete
  -- ------------------------------------------------------

  DELETE FROM norpac_commons.coupon_product 
    WHERE id_coupon = v_id_coupon
      AND id_product = v_id_product
  ;
  GET DIAGNOSTICS v_updates = ROW_COUNT;

  IF v_updates > 0 THEN
    -- Record was deleted
    v_response := (
      'OK', 
      jsonb_build_object('id_coupon', v_id_coupon, 'id_product', v_id_product), 
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

