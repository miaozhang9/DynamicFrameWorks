//
//  QHFetchCardViewController.h
//  PANewToapAPP
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface QHFetchCardViewController : UIViewController

@property (nonatomic, assign) BOOL isIconLeft;

@property (nonatomic, strong) UIImage *argIcon;

@property (nonatomic, copy) NSString *argText;

@property (nonatomic, copy) void(^cameraCompleteAction)(UIImage *img, NSDictionary *errorInfo);

@end






