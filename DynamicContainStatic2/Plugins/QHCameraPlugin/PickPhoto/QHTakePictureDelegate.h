//
//  QHTakePictureDelegate.h
//  QHLoanlib
//
//  Created by yinxukun on 2016/12/29.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHCameraPlugin.h"

typedef NS_ENUM(NSUInteger, QHDestinationType){
    QHDestinationTypeDataUrl = 0,
    QHDestinationTypeFileUri,
    QHDestinationTypeNativeUri
};

typedef NS_ENUM(NSUInteger, QHEncodingType){
    EncodingTypeJPEG = 0,
    EncodingTypePNG
};

typedef NS_ENUM(NSUInteger, QHMediaType){
    MediaTypePicture = 0,
    MediaTypeVideo,
    MediaTypeAll
};

@interface QHTakePictureDelegate : NSObject

- (void)pickPhoto:(QHInvokedUrlCommand *)command cameraPlugin:(QHCameraPlugin *)plugin;

@end


@interface QHPictureOptions : NSObject

@property (strong) NSNumber* quality;
@property (assign) QHDestinationType destinationType;
@property (assign) UIImagePickerControllerSourceType sourceType;
@property (assign) CGSize targetSize;
@property (assign) QHEncodingType encodingType;
@property (assign) QHMediaType mediaType;
@property (assign) BOOL allowsEditing;
@property (assign) BOOL correctOrientation;
@property (assign) BOOL saveToPhotoAlbum;
@property (strong) NSDictionary* popoverOptions;
@property (assign) UIImagePickerControllerCameraDevice cameraDirection;

@property (assign) BOOL popoverSupported;
@property (assign) BOOL usesGeolocation;
@property (assign) BOOL cropToSize;

+ (instancetype) createFromTakePictureArguments:(QHInvokedUrlCommand*)command;

@end

@interface QHCameraPicker : UIImagePickerController

@property (strong) QHPictureOptions* pictureOptions;

@property (copy)   NSString* callbackId;
@property (copy)   NSString* postUrl;
@property (strong) UIPopoverController* pickerPopoverController;
@property (assign) BOOL cropToSize;
@property (strong) UIView* webView;

+ (instancetype) createFromPictureOptions:(QHPictureOptions*)options;

@end
