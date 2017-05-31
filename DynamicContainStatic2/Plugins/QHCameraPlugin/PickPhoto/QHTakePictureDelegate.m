//
//  QHTakePictureDelegate.m
//  QHLoanlib
//
//  Created by yinxukun on 2016/12/29.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHTakePictureDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "QHAlertManager.h"

@interface QHTakePictureDelegate ()<UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) QHCameraPicker *pickerController;

@property (readwrite, assign) BOOL hasPendingOperation;

@property (nonatomic, weak) QHCameraPlugin *cameraPlugin;

@property (nonatomic, strong) QHInvokedUrlCommand *command;

@end

@implementation QHTakePictureDelegate

static NSSet* qh_org_apache_cordova_validArrowDirections;

+ (void)initialize
{
    qh_org_apache_cordova_validArrowDirections = [[NSSet alloc] initWithObjects:[NSNumber numberWithInt:UIPopoverArrowDirectionUp], [NSNumber numberWithInt:UIPopoverArrowDirectionDown], [NSNumber numberWithInt:UIPopoverArrowDirectionLeft], [NSNumber numberWithInt:UIPopoverArrowDirectionRight], [NSNumber numberWithInt:UIPopoverArrowDirectionAny], nil];
}

- (void)pickPhoto:(QHInvokedUrlCommand *)command cameraPlugin:(QHCameraPlugin *)plugin{

    //    UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
    //    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    imgPickerCtrl.delegate = self;
    //    imgPickerCtrl.allowsEditing = YES;
    //    imgPickerCtrl.sourceType = sourceType;
    //    [self.viewController presentViewController:imgPickerCtrl animated:YES completion:^{
    //
    //    }];
    self.command = command;
    self.cameraPlugin = plugin;
    self.hasPendingOperation = YES;
    __weak typeof(self) weakself = self;
    [self.cameraPlugin.commandDelegate runInBackground:^{

        QHPictureOptions* pictureOptions = [QHPictureOptions createFromTakePictureArguments:command];
        //        pictureOptions.popoverSupported = [weakself popoverSupported];
        //        pictureOptions.usesGeolocation = [weakself usesGeolocation];
        pictureOptions.cropToSize = NO;

        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:pictureOptions.sourceType];
        if (!hasCamera) {
            QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_ERROR messageAsString:@"No camera available"];
            [weakself.cameraPlugin.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            return;
        }

        // Validate the app has permission to access the camera
        if (pictureOptions.sourceType == UIImagePickerControllerSourceTypeCamera && [AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusNotDetermined) {
                __weak typeof(self) weakSelf = self;
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        //点击允许访问时调用
                        //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        [strongSelf qh_presentImagePickerController:command pictureOptions:pictureOptions];
                    }
                }];
                
            } else if (authStatus == AVAuthorizationStatusAuthorized) {
                [weakself qh_presentImagePickerController:command pictureOptions:pictureOptions];
            } else {
                // If iOS 8+, offer a link to the Settings app
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
                NSString* settingsButton = (&UIApplicationOpenSettingsURLString != NULL)
                ? NSLocalizedString(@"Settings", nil)
                : nil;
#pragma clang diagnostic pop
                
                // Denied; show an alert
                dispatch_async(dispatch_get_main_queue(), ^{
                    QHAlertManager *alertManager = [QHAlertManager shareAlertManager];
                    alertManager.viewController = self.cameraPlugin.viewController;
                    [alertManager showAlertMessageWithMessage:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"];
                });
            }
        }
    }];
}

- (void)qh_presentImagePickerController:(QHInvokedUrlCommand *)command pictureOptions:(QHPictureOptions*)pictureOptions {
    QHCameraPicker* cameraPicker = [QHCameraPicker createFromPictureOptions:pictureOptions];
    
    self.pickerController = cameraPicker;
    
    cameraPicker.delegate = self;
    cameraPicker.callbackId = command.callbackId;
    // we need to capture this state for memory warnings that dealloc this object
    cameraPicker.webView = self.cameraPlugin.webView;
    __weak typeof(self) weakself = self;
    // Perform UI operations on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        // If a popover is already open, close it; we only want one at a time.
        if (([[weakself pickerController] pickerPopoverController] != nil) && [[[weakself pickerController] pickerPopoverController] isPopoverVisible]) {
            [[[weakself pickerController] pickerPopoverController] dismissPopoverAnimated:YES];
            [[[weakself pickerController] pickerPopoverController] setDelegate:nil];
            [[weakself pickerController] setPickerPopoverController:nil];
        }
        
        if ([weakself popoverSupported] && (pictureOptions.sourceType != UIImagePickerControllerSourceTypeCamera)) {
            if (cameraPicker.pickerPopoverController == nil) {
                cameraPicker.pickerPopoverController = [[NSClassFromString(@"UIPopoverController") alloc] initWithContentViewController:cameraPicker];
            }
            [weakself displayPopover:pictureOptions.popoverOptions];
            weakself.hasPendingOperation = NO;
        } else {
            [weakself.cameraPlugin.viewController presentViewController:cameraPicker animated:YES completion:^{
                weakself.hasPendingOperation = NO;
            }];
        }
    });
}

