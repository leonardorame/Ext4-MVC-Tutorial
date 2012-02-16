Ext.define('DEMO.store.User', {
    extend: 'Ext.data.Store',
    requires: [
        'DEMO.model.User'
    ],

    constructor: function(cfg) {
        var me = this;
        cfg = cfg || {};
        me.callParent([Ext.apply({
            storeId: 'UserStore',
            model: 'DEMO.model.User',
        }, cfg)]);
    }
});
