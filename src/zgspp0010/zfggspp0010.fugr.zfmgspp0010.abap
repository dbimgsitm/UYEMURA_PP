FUNCTION zfmgspp0010.
*"----------------------------------------------------------------------
*"*"로컬 인터페이스:
*"  IMPORTING
*"     REFERENCE(IS_PRODORDER) TYPE  ZTGSPP0010
*"  EXPORTING
*"     REFERENCE(EV_STATUS) TYPE  CHAR03
*"     REFERENCE(EV_MESSAGE) TYPE  STRING
*"----------------------------------------------------------------------
  DATA : lv_batch TYPE ztgspp0010-batch_count,
         lv_error TYPE c.

  DATA(ls_data) = is_prodorder.

  SELECT MAX( batch_count )
  FROM ztgspp0010
  WHERE material = @ls_data-material
   AND manufacturedate = @ls_data-manufacturedate
  INTO @DATA(lv_count).

  IF lv_count IS NOT INITIAL.
    lv_batch = lv_count + 1.

    UPDATE ztgspp0010
       SET batch_count = @lv_batch
     WHERE material = @ls_data-material
       AND manufacturedate = @ls_data-manufacturedate.

    IF sy-subrc NE 0.
      lv_error = 'X'.
    ENDIF.
  ELSE.
    ls_data-batch_count = 1.
    INSERT ztgspp0010 FROM @ls_data.
    "COMMIT WORK.

    IF sy-subrc NE 0.
      lv_error = 'X'.
    ENDIF.
  ENDIF.

  IF lv_error IS NOT INITIAL.
    ev_status = 'E'.
  ELSE.
    ev_status = 'S'.
  ENDIF.


ENDFUNCTION.
