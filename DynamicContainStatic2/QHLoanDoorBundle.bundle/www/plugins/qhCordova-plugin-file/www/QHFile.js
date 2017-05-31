



cordova.define("qhCordova-plugin-file.QHFile", function(require, exports, module) {

   var exec = require('cordova/exec');

   module.exports = {
       deleteFile : function(successInfo, failedInfo, fileNames){
           exec(successInfo, failedInfo, "QHFile", "deleteFile", fileNames);
       }
   };
});
