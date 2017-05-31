//
//  UIColor+QHFace.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QH)

+ (UIColor *)qh_colorWithHex:(NSInteger)hex;

+ (UIColor *)qh_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)qh_colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)qh_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
