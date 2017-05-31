//
//  QHSacnQrCodePlugin.h
//  HelloWorld
//
//  Created by guopengwen on 16/12/15.
//  Copyright © 2016年 guopengwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHPlugin.h"

@interface QHScanQrCodePlugin : QHPlugin

- (void)scanQrCode:(QHInvokedUrlCommand*)command;

@end
