CLASS zcl_badi_item_provide_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mmim_item_provide_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BADI_ITEM_PROVIDE_DATA IMPLEMENTATION.


  METHOD if_mmim_item_provide_data~change.
* MIGO
    DATA : lv_batchnum TYPE n LENGTH 2,
           lv_batch    TYPE c LENGTH 8,
           lv_max      TYPE c LENGTH 8,
           lv_day      TYPE c LENGTH 2,
           lv_month    TYPE c LENGTH 2,
           lv_year     TYPE c LENGTH 2.

    lv_day = header-postingdate+6(2).
    lv_month = header-postingdate+4(2).
    lv_year = header-postingdate+2(2).
    DATA(lv_manufacturedate) = |{ lv_day }{ lv_month }{ lv_year }|.

*   오더번호, 이동유형 101인 경우만
    IF item-manufacturingorder IS NOT INITIAL AND item-goodsmovementtype EQ '101'.

      SELECT batch, material, manufacturedate
        FROM i_batch WITH PRIVILEGED ACCESS
       WHERE material = @item-material
         AND manufacturedate = @header-postingdate
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

      change_item-batch = lv_batch.
      change_item-manufacturedate = header-postingdate.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
