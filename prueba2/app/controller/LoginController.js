Ext.define('DEMO.controller.LoginController', {
    extend: 'Ext.app.Controller',
    refs: [
        {
            ref: 'mainview',
            selector: 'mainview'
        },
        {
            ref: 'loginform',
            selector: 'loginform'
        }
    ],
    stores: [
      'MyJsonStore'
    ],
    init: function() {
        var me = this;
        background = null;
        mainController = null;

        this.control({
            'loginform': {
                render: this.onPanelRendered
            },
            'loginform button[action=login]': {
                click: this.login
            },
            'loginform textfield': {
              specialkey: this.keyenter
            },
            'mainview button[action=logout]': {
              click: this.logout
            }
        });
    },

    onPanelRendered: function(panel) {
      console.log('The panel was rendered');
    },
    
    login: function(button) {
      var win = button.up('loginform');
          frm = win.getForm();
          frm.submit({
            success: function(form, action){
                this.getController('DEMO.controller.Main').init();
                win.destroy();  
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
    keyenter: function() {
        console.log('keyenter');
    },
    logout: function(button) {
        console.log('logout');
        this.getController('DEMO.controller.Main').destroyAll();
        Ext.create('DEMO.view.LoginWindow', {}).show();
    }
});

