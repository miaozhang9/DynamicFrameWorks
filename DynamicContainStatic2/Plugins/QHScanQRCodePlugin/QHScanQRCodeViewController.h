//
//  QHCardPassportScanCodeViewController.h
//  PANewToapAPP
//
//  Created by guopengwen on 16/8/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void(^ScanResult)(NSDictionary *);

@interface QHScanQRCodeViewController : UIViewController

@property (nonatomic, copy) ScanResult scanCodeResult;

@end
