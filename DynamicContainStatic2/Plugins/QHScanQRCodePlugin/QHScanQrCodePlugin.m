//
//  QHSacnQrCodePlugin.m
//  HelloWorld
//
//  Created by guopengwen on 16/12/15.
//  Copyright © 2016年 guopengwen. All rights reserved.
//

#import "QHScanQrCodePlugin.h"
#import <AVFoundation/AVFoundation.h>
#import "QHScanQRCodeViewController.h"
#import "QHAlertManager.h"
@implementation QHScanQrCodePlugin

- (void)scanQrCode:(QHInvokedUrlCommand*)command
{
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!hasCamera) {
        
        NSDictionary *dic = @{@"code":@"0", @"message":@"设备无相机"};
         QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:dic];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self presentScanQRcodeWithCommand:command];
        
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        __weak typeof(self) weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                //点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf presentScanQRcodeWithCommand:command];
            }
        }];
    } else {
//        NSDictionary *dic = @{@"code":@"1", @"message":@"无使用相机的权限"};
//        QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:dic];
//        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        dispatch_async(dispatch_get_main_queue(), ^{
            QHAlertManager *alertManager = [QHAlertManager shareAlertManager];
            alertManager.viewController = self.viewController;
            [alertManager showAlertMessageWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
        });
    }
}

- (void)presentScanQRcodeWithCommand:(QHInvokedUrlCommand*)command {
    QHScanQRCodeViewController *vc = [QHScanQRCodeViewController new];
    vc.scanCodeResult = ^void(NSDictionary *dic){
        QHPluginResult* result;
        if ([dic objectForKey:@"qrCode"]) {
            result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:[dic objectForKey:@"qrCode"]];
        } else {
            result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:dic];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    };
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.viewController presentViewController:navVC animated:YES completion:nil];
}


@end
