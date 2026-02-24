CLASS lhc_ZI_ASSETS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_assets RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_assets RESULT result.
    METHODS dardebaja FOR MODIFY
      IMPORTING keys FOR ACTION zi_assets~dardebaja RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_assets RESULT result.
    METHODS validatecategory FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_assets~validatecategory.
    METHODS validarstaus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_assets~validarstaus.
    METHODS setfechamod FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_assets~setfechamod.

ENDCLASS.

CLASS lhc_ZI_ASSETS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD darDeBaja.
    " 1. Leer los datos de los activos seleccionados
    READ ENTITIES OF zi_assets IN LOCAL MODE
      ENTITY zi_assets
        FIELDS ( status assignedto )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_assets).

    LOOP AT lt_assets ASSIGNING FIELD-SYMBOL(<ls_asset>).
      " 2. Validar si tiene un usuario asignado
      IF <ls_asset>-assignedto IS NOT INITIAL.
        " Si tiene usuario, enviamos un mensaje de error
        APPEND VALUE #( %tky = <ls_asset>-%tky ) TO failed-zi_assets.

        APPEND VALUE #( %tky = <ls_asset>-%tky
                        %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = |No se pude dar de baja: El activo asignado a { <ls_asset>-assignedto }|
                              )
                         ) TO reported-zi_assets.
        CONTINUE.
      ENDIF.

      " 3. Si no tiene usuario, cambiamos el estado
      MODIFY ENTITIES OF zi_assets IN LOCAL MODE
        ENTITY zi_assets
          UPDATE FIELDS ( status )
          WITH VALUE #( ( %tky = <ls_asset>-%tky status = 'B' ) ) " O el código que uses para baja
        REPORTED DATA(lt_reported).
    ENDLOOP.
*
*    " 4. Devolver el resultado para refrescar la UI
    READ ENTITIES OF zi_assets IN LOCAL MODE
      ENTITY zi_assets
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT lt_assets.

    result = VALUE #( FOR asset IN lt_assets ( %tky = asset-%tky %param = asset ) ).
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD validateCategory.

    READ ENTITIES OF zi_assets IN LOCAL MODE
        ENTITY zi_assets
        FIELDS ( category ) WITH CORRESPONDING #( keys )
        RESULT DATA(lti_assets).

    DATA lti_Categorias TYPE SORTED TABLE OF zcat_asset WITH UNIQUE KEY cat_id.

    lti_categorias = CORRESPONDING #( lti_assets DISCARDING DUPLICATES MAPPING cat_id = category EXCEPT * ).

    DELETE lti_categorias WHERE cat_id IS INITIAL.

    IF lti_categorias IS NOT INITIAL.
      SELECT FROM zcat_asset FIELDS cat_id
          FOR ALL ENTRIES IN @lti_categorias
          WHERE cat_id = @lti_categorias-cat_id
          INTO TABLE @DATA(lti_valid_cate).
    ENDIF.

    LOOP AT lti_assets INTO DATA(ls_asset).
    Data(lv_text) = value string( ).

      if ls_asset-category IS INITIAL.
        lv_text = |El campo categoria es obligatorio|.
      elseif not line_exists( lti_valid_cate[ cat_id = ls_asset-category ] ).
        lv_text = |La categoria '{ ls_asset-category }' no es valida. Seleccie una el mach code|.
      endIF.
      IF lv_text IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_asset-%tky ) TO failed-zi_assets.


        APPEND VALUE #( %tky = ls_asset-%tky
                        %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = lv_text
                              )
                         ) TO reported-zi_assets.


      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validarStaus.

      READ ENTITIES OF zi_assets IN LOCAL MODE
        ENTITY zi_assets
        FIELDS ( status ) WITH CORRESPONDING #( keys )
        RESULT DATA(lti_assets).
    DATA lti_status TYPE SORTED TABLE OF zi_status_vh WITH UNIQUE KEY domain_name.

    lti_status = CORRESPONDING #( lti_assets DISCARDING DUPLICATES MAPPING Status = status EXCEPT * ).

   DELETE lti_status WHERE Status IS INITIAL.

   IF lti_status IS NOT INITIAL.
      SELECT FROM zi_status_vh FIELDS Status
          FOR ALL ENTRIES IN @lti_status
          WHERE Status = @lti_status-Status
          INTO TABLE @DATA(lti_valid_staus).
    ENDIF.

   LOOP AT lti_assets INTO DATA(ls_asset).
    Data(lv_text) = value string( ).

      if ls_asset-status IS INITIAL.
        lv_text = |El campo estado es obligatorio|.
      elseif not line_exists( lti_valid_staus[ Status = ls_asset-status ] ).
        lv_text = |El estado '{ ls_asset-status }' no es valido|.
      endIF.
      IF lv_text IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_asset-%tky ) TO failed-zi_assets.


        APPEND VALUE #( %tky = ls_asset-%tky
                        %msg = new_message_with_text(
                                severity = if_abap_behv_message=>severity-error
                                text     = lv_text
                              )
                         ) TO reported-zi_assets.


      ENDIF.
    ENDLOOP.


  ENDMETHOD.

METHOD setFechaMod.
    READ ENTITIES OF zi_assets IN LOCAL MODE
        ENTITY zi_assets
        FIELDS ( fechamod ) WITH CORRESPONDING #( keys )
        RESULT DATA(lti_assets).
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).
    DELETE lti_assets whERE fechamod = lv_today.
    CHECK lti_assets IS NOT INITIAL.
    MODIFY ENTITIES OF zi_assets IN LOCAL MODE
           ENTITY zi_assets
           UPDATE FIELDS ( fechamod )
           WITH VALUE #( FOR ls_asset in lti_assets (
                %tky = ls_asset-%tky
                fechamod = lv_today
            ) )
            REPORTED DATA(lti_update_rep).

    reported = CORRESPONDING #( DEEP lti_update_rep ).
ENDMETHOD.

ENDCLASS.
