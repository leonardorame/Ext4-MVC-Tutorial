// test
Ext.Loader.setConfig({enabled:true});

Ext.application({
    name: 'DEMO',

    appFolder: 'app',

    controllers: [
        'Main',
        'MyGridPanel',
        'LoginController',
        'CustomerDataForm'
    ],
  
    autoCreateViewport: true,
    
    launch: function() {
      Ext.create('DEMO.view.LoginWindow', {}).show();
    },
});

