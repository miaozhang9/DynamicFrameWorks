
cordova.define("qhCordova-plugin-scanQRCode.scanQRCode", function(require, exports, module) {

var exec = require('cordova/exec');
var platform = require('cordova/platform');

    module.exports = {
        scanQRCode: function(successCallback,errorCallback) {
            exec(successCallback, errorCallback, "QHScanQrCodePlugin", "scanQrCode", []);
        }
    }
});


















