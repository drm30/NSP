*&---------------------------------------------------------------------*
*& Report /BSH4/BC_TMS_NSP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT /bsh4/bc_tms_nsp.

CONSTANTS: c_button_save TYPE ui_func VALUE 'SAVE'.

TABLES /bsh4/bc_nsp_obj.

TABLES: tadir, trnspacet, trnspacett.

DATA lo_alv TYPE REF TO if_salv_gui_table_ida.

SELECTION-SCREEN BEGIN OF BLOCK b10 WITH FRAME TITLE TEXT-b10.
  PARAMETERS: p_sum RADIOBUTTON GROUP r1 DEFAULT 'X'.
  PARAMETERS: p_obj RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK b10.

SELECTION-SCREEN BEGIN OF BLOCK b00 WITH FRAME TITLE TEXT-b00.
  SELECT-OPTIONS: nsp FOR trnspacet-namespace, " DEFAULT '/A' TO '/ZZZZZZZZ/',
                  role FOR trnspacet-role,
                  srcsys FOR /bsh4/bc_nsp_obj-srcsystem,
                  dlvunit FOR /bsh4/bc_nsp_obj-dlvunit,
                  tpclass for /bsh4/bc_nsp_obj-tpclass,
                  sscrflag FOR trnspacet-sscrflag,
                  sapflag FOR trnspacet-sapflag,
                  gen_only FOR trnspacet-gen_only,
                  chuser FOR trnspacet-changeuser,
                  chdate FOR trnspacet-changedate,
                  mt_type FOR trnspacet-mt_type,
                  descr FOR trnspacett-descriptn.

  SELECTION-SCREEN BEGIN OF BLOCK b15 WITH FRAME TITLE TEXT-b15.
    SELECT-OPTIONS: pgmid FOR tadir-pgmid,
                    object FOR tadir-object,
                    obj_name FOR tadir-obj_name,
                    devclass FOR tadir-devclass,
                    srcdep FOR tadir-srcdep,
                    cproject FOR tadir-cproject,
                    author FOR tadir-author,
                    genflag FOR tadir-genflag,
                    edtflag FOR tadir-edtflag,
                    delflag FOR tadir-delflag,
                    created FOR tadir-created_on,
*                    nsp_ec for /BSH4/BC_NSP_OBJ-namespace_ec,
                    comp_ec FOR /bsh4/bc_nsp_obj-component_ec.

  SELECTION-SCREEN END OF BLOCK b15.
SELECTION-SCREEN END OF BLOCK b00.

*SELECTION-SCREEN BEGIN OF BLOCK b20 WITH FRAME TITLE TEXT-b20.
*  PARAMETERS p_srcsys TYPE tadir-srcsystem DEFAULT sy-sysid.
*SELECTION-SCREEN END OF BLOCK b20.

* Popup-Fenster (Selektionsbild 100) deklarieren
SELECTION-SCREEN BEGIN OF SCREEN 100 TITLE title.
PARAMETERS: p_srcsys TYPE tadir-srcsystem DEFAULT sy-sysid.
SELECTION-SCREEN END OF SCREEN 100.

INCLUDE /bsh4/bc_tms_nsp_lcl.

INITIALIZATION.

START-OF-SELECTION.

  DATA(lo_collector) = NEW cl_salv_range_tab_collector( ).

  lo_collector->add_ranges_for_name( iv_name = 'NAMESPACE' it_ranges = nsp[] ).
  lo_collector->add_ranges_for_name( iv_name = 'ROLE' it_ranges = role[] ).
  lo_collector->add_ranges_for_name( iv_name = 'SSCRFLAG' it_ranges = sscrflag[] ).
  lo_collector->add_ranges_for_name( iv_name = 'SRCSYSTEM' it_ranges = srcsys[] ).
  lo_collector->add_ranges_for_name( iv_name = 'DLVUNIT' it_ranges = dlvunit[] ).
  lo_collector->add_ranges_for_name( iv_name = 'TPCLASS' it_ranges = tpclass[] ).

  lo_collector->add_ranges_for_name( iv_name = 'SAPFLAG' it_ranges = sapflag[] ).
  lo_collector->add_ranges_for_name( iv_name = 'GEN_ONLY' it_ranges = gen_only[] ).
  lo_collector->add_ranges_for_name( iv_name = 'CHANGEUSER' it_ranges = chuser[] ).
  lo_collector->add_ranges_for_name( iv_name = 'CHANGEDATE' it_ranges = chdate[] ).
  lo_collector->add_ranges_for_name( iv_name = 'MT_TYPE' it_ranges = mt_type[] ).
  lo_collector->add_ranges_for_name( iv_name = 'DESCRIPTN' it_ranges = descr[] ).

  IF p_sum = abap_true.
    lo_alv = cl_salv_gui_table_ida=>create_for_cds_view( iv_cds_view_name = |/BSH4/BC_CDS_NSP_SUM| ).
    lo_collector->get_collected_ranges( IMPORTING et_named_ranges = DATA(t_selopt_sum) ).
    lo_alv->set_select_options( t_selopt_sum ).
    DATA(l_layout_handle) = 1.

