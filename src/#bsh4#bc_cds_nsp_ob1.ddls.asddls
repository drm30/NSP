@AbapCatalog.sqlViewName: '/BSH4/BC_NSP_OB1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Namespace Objects'
define view /BSH4/BC_CDS_NSP_OB1
  as select from    /BSH4/BC_TF_NSP_OBJ  as obj
    left outer join tdevc                         on tdevc.devclass = obj.devclass
    left outer join /BSH4/BC_CDS_NSP_DEF as def   on obj.namespace = def.namespace
    left outer join df14l                as comp  on comp.fctr_id = obj.component
    left outer join df14l                as compp on compp.fctr_id = tdevc.component
{
  key obj.pgmid,
  key obj.object,
  key obj.obj_name,
      obj.namespace,
      obj.devclass,
      tdevc.dlvunit,
      tdevc.component                        as COMPONENTp,
      compp.ps_posid                         as compp_text,
      tdevc.namespace                        as namespacep,
      obj.component,
      comp.ps_posid                          as comp_text,
      obj.crelease,
      obj.srcsystem,
      obj.srcdep,
      obj.author,
      obj.cproject,
      obj.genflag,
      obj.edtflag,
      obj.delflag,
      obj.created_on,
      def.role,
      def.license,
      def.editflag,
      def.replicense,
      def.sscrflag,
      def.sapflag,
      def.gen_only,
      def.changeuser,
      def.changedate,
      def.mt_type,
      def.descriptn,
      cast( case tdevc.dlvunit
      when 'LOCAL' then 'X'
      else ' '
      end as /bsh4/bc_tms_local )            as obj_local,
      cast( case obj.namespace
      when tdevc.namespace then ''
      else 'X' end as /bsh4/bc_tms_nsp_ec )  as namespace_ec,
      cast( case obj.component
      when tdevc.component then ''
      else 'X' end as /bsh4/bc_tms_comp_ec ) as component_ec

}
