//
//  QHBasicProtocol.h
//  QHLoanlib
//
//  Created by Miaoz on 2017/5/23.
//  Copyright © 2017年 Miaoz. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol QHBasicProtocol <NSObject>
//得到用户账户信息
-(NSDictionary *)getAgentUserInfo;
//跳转new的Page
-(BOOL)openNewPageWithUrl:(NSString *)url;

//打开调起登录
-(void)openLaunchLoginPage;

@end
