Ext.define('DEMO.view.Viewport', {
    extend: 'Ext.container.Viewport',
    alias: 'widget.background',
    //requires: [
    //    'DEMO.view.Main'
    //],
    layout: 'border',
    initComponent: function() {
        Ext.apply(this, {
            items: [
                {
                    region: 'north', 
                    html: '<h1 class="x-panel-header">Page Title</h1>'
                },
                {
                    region: 'south', 
                    html: '<h1 class="x-panel-header">Page footer</h1>'
                },
                {
                    xtype: 'panel',
                    layout: 'fit',
                    region: 'center',
                    items: [ ]
                }
            ]
        });
        this.callParent();
    }
});

