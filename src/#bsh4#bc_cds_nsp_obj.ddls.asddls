@AbapCatalog.sqlViewName: '/BSH4/BC_NSP_OBJ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Namespace Objects'
define view /BSH4/BC_CDS_NSP_OBJ
  as select from    tadir                as obj
    join            tdevc                            on tdevc.devclass = obj.devclass
    left outer join /BSH4/BC_CDS_NSP_DEF as def      on tdevc.namespace = def.namespace
    left outer join df14l                as comp_txt on comp_txt.fctr_id = tdevc.component
    left outer join cvers                as comp_def on comp_def.component = tdevc.dlvunit
{
  key obj.pgmid,
  key obj.object,
  key obj.obj_name,
      obj.devclass,
      tdevc.tpclass,
      tdevc.pdevclass,
      tdevc.namespace,
      tdevc.dlvunit,
      comp_def.release                       as releas,
      comp_def.extrelease,
      tdevc.component                        as comp_int,
      comp_txt.ps_posid                      as comp_text,
      obj.component,
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
      cast( case obj.component
      when tdevc.dlvunit then ''
      else 'X' end as /bsh4/bc_tms_comp_ec ) as component_ec
}
