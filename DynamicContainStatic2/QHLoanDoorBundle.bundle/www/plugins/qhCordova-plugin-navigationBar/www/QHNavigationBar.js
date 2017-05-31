
cordova.define("qhCordova-plugin-navigationBar.navigationBar", function(require, exports, module) {

var exec = require('cordova/exec');
var platform = require('cordova/platform');

module.exports = {

    setNaviBarTitle: function(title) {
        if (typeof title === 'string') {
            exec(null, null, "QHNavigationbarPlugin", "setNaviBarTitle", [title]);
        }
    },

    showNavigationBar: function(show) {
        if (typeof show === 'boolean') {
            exec(null, null, "QHNavigationbarPlugin", "showNavigationBar", [show]);
        }
    },
               
    setNavibarTitleColor: function(color) {
       if (typeof color === 'string') {
            exec(null, null, "QHNavigationbarPlugin", "setNavibarTitleColor", [color]);
       }
    },
               
    setNaviBarColor: function(color) {
        if (typeof color === 'string') {
            exec(null, null, "QHNavigationbarPlugin", "setNaviBarColor", [color]);
        }
    },
               
    openNewPageWithUrl: function(url) {
        if (typeof url === 'string') {
               exec(null, null, "QHNavigationbarPlugin", "openNewPageWithUrl", [url]);
        }
    },
               
    closeAllPage: function() {
       
              exec(null, null, "QHNavigationbarPlugin", "closeAllPage", []);
        
   },
               
   openLaunchLoginPage: function() {
   
               exec(null, null, "QHNavigationbarPlugin", "openLaunchLoginPage", []);
   
   }
}
});


















