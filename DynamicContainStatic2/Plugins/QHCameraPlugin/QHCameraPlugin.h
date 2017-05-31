//
//  QHCameraPlugin.h
//  QHLoanLib
//
//  Created by yinxukun on 2016/12/21.
//  Copyright © 2016年 Miaoz. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "QHPlugin.h"
#import <UIKit/UIKit.h>

@interface QHCameraPlugin : QHPlugin

- (void)faceRecognition:(QHInvokedUrlCommand *)command;
- (void)fetchFace:(QHInvokedUrlCommand *)command;
- (void)fetchCard:(QHInvokedUrlCommand *)command;
- (void)pickPhoto:(QHInvokedUrlCommand *)command;

@end

