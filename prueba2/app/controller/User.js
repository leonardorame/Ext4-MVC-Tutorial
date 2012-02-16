Ext.define('DEMO.controller.User', {
    extend: 'Ext.app.Controller',
    stores: [
      'User'
    ],

    init: function() {
        var me = this;
        var store = this.getUserStore();
        store.load();

        user = store.first();
        if(!user){
          store.add({loggedIn: false});
          user = store.first();
          store.sync();
        };
    },

    saveSession: function(){
        user.set('loggedIn', true);
        user.save();
    },

    deleteSession: function(){
        user.destroy();
        var store = this.getUserStore();
        store.sync();
    },
    getUser: function(){
        console.log(user);
        return user;
    }
});
