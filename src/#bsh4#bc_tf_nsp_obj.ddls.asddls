@ClientHandling.type: #CLIENT_INDEPENDENT
define table function /BSH4/BC_TF_NSP_OBJ

returns
{
  key pgmid      : pgmid;
  key object     : trobjtype;
  key obj_name   : sobj_name;
      namespace  : namespace;
      //      obj_local  : /bsh4/bc_tms_local;
      devclass   : devclass;
      component  : dlvunit;
      crelease   : saprelease;
      srcsystem  : srcsystem;
      srcdep     : srcdep;
      author     : author;
      cproject   : cproject;
      genflag    : genflag;
      edtflag    : edtflag;
      delflag    : objdelflag;
      created_on : created_on;

}
implemented by method
  /BSH4/BC_nsp_obj_namespace=>get_namespace;
