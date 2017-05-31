
cordova.define("qhCordova-plugin-contacts.contacts", function(require, exports, module) {

var exec = require('cordova/exec');
var platform = require('cordova/platform');

module.exports = {

    getContactProperty: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "QHContactsPlugin", "chooseContactProperty",[]);
    }
};

});

