*    lo_alv->set_view_parameters( it_parameters = value #( ( name = 'P_DEVC' value = '$TMP' ) ) ).
  ELSE.
    lo_alv = cl_salv_gui_table_ida=>create_for_cds_view( iv_cds_view_name = |/BSH4/BC_CDS_NSP_OBJ| ).

    lo_collector->add_ranges_for_name( iv_name = 'PGMID' it_ranges = pgmid[] ).
    lo_collector->add_ranges_for_name( iv_name = 'OBJECT' it_ranges = object[] ).
    lo_collector->add_ranges_for_name( iv_name = 'OBJ_NAME' it_ranges = obj_name[] ).
    lo_collector->add_ranges_for_name( iv_name = 'DEVCLASS' it_ranges = devclass[] ).
    lo_collector->add_ranges_for_name( iv_name = 'SRCSYSTEM' it_ranges = srcsys[] ).
    lo_collector->add_ranges_for_name( iv_name = 'CPROJECT' it_ranges = cproject[] ).
    lo_collector->add_ranges_for_name( iv_name = 'AUTHOR' it_ranges = author[] ).
    lo_collector->add_ranges_for_name( iv_name = 'GENFLAG' it_ranges = genflag[] ).
    lo_collector->add_ranges_for_name( iv_name = 'EDTFLAG' it_ranges = edtflag[] ).
    lo_collector->add_ranges_for_name( iv_name = 'DELFLAG' it_ranges = delflag[] ).
    lo_collector->add_ranges_for_name( iv_name = 'CREATED_ON' it_ranges = created[] ).
*    lo_collector->add_ranges_for_name( iv_name = 'NAMESPACE_EC' it_ranges = nsp_ec[] ).
    lo_collector->add_ranges_for_name( iv_name = 'COMPONENT_EC' it_ranges = comp_ec[] ).
    lo_collector->get_collected_ranges( IMPORTING et_named_ranges = DATA(t_selopt_obj) ).
    lo_alv->set_select_options( t_selopt_obj ).
    lo_alv->field_catalog( )->enable_text_search( 'OBJ_NAME' ).

    l_layout_handle = 2.

  ENDIF.


  "select * from tadir WHERE
  lo_alv->layout_persistence( )->set_persistence_options(
                                    is_persistence_key = VALUE #( report_name = sy-repid
                                                                  handle = l_layout_handle
*                                                                  log_group = l_layout_log_group
                                                                  )
                                    i_global_save_allowed = abap_true
                                    i_user_specific_save_allowed = abap_true ).
*  lo_alv->toolbar( )->enable_listbox_for_layouts( )

  " Fix Values from domain: Values or description
  lo_alv->field_catalog( )->display_options( )->set_formatting(
                                iv_field_name        = 'ROLE'
                                iv_presentation_mode = if_salv_gui_types_ida=>cs_presentation_mode-code ).
*                                iv_presentation_mode = if_salv_gui_types_ida=>cs_presentation_mode-description ).
  "lo_alv->layout_persistence( )->set_persistence_options(
  lo_alv->toolbar( )->set_visibility_std_functions( iv_aggregation = abap_true
                                                    iv_details = abap_true
                                                    iv_export = abap_true
                                                    iv_filter = abap_true
                                                    iv_settings_dialog = abap_true
                                                    iv_print = abap_true
                                                    iv_sort = abap_true ).

* Add Button
  lo_alv->toolbar( )->add_button( EXPORTING
                                   iv_fcode                     = c_button_save
                                   iv_icon                      = ICON_SYSTEM_SAVE
                                   iv_text                      = 'Save'
                                   iv_quickinfo                 = 'Save'
                                   iv_before_standard_functions = abap_true ).
  lo_alv->toolbar( )->add_button( EXPORTING
                                   iv_fcode                     = 'POPUP'
                                   iv_icon                      = 'ICON_SYSTEM_OKAY'
                                   iv_text                      = 'PopUp'
                                   iv_quickinfo                 = 'PopUp'
                                   iv_before_standard_functions = abap_true ).

  lo_alv->toolbar( )->add_separator( iv_before_standard_functions = abap_true ).

*lo_alv->field_catalog( )->set_field_header_texts(
*  iv_field_name = 'ROLE'
*  iv_header_text = 'Neue Überschrift'
*  iv_tooltip_text = 'Standard: 40 Zeichen zur Verfügung'
*  iv_tooltip_text_long =
*    'Erweiterung: 100 Zeichen zur Verfügung bei richtiger SAP GUI und SAP Basis Version'


  lo_alv->standard_functions( )->set_text_search_active( abap_true ).
*  lo_alv->text_search( )->set_field_similarity( '0.8' ).
*  lo_alv->text_search( )->set_search_term( |Fehler| ).

  lo_alv->display_options( )->enable_alternating_row_pattern( ).
*  lo_alv->toolbar( )->add_button( EXPORTING
*                                   iv_fcode                     = c_button_save
*                                   iv_icon                      = 'ICON_SYSTEM_SAVE'
*                                   iv_text                      = 'Change Orig.Sys ->' && p_srcsys
*                                   iv_quickinfo                 = 'Change Original System'
*                                   iv_before_standard_functions = abap_true ).
*  lo_alv->toolbar( )->add_separator( EXPORTING
*                                      iv_before_standard_functions = abap_true ).

  SET HANDLER lcl_events=>on_toolbar_function_selected FOR lo_alv->toolbar( ).

  lo_alv->fullscreen( )->display( ).
