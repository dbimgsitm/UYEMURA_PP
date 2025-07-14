CLASS zcl_badi_workorder_gdsmovt_bkf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_workorder_goodsmovt_bkf_gdr .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA zfmgspp0010 TYPE string VALUE 'zfmgspp0010'.
ENDCLASS.



CLASS ZCL_BADI_WORKORDER_GDSMOVT_BKF IMPLEMENTATION.


  METHOD if_workorder_goodsmovt_bkf_gdr~modify_goods_movement.

    DATA : lv_batchnum TYPE n LENGTH 2,
           lv_batch    TYPE c LENGTH 8,
           lv_max      TYPE c LENGTH 8,
           lv_day      TYPE c LENGTH 2,
           lv_month    TYPE c LENGTH 2,
           lv_year     TYPE c LENGTH 2.

* CO01
    lv_day = confirmation-postingdate+6(2).
    lv_month = confirmation-postingdate+4(2).
    lv_year = confirmation-postingdate+2(2).
    DATA(lv_manufacturedate) = |{ lv_day }{ lv_month }{ lv_year }|.

    LOOP AT goods_movements REFERENCE INTO DATA(lr_goods).
*   오더번호, 이동유형 101인 경우만
      IF order_header-ordernumber IS NOT INITIAL AND lr_goods->goodsmovementtype EQ '101'.

        SELECT batch, material, manufacturedate
          FROM i_batch WITH PRIVILEGED ACCESS
         WHERE material = @lr_goods->material
           AND manufacturedate = @confirmation-postingdate
          INTO TABLE @DATA(lt_checkdata).

        IF sy-subrc NE 0.

          lv_batch = |{ lv_manufacturedate }01|.

        ELSE.
          LOOP AT lt_checkdata INTO DATA(ls_checkdata).
            IF strlen( ls_checkdata-batch ) = 8 AND ls_checkdata-batch+0(6) = lv_manufacturedate AND ls_checkdata-batch+6(2) >= '01' AND ls_checkdata-batch+6(2) <= '99'.
              IF ( ls_checkdata-batch > lv_max ).
                lv_max = ls_checkdata-batch.
                lv_batchnum = CONV i( ls_checkdata-batch+6(2) ) + 1.
                lv_batch = |{ ls_checkdata-batch+0(6) }{ lv_batchnum }|.
              ENDIF.
            ELSE.
              lv_batch = |{ lv_manufacturedate }01|.
            ENDIF.
          ENDLOOP.

        ENDIF.

        lr_goods->batch = lv_batch.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
