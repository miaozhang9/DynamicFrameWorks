

cordova.define("qhCordova-plugin-camera.QHCamera", function(require, exports, module) {

   var exec = require('cordova/exec');

   module.exports = {
        ///入参第一个元素控制图片大小.exp:[100],返回图片小于100k
        //成功回调返回{base64Img: data}
        fetchFace : function(successInfo, failedInfo, paras){
            exec(successInfo, failedInfo, "QHCameraPlugin", "fetchFace", paras);
        },
        faceRecognition : function(successInfo, failedInfo, paras){
            exec(successInfo, failedInfo, "QHCameraPlugin", "faceRecognition", paras);
        },
        fetchCard: function(successInfo, failedInfo, paras){
            exec(successInfo, failedInfo, "QHCameraPlugin", "fetchCard", paras);
        },
        pickPhoto: function(successInfo, failedInfo, paras){
            exec(successInfo, failedInfo, "QHCameraPlugin", "pickPhoto", paras);
        },
        deleteFile : function(successInfo, failedInfo, fileNames){
            exec(successInfo, failedInfo, "QHCameraPlugin", "deleteFile", fileNames);
        }
   }
});
