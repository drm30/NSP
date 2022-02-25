@AbapCatalog.sqlViewName: '/BSH4/BC_NSP_SUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Namespace Summary'
define view /BSH4/BC_CDS_NSP_SUM
  //  with parameters
  //    p_devc : devclass
  as select from /BSH4/BC_CDS_NSP_OBJ
{
  key namespace,
  key srcsystem,
  key dlvunit,
  key releas,
  key pdevclass,
  key obj_local,
      cast ( count( * ) as /bsh4/bc_tms_nsp_count preserving type ) as counter,
      role,
      editflag,
      license,
      sscrflag,
      sapflag,
      gen_only,
      changeuser,
      changedate,
      mt_type,
      descriptn
}

group by
  namespace,
  srcsystem,
  dlvunit,
  releas,
  pdevclass,
  obj_local,
  role,
  editflag,
  license,
  sscrflag,
  sapflag,
  gen_only,
  changeuser,
  changedate,
  mt_type,
  descriptn
