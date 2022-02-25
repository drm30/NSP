@AbapCatalog.sqlViewName: '/BSH4/BC_NSP_DEF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Namespace Def'
define view /BSH4/BC_CDS_NSP_DEF
  as select from    trnspace  as def
    left outer join trnspacet as def_t on def.namespace = def_t.namespace
  //    left outer join trnspacel as lic on def.namespace = lic.namespace
  association [1] to trnspacett as txt on  def.namespace = txt.namespace
                                       and spras         = $session.system_language
{
  key def.namespace,
      def.role,
      def.license,
      def.editflag,
      def_t.replicense,
      def.sscrflag,
      def.sapflag,
      def.gen_only,
      def_t.changeuser,
      def_t.changedate,
      def.mt_type,
      txt.descriptn
}
