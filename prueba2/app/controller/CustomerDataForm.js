Ext.define('DEMO.controller.CustomerDataForm', {
    extend: 'Ext.app.Controller',
    stores: ['MyJsonStore'],
    init: function() {
        me = this;
        this.control({
            'button[action=submit]': {
                click: this.onSubmit
            },
            'button[action=cancel]': {
              click: this.onCancel
            }
        });
    },
    onSubmit: function(button) {
      var win = button.up('frmCustomer');
          frm = win.getForm();
          if(win.getInsertMode()) {
              customer = frm.getValues();
              console.log(customer);
              var store = this.getMyJsonStoreStore();
              store.insert(0, customer);
          }
          else
          { 
              customer = frm.getRecord();
              frm.updateRecord(customer);
          };
          this.getMyJsonStoreStore().sync();
          win.destroy();
    },
    onCancel: function(button) {
      var win = button.up('frmCustomer');
      win.destroy();
    }
});
  
