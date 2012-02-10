/*
 * File: app/controller/MyForm.js
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

Ext.define('DEMO.controller.MyForm', {
    extend: 'Ext.app.Controller',

    views: [
        'MyForm'
    ],
    init: function() {
        console.log('MyForm Controller init.');
        this.control({
            "button[id=btnSubmit]": {
                click: this.onButtonClick1
            }
        });
    },

    onButtonClick1: function(button, e, options) {
        //MyApp.userInstance.set('loggeIn', false) ;
        var frm = button.up('loginform');
        frm.getForm().submit({
            success: function(form, action){
                Ext.Msg.alert('Sucess', action.result.msg);
                frm.onSuccess(frm);
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
            }
        }
        );
    }

});
