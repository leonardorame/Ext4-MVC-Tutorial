Ext.Loader.setConfig({enabled:true});

Ext.application({
    name: 'DEMO',

    appFolder: 'app',

 
    controllers: [
        'LoginController'
    ],
    launch: function() {
      Ext.create('DEMO.view.Viewport', {});
      Ext.create('DEMO.view.LoginWindow', {}).show();
    },
});

