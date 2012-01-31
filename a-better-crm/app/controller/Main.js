/*
 * File: app/controller/Main.js
 *
 * This file was generated by Sencha Designer version 2.0.0.
 * http://www.sencha.com/products/designer/
 *
 * This file requires use of the Ext JS 4.0.x library, under independent license.
 * License of Sencha Designer does not include license for Ext JS 4.0.x. For more
 * details see http://www.sencha.com/license or contact license@sencha.com.
 *
 * You should implement event handling and custom methods in this
 * class.
 */

Ext.define('MyApp.controller.Main', {
    extend: 'Ext.app.Controller',

    models: [
        'Customer'
    ],
    stores: [
        'Customers'
    ],
    views: [
        'CustomerGrid',
        'MainToolbar'
    ],
    refs: [
        {
            ref: 'viewportmain',
            selector: 'viewportmain'
        }
    ],

    init: function() {
        this.control({
        });
    },

    showMainView: function() {
        mainToolBar = Ext.create('MyApp.view.MainToolbar', {});
        mainView = Ext.create('MyApp.view.CustomerGrid', {flex: 1});
        // to be able to use "this.getViewport()" the a ref has to be added
        // please take a look at the refs section of this file.
        var center_container = this.getViewportmain().down('container[region=center]'); 
        center_container.add(mainToolBar);
        center_container.add(mainView);
        // load the store
        this.getCustomersStore().load();
    },

    destroyAll: function() {
        mainToolBar.destroy();
        mainView.destroy();
        this.destroy();
    }

});