

cordova.define("qhCordova-plugin-pop.QHPop", function(require, exports, module) {
//      navigator.notification.alert('rwerwr', 'ffe', '提示','OK');
       var exec = require('cordova/exec');
       module.exports = {
           sheet : function(successInfo, failedInfo, args){
               exec(successInfo, failedInfo, "QHPopPlugin", "sheet", args);
           }
       };
});
