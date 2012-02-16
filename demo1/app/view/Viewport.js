Ext.define('DEMO.view.Viewport', {
    extend: 'Ext.container.Viewport',
    layout: 'border',
    initComponent: function() {
        Ext.apply(this, {
            items: [
                {
                    region: 'north', 
                    html: '<h1 class="x-panel-header">Page Title</h1>'
                },
                {
                    region: 'center',
                    html: '<h1 class="x-panel-header">This is the center region.</h1>'
                },
                {
                    region: 'south', 
                    html: '<h1 class="x-panel-header">Page footer</h1>'
                },
            ]
        });
        this.callParent();
    }
});
