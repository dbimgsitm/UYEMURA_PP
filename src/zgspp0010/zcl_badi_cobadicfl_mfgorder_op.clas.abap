CLASS zcl_badi_cobadicfl_mfgorder_op DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_cobadicfl_mfgorder_opr .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BADI_COBADICFL_MFGORDER_OP IMPLEMENTATION.


  METHOD if_cobadicfl_mfgorder_opr~modify_operations.
*  READ ENTITIES OF zi_batchcounting
*    ENTITY zi_batchcounting
*        ALL FIELDS WITH VALUE #( ( Id = '' ) )
*        RESULT DATA(LT_RESULT).

  ENDMETHOD.
ENDCLASS.
