@AbapCatalog.sqlViewName: '/BSH4/BC_NSP_SU1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Namespace Summary'
define view /BSH4/BC_CDS_NSP_SU1
  //  with parameters
  //    p_devc : devclass
  as select from /BSH4/BC_CDS_NSP_OB1
{
  key namespace,
  key srcsystem,
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
