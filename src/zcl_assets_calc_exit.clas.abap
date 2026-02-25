CLASS zcl_assets_calc_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
ENDCLASS.

CLASS zcl_assets_calc_exit IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
    " 1. Castear los datos recibidos a la estructura de tu proyección
    DATA lt_assets TYPE STANDARD TABLE OF zc_assets WITH DEFAULT KEY.
    lt_assets = CORRESPONDING #( it_original_data ).

    " 2. Lógica de cálculo para cada fila
    LOOP AT lt_assets ASSIGNING FIELD-SYMBOL(<ls_asset>).
        Data fech_aa type d .
         fech_aa = cl_abap_context_info=>get_system_date( ) - 365.
      IF <ls_asset>-fechamod < fech_aa.
        <ls_asset>-EstadoCritico = 'REVISIÓN URGENTE'.
        <ls_asset>-criticalityCode = 1.
      ELSE.
        <ls_asset>-EstadoCritico = 'AL DÍA'.
        <ls_asset>-criticalityCode = 3.
      ENDIF.

    ENDLOOP.

    " 3. Devolver los datos calculados
    ct_calculated_data = CORRESPONDING #( lt_assets ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    " Aquí le decimos al sistema qué campos necesitamos para el cálculo
    IF line_exists( it_requested_calc_elements[ table_line = 'ESTADOCRITICO' ] ).
      APPEND 'FECHAMOD' TO et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
