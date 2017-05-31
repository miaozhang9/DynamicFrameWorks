//
//  QHLoanDoorTools.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********此版本号打包配置项，key不可更改**********/
#define QHLoanDoorVersion_Key @"1.0.0"

@interface QHLoanDoorBundle : NSObject

+ (NSBundle *)bundle;

+ (NSString *)filePath:(NSString *)fileName;

+ (NSString *)filePath:(NSString *)fileName type:(NSString *)type;

+ (UIImage *)imageNamed:(NSString *)imgName;

+ (NSString *)version;

+ (NSDictionary *)infoPlist;

@end


