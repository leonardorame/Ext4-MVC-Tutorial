/*
 * File: app/controller/ViewportController.js
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

Ext.define('MyApp.controller.ViewportController', {
    extend: 'Ext.app.Controller',

    models: [
        'Customer',
        'User'
    ],
    stores: [
        'MyJsonStore'
    ],
    views: [
        'CustomerDataForm',
        'MyViewport'
    ],
    init: function() {
        // create a variable accessible from any part of this controller
        // from now on, instead of using "this", use "me".
        me = this;
        MyApp.userInstance = Ext.create('MyApp.model.User', {loggedIn: false});
        me.onViewportRender(this, this);

        this.control({
            "loginform button[id=btnSubmit]":{
                
            },
            "button[id=btnLogout]": {
                click: this.onLogout
            },
            "viewport": {
                render: this.onViewportRender
            }
        });

    },

    getLoginForm: function() {
        // Get or Create loginform instance
        /*lfrm = Ext.getCmp('loginform');
        if(!lfrm){
            lfrm = Ext.widget('loginform');
        };*/
        lfrm = Ext.ComponentQuery.query('#loginform');
        return lfrm;
    },

    onAfterLogin: function(form) {
        
// this event is executed after successfull login.
        MyApp.userInstance.set('loggedIn',  true);
        Ext.widget('viewport');
        me.getMyJsonStoreStore().load();
        form.destroy();
    },

    checkLogin: function() {
        // user is not logged-in then show loginForm.
        if(!MyApp.userInstance.get('loggedIn')) {
            // assign MyForm.onSuccess event to me.onAfterLogin
            // then show the loginForm.
            //me.getLoginForm().onSuccess = me.onAfterLogin;
            me.getLoginForm().show();
        }
    },

    onLogout: function(button, e, options) {
        MyApp.userInstance.set('loggedIn', false);
        me.checkLogin();
    },

    onViewportRender: function(abstractcomponent, options) {
        // after rendering the viewport show the login form if not logged in.
       // if(me.checkLogin()){
       //     console.log("already Logged in.");
       // }
    }

});