- (void)displayPopover:(NSDictionary*)options
{
    NSInteger x = 0;
    NSInteger y = 32;
    NSInteger width = 320;
    NSInteger height = 480;
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionAny;

    if (options) {
        x = [self integerValueForKey:options key:@"x" defaultValue:0];
        y = [self integerValueForKey:options key:@"y" defaultValue:32];
        width = [self integerValueForKey:options key:@"width" defaultValue:320];
        height = [self integerValueForKey:options key:@"height" defaultValue:480];
        arrowDirection = [self integerValueForKey:options key:@"arrowDir" defaultValue:UIPopoverArrowDirectionAny];
        if (![qh_org_apache_cordova_validArrowDirections containsObject:[NSNumber numberWithUnsignedInteger:arrowDirection]]) {
            arrowDirection = UIPopoverArrowDirectionAny;
        }
    }

    [[[self pickerController] pickerPopoverController] setDelegate:self];
    [[[self pickerController] pickerPopoverController] presentPopoverFromRect:CGRectMake(x, y, width, height)
                                                                       inView:[self.cameraPlugin.webView superview]
                                                     permittedArrowDirections:arrowDirection
                                                                     animated:YES];
}


- (BOOL)usesGeolocation
{
    id useGeo = [self.cameraPlugin.commandDelegate.settings objectForKey:[@"CameraUsesGeolocation" lowercaseString]];
    return [(NSNumber*)useGeo boolValue];
}

- (BOOL)popoverSupported
{
    return (NSClassFromString(@"UIPopoverController") != nil) &&
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSInteger)integerValueForKey:(NSDictionary*)dict key:(NSString*)key defaultValue:(NSInteger)defaultValue
{
    NSInteger value = defaultValue;

    NSNumber* val = [dict valueForKey:key];  // value is an NSNumber

    if (val != nil) {
        value = [val integerValue];
    }
    return value;
}

@end

@implementation QHCameraPicker

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIViewController*)childViewControllerForStatusBarHidden
{
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    SEL sel = NSSelectorFromString(@"setNeedsStatusBarAppearanceUpdate");
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel withObject:nil afterDelay:0];
    }

    [super viewWillAppear:animated];
}

+ (instancetype) createFromPictureOptions:(QHPictureOptions*)pictureOptions;
{
    QHCameraPicker* cameraPicker = [[QHCameraPicker alloc] init];
    cameraPicker.pictureOptions = pictureOptions;
    cameraPicker.sourceType = pictureOptions.sourceType;
    cameraPicker.allowsEditing = pictureOptions.allowsEditing;

    if (cameraPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // We only allow taking pictures (no video) in this API.
        cameraPicker.mediaTypes = @[(NSString*)kUTTypeImage];
        // We can only set the camera device if we're actually using the camera.
        cameraPicker.cameraDevice = pictureOptions.cameraDirection;
    } else if (pictureOptions.mediaType == MediaTypeAll) {
        cameraPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:cameraPicker.sourceType];
    } else {
        NSArray* mediaArray = @[(NSString*)(pictureOptions.mediaType == MediaTypeVideo ? kUTTypeMovie : kUTTypeImage)];
        cameraPicker.mediaTypes = mediaArray;
    }

    return cameraPicker;
}

@end

@implementation QHPictureOptions

+ (instancetype) createFromTakePictureArguments:(QHInvokedUrlCommand*)command
{
    QHPictureOptions* pictureOptions = [[QHPictureOptions alloc] init];

    pictureOptions.quality = [command argumentAtIndex:0 withDefault:@(50)];
    pictureOptions.destinationType = [[command argumentAtIndex:1 withDefault:@(QHDestinationTypeFileUri)] integerValue];
    pictureOptions.sourceType = [[command argumentAtIndex:2 withDefault:@(UIImagePickerControllerSourceTypeCamera)] unsignedIntegerValue];

    NSNumber* targetWidth = [command argumentAtIndex:3 withDefault:nil];
    NSNumber* targetHeight = [command argumentAtIndex:4 withDefault:nil];
    pictureOptions.targetSize = CGSizeMake(0, 0);
    if ((targetWidth != nil) && (targetHeight != nil)) {
        pictureOptions.targetSize = CGSizeMake([targetWidth floatValue], [targetHeight floatValue]);
    }

    id s = [command argumentAtIndex:5 withDefault:@(EncodingTypeJPEG)];
    pictureOptions.encodingType = [(NSNumber *)s integerValue];
    pictureOptions.mediaType = [[command argumentAtIndex:6 withDefault:@(MediaTypePicture)] unsignedIntegerValue];
    pictureOptions.allowsEditing = [[command argumentAtIndex:7 withDefault:@(NO)] boolValue];
    pictureOptions.correctOrientation = [[command argumentAtIndex:8 withDefault:@(NO)] boolValue];
    pictureOptions.saveToPhotoAlbum = [[command argumentAtIndex:9 withDefault:@(NO)] boolValue];
    pictureOptions.popoverOptions = [command argumentAtIndex:10 withDefault:nil];
    pictureOptions.cameraDirection = [[command argumentAtIndex:11 withDefault:@(UIImagePickerControllerCameraDeviceRear)] unsignedIntegerValue];
    
    pictureOptions.popoverSupported = NO;
    pictureOptions.usesGeolocation = NO;
    
    return pictureOptions;
}

@end
