CLASS zcl_po_batchhandler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS updatebatchcounting
      IMPORTING
        is_prodorder TYPE ztgspp0010
      EXPORTING
        ev_status    TYPE char03
        ev_message   TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PO_BATCHHANDLER IMPLEMENTATION.


  METHOD updatebatchcounting.

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

*      MODIFY ENTITIES OF zi_batchcounting
*        ENTITY zi_batchcounting
*        UPDATE
*        SET FIELDS WITH VALUE #( (
*                id = cl_system_uuid=>create_uuid_x16_static( )
*                material = is_prodorder-material
*                manufacturedate = confirmation-postingdate
*                batch_count = 0
*            ) )

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

  ENDMETHOD.
ENDCLASS.
