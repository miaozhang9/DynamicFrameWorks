//
//  QHCameraPlugin.m
//  QHLoanLib
//
//  Created by yinxukun on 2016/12/21.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHCameraPlugin.h"
#if !TARGET_OS_SIMULATOR

#import "PAFaceCheckHome.h"
#import "QHFaceCheckDelegate.h"
#endif

#import "QHFetchFaceViewController.h"
#import "QHCode_message.h"
#import <AVFoundation/AVFoundation.h>
#import "QHCode_message.h"
#import "NSFileManager+QH.h"
#import "QHCode_message.h"
#import "NSArray+QHMASAdditions.h"
#import "QHFetchCardViewController.h"
#import "UIImage+QH.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "QHTakePictureDelegate.h"
#import "QHLoanDoorBundle.h"


#import "QHAlertManager.h"

NSString *const QHImage_Key = @"base64Img";

@interface QHCameraPlugin ()

@property (nonatomic, strong) QHTakePictureDelegate *pickPhotoDelegate;

@end
@implementation QHCameraPlugin

#pragma mark -- public
- (void)faceRecognition:(QHInvokedUrlCommand *)command{

    __weak typeof(self) weakSelf = self;
    [self qh_canUseCamera:command callBack:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf qh_faceRecognition:command];
    }];
}

- (void)fetchFace:(QHInvokedUrlCommand *)command{

    __weak typeof(self) weakSelf = self;
    [self qh_canUseCamera:command callBack:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
    [strongSelf qh_fetchFace:command];
    }];
}

- (void)fetchCard:(QHInvokedUrlCommand *)command{
    __weak typeof(self) weakSelf = self;
    [self qh_canUseCamera:command callBack:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf qh_fetchCard:command];
    }];
}

- (void)pickPhoto:(QHInvokedUrlCommand *)command{
    self.pickPhotoDelegate = [[QHTakePictureDelegate alloc] init];
    [self.pickPhotoDelegate pickPhoto:command cameraPlugin:self];
}

#pragma mark -- pravite
- (void)qh_canUseCamera:(QHInvokedUrlCommand *)command callBack:(void(^)())callback{

    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:QHMsgNoCamera];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        //
        callback();
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        __weak typeof(self) weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                //点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                callback();
            }
        }];
    } else {
        QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:QHMsgNoAuthority];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        QHAlertManager *alertManager = [QHAlertManager shareAlertManager];
        alertManager.viewController = self.viewController;
        [alertManager showAlertMessageWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
    }
}

- (void)qh_fetchFace:(QHInvokedUrlCommand *)command{

    CGFloat photoSize = [[command argumentAtIndex:0 withDefault:@"10000"] floatValue];
    QHFetchFaceViewController *faceCtrl = [[QHFetchFaceViewController alloc] init];
    __weak typeof(self) weakself = self;
    [faceCtrl setFetchFaceComplete:^(UIImage *image, NSDictionary *errorInfo) {
        [weakself.commandDelegate runInBackground:^{
            if (image) {
                QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:@{QHImage_Key: [[image qh_toDiskSize:photoSize] qh_toBase64]}];
                [weakself.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
            else{
                QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:errorInfo];
                [weakself.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        }];
    }];
    [self.viewController presentViewController:faceCtrl animated:YES completion:nil];
}

- (void)qh_faceRecognition:(QHInvokedUrlCommand *)command{
   
#if !TARGET_OS_SIMULATOR

    CGFloat photoSize = [[command argumentAtIndex:0 withDefault:@"10000"] floatValue];
    NSString *environment;
    NSMutableDictionary *environmentDict = [[NSMutableDictionary alloc]init];
    [environmentDict setValue:@"com.pingan.qh" forKey:@"boundId"];
//    [PAFaceCheckHome setFaceEnvironmentWithDict:environmentDict];

    QHFaceCheckDelegate *delegate = [QHFaceCheckDelegate shareDelegate];

    __weak typeof(self) weakself = self;
    [delegate setFaceRecognitionComplete:^(BOOL isSuccess, UIImage *oriImg, UIImage *faceImg, NSDictionary *otherInfo) {
        // 将获取头像结果返回给js
        [weakself.commandDelegate runInBackground:^{
            QHPluginResult *result = nil;
            if (isSuccess && faceImg) {
                result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:@{QHImage_Key: [[faceImg qh_toDiskSize:photoSize] qh_toBase64]}];
            }
            else{
                result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:QHMsgFaceRecognitionFailed];
            }
            [weakself.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
    }];
    
  
        PAFaceCheckHome *faceVC = [[PAFaceCheckHome alloc] initWithPAcheckWithTheCountdown:YES andTheAdvertising:@"" number0fAction:@"2" voiceSwitch:YES delegate:delegate];
        [self.viewController presentViewController:faceVC animated:YES completion:nil];
    
#endif
}

- (void)deleteFile:(QHInvokedUrlCommand *)command{
    for (NSString *arg in command.arguments) {
        if (![arg isKindOfClass:[NSString class]]) {
            return;
        }
        BOOL isSuccess = [NSFileManager qh_deleteFile:arg];
        __weak typeof(self) weakself = self;
        [weakself.commandDelegate runInBackground:^{
            QHPluginResult *result = nil;
            if (isSuccess) {
                result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:arg];
            }
            else{
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:QHMsgOther];
                [dict setObject:arg forKey:@"filePath"];
                result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:[NSMutableDictionary dictionaryWithDictionary:dict]];
            }
            [weakself.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }];
    }
}

- (void)qh_fetchCard:(QHInvokedUrlCommand *)command{

    CGFloat photoSize = [[command argumentAtIndex:0 withDefault:@"10000"] floatValue];
    NSString *arg1 = [command argumentAtIndex:1 withDefault:nil];
    NSString *arg2 = [command argumentAtIndex:2 withDefault:nil];

//    arg1 = [[QHLoanDoorBundle imageNamed:@"test"] qh_toBase64];
//    arg2 = @"请将您的银行卡置于方框中,请将您的银行卡置于方框中,请将您的银行卡置于方框中";

    UIImage *argImage = nil;
    NSString *argText = nil;
    BOOL imageLeft = YES;
    //展示用字符串／图片base64用长度区分
    if (arg1.length > 100) {
        argImage = [UIImage qh_base64ToImage:arg1];
    }
    else{
        argText = arg1;
    }
    if (arg2.length > 100) {
        argImage = [UIImage qh_base64ToImage:arg2];
        imageLeft = NO;
    }
    else{
        argText = arg2;
    }

    NSLog(@"需要相片尺寸%fk", photoSize);
    QHFetchCardViewController *fetchCardCtrl = [[QHFetchCardViewController alloc] init];
    fetchCardCtrl.isIconLeft = imageLeft;
    fetchCardCtrl.argIcon = argImage;
    fetchCardCtrl.argText = argText;
    [self.viewController presentViewController:fetchCardCtrl animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    [fetchCardCtrl setCameraCompleteAction:^(UIImage *img, NSDictionary *errorInfo) {
        [weakself.commandDelegate runInBackground:^{
            if (img) {
                QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:@{QHImage_Key: [[img qh_toDiskSize:photoSize] qh_toBase64]}];
                NSLog(@"获取到图片2:%@", [NSDate date]);
                [weakself.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
            else{
                QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsDictionary:errorInfo];
                [weakself.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            }
        }];
    }];
}

@end
