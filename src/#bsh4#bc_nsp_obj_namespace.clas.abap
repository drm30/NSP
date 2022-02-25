CLASS /bsh4/bc_nsp_obj_namespace DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_amdp_marker_hdb.

    TYPES: BEGIN OF TYPE_s_object,
             pgmid    TYPE pgmid,
             object   TYPE trobjtype,
             obj_name TYPE sobj_name,
           END OF TYPE_s_object.
    TYPES: type_t_objects TYPE TABLE OF TYPE_s_object WITH DEFAULT KEY.

    CLASS-METHODS get_namespace FOR TABLE FUNCTION /bsh4/bc_tf_nsp_obj.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /BSH4/BC_NSP_OBJ_NAMESPACE IMPLEMENTATION.


  METHOD get_namespace BY DATABASE FUNCTION
  FOR HDB LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING tadir.

    RETURN SELECT
    pgmid,
    object,
    obj_name,
* LIMU DOCU NA/BSH4/A_TEC_MESS076
    CASE object
    WHEN 'SUSC' THEN obj_name
    ELSE
      concat( concat(  '/', substr_before( substr_after( obj_name, '/' ), '/' ) ), '/' )
    END AS namespace,
*    CASE devclass
*    WHEN '$TMP' THEN 'X'
*    ELSE ''
*    END AS obj_local,
    devclass,
    component,
    crelease,
    srcsystem,
    srcdep,
    author,
    cproject,
    genflag,
    edtflag,
    delflag,
    created_on
*left( obj_name, 5 )  as namespace,
*substr_before( substr_after( obj_name, 1 )
*instr( right( obj_name, 2 ), '/' ) as zahl
    from tadir
    WHERE obj_name LIKE '/%'
       OR ( object = 'DOCU' AND obj_name LIKE '__/%' )
       OR ( object = 'SPRX' AND obj_name LIKE '____/%' )
    ;

  ENDMETHOD.
ENDCLASS.
