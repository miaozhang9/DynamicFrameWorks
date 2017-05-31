//
//  QHAlertManager.h
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/4.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QHAlertManager : NSObject

@property (nonatomic, strong) UIViewController *viewController;

+ (instancetype)shareAlertManager;

- (void)showAlertMessageWithMessage:(NSString *)message;


@end
