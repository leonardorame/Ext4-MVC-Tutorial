Ext.Loader.setConfig({enabled:true});

Ext.application({
    name: 'DEMO',

    appFolder: 'app',

    controllers: [
        'User',
        'Main',
        'MyGridPanel',
        'LoginController',
        'CustomerDataForm'
    ],

    autoCreateViewport: true,
    
    launch: function() {
      var user = this.getController('DEMO.controller.User').getUser();
      
      if(!user.data.loggedIn) {
          Ext.create('DEMO.view.LoginWindow', {}).show();
      }
      else
      {
          this.getController('DEMO.controller.Main').showMainView();
      }
    }
});

