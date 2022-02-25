class /BSH4/BC_TMS_NSP_RUN definition
  public
  final
  create public .

public section.

  interfaces /BSH4/X_IF_ALV_COMMAND .

  data GO_XALV type ref to /BSH4/X_ALV .

  methods CONSTRUCTOR .
protected section.
private section.

  methods ADD_BUTTONS .
ENDCLASS.



CLASS /BSH4/BC_TMS_NSP_RUN IMPLEMENTATION.


  METHOD /bsh4/x_if_alv_command~user_command.

    CASE e_ucomm.
      WHEN 'SAVE'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD add_buttons.

    SET HANDLER /bsh4/x_if_alv_command~user_command FOR go_xalv->go_alv.

    go_xalv->add_button(
    i_fcode             =  |SAVE|
    i_text              =  |Save|
    i_icon              = icon_system_save
    i_qinfo             = |Save Values|  ).

  ENDMETHOD.


  METHOD constructor.

  ENDMETHOD.
ENDCLASS.
