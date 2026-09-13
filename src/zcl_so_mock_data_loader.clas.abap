CLASS zcl_so_mock_data_loader DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_so_mock_data_loader IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zso_head.
    DELETE FROM zso_items.

    INSERT zso_head FROM TABLE @( VALUE #(
      ( vbeln = '0000000001' kunnr = '0000100001' netwr = '12500.00' waerk = 'USD' erdat = '20260820' )
      ( vbeln = '0000000002' kunnr = '0000100002' netwr = '3200.00'  waerk = 'USD' erdat = '20260820' )
      ( vbeln = '0000000003' kunnr = '0000100003' netwr = '7800.00'  waerk = 'USD' erdat = '20260820' )
    ) ).

    INSERT zso_items FROM TABLE @( VALUE #(
      ( vbeln = '0000000001' posnr = '000010' matnr = 'M-1001' kwmeng = '50.000' meins = 'EA' werks = '1010' )
      ( vbeln = '0000000001' posnr = '000020' matnr = 'M-1002' kwmeng = '20.000' meins = 'EA' werks = '1010' )
      ( vbeln = '0000000002' posnr = '000010' matnr = 'M-2001' kwmeng = '10.000' meins = 'EA' werks = '1020' )
      ( vbeln = '0000000003' posnr = '000010' matnr = 'M-3001' kwmeng = '30.000' meins = 'EA' werks = '1010' )
      ( vbeln = '0000000003' posnr = '000020' matnr = 'M-3002' kwmeng = '15.000' meins = 'EA' werks = '1030' )
    ) ).

    out->write( 'Mock Sales Order data loaded.' ).

  ENDMETHOD.

ENDCLASS.
