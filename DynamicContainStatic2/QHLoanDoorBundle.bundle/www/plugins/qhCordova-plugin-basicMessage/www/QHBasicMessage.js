cordova.define("qhCordova-plugin-basicMessage.basicMessage", function(require, exports, module) {
               
    var exec = require('cordova/exec');
    var platform = require('cordova/platform');
               
    module.exports = {
               
        getSDKVersion: function(successCallback, errorCallback) {
            exec(successCallback, errorCallback, "QHBasicMessagePlugin", "getSDKVersion", []);
        },

        getSomeMessage: function(successCallback, errorCallback, message) {
            var _message = null;
            if (typeof message == 'object' && message.length >0) {
                _message = message ;
            } else if (message) {
               _message = (typeof message === "string" ? [message] : []);
            } else {
               _message = ['all'];
            }
            exec(successCallback, errorCallback, "QHBasicMessagePlugin", "searchSomeMessage", [_message]);
        },
               
        getDeviceInfo: function(successCallback, errorCallback) {
               exec(successCallback, errorCallback, "QHBasicMessagePlugin", "getDeviceInfo", []);
        },
               
        getAgentUserInfo: function(successCallback, errorCallback) {
               exec(successCallback, errorCallback, "QHBasicMessagePlugin", "getAgentUserInfo", []);
        }
    };
});
