*&---------------------------------------------------------------------*
*& Include          /BSH4/BC_TMS_NSP_LCL
*&---------------------------------------------------------------------*
CLASS lcl_events DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS:

      on_toolbar_function_selected FOR EVENT function_selected OF if_salv_gui_toolbar_ida
        IMPORTING
          ev_fcode
          sender,

      convert_range
        IMPORTING it_seltab         TYPE if_salv_service_types=>yt_named_ranges
        RETURNING VALUE(sql_string) TYPE string.

ENDCLASS.

CLASS lcl_events IMPLEMENTATION.
METHOD convert_range.


*    data lt_grouped_range type sorted table of cl_salv_stu_grouped_range=>ys_grouped_range with unique key field_path.
*    data ls_grouped_range like line of lt_grouped_range.
*    data ls_selopt type line of cl_salv_stu_grouped_range=>ys_grouped_range-t_selopt.
*
*    clear et_grouped_range.
*    loop at it_plain_range assigning field-symbol(<s_plain_range>).
*      move-corresponding <s_plain_range> to ls_selopt.
*      read table lt_grouped_range assigning field-symbol(<s_grouped_range>) with table key field_path = <s_plain_range>-name.
*      if sy-subrc = 0.
*        append ls_selopt to <s_grouped_range>-t_selopt.
*      else.
*        clear ls_grouped_range.
*        ls_grouped_range-column_name = ls_grouped_range-field_path = <s_plain_range>-name.
*        append ls_selopt to ls_grouped_range-t_selopt.
*        insert ls_grouped_range into table lt_grouped_range.
*      endif.
*    endloop.
*    et_grouped_range = lt_grouped_range.



*  CALL FUNCTION 'FREE_SELECTIONS_RANGE_2_WHERE'
*    EXPORTING
*      field_ranges  = t_selopt_obj
*    IMPORTING
*      where_clauses = it_where.

endmethod.

  METHOD on_toolbar_function_selected.

    DATA t_tadir TYPE HASHED TABLE OF tadir WITH UNIQUE KEY pgmid object obj_name.

    CASE ev_fcode.
* wenn Button-Funktion
      WHEN 'POPUP'.


      WHEN c_button_save.
        " Popup to enter New SourceSystem
        CALL SELECTION-SCREEN 100 STARTING AT 10 5 ENDING AT 100 20.
        CHECK sy-subrc = 0 AND p_srcsys IS NOT INITIAL.
        SELECT tadir~*
               FROM tadir JOIN /bsh4/bc_cds_nsp_obj AS nsp
                 ON tadir~pgmid = nsp~pgmid
                AND tadir~object = nsp~object
                AND tadir~obj_name = nsp~obj_name
              WHERE nsp~pgmid IN @pgmid
                AND nsp~object IN @object
                AND nsp~obj_name IN @obj_name
                AND namespace IN @nsp
                AND nsp~srcsystem IN @srcsys
                AND nsp~srcsystem <> @p_srcsys
                AND role IN @role
                AND sscrflag IN @sscrflag
                AND changeuser IN @chuser
                AND changedate IN @chdate
                AND mt_type IN @mt_type
                INTO CORRESPONDING FIELDS OF TABLE @t_tadir.


        MODIFY t_tadir FROM VALUE tadir( srcsystem = p_srcsys ) TRANSPORTING srcsystem
                      WHERE srcsystem <> p_srcsys.

        UPDATE tadir FROM TABLE t_tadir.
        COMMIT WORK.

        MESSAGE |TADIR updated: { sy-subrc }, { sy-dbcnt } | TYPE 'I'.
        lo_alv->refresh( ).

    ENDCASE.
  ENDMETHOD.

ENDCLASS.
