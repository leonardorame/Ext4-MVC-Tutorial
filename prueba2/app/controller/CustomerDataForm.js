Ext.define('DEMO.controller.CustomerDataForm', {
    extend: 'Ext.app.Controller',
    stores: [
      'MyJsonStore'
    ],
    init: function(record) {
        me = this;
        view = Ext.widget('frmCustomer');
        if(record.data.Id==-1){
          view.getForm().url = '/cgi-bin/extdesigner/extjshandler.cgi/CustomerData/insert';
        };
        view.getForm().loadRecord(record);
        view.show();

        this.control({
            'button[action=submit]': {
                click: this.onSubmit
            },
            'button[action=cancel]': {
              click: this.onCancel
            },
            'frmCustomer' :{
              afterclose: this.onAfterClose
            }
        });
    },
    onSubmit: function(button) {
      console.log('onSubmitClick');
      var win = button.up('frmCustomer');
          frm = win.getForm();
          frm.submit({
            success: function(form, action){
                console.log('After submit');
                win.close();
                me.onAfterSave();
            },
            failure: function(form, action){
                switch(action.failureType){
                    case Ext.form.action.CLIENT_INVALID:
                    Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');
                    break;
                    case Ext.form.action.Action.CONNECT_FAILURE:
                    Ext.Msg.alert('Failure', 'Ajax communication failed');
                    break;
                    case Ext.form.action.Action.SERVER_INVALID:
                    Ext.Msg.alert('Failure', action.result.msg);
                    break;
                }
            },
            scope: this
          });

    },
    onCancel: function(button) {
      view.close();
    },
    onAfterClose: function(panel, eOpts) {
      view.destroy();
      //Ext.Msg.alert('Cancel', 'aaa');
    }
});

