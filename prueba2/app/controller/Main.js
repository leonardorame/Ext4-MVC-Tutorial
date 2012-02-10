Ext.define('DEMO.controller.Main', {
    extend: 'Ext.app.Controller',
    refs: [
      {
        ref: 'background',
        selector: 'background'
      },
      {
        ref: 'mygridpanel',
        selector: 'mygridpanel'
      },
      {
        ref: 'mainview',
        selector: 'mainview'
      }
    ],

    models: ['Customer'],
    stores: ['MyJsonStore'],

    init: function() {
        this.getController('DEMO.controller.MyGridPanel').init();

        mainView = Ext.create('DEMO.view.Main', {});
        item = this.getBackground().down('container[region=center]'); 
        item.add(mainView);
    },

    destroyAll: function(){
      mainView.destroy();
      this.destroy();
    }
});
