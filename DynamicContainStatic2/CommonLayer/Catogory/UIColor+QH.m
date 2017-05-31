//
//  UIColor+QHFace.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "UIColor+QH.h"

@implementation UIColor (QH)

+ (UIColor *)qh_colorWithHex:(NSInteger)hex
{
    return [UIColor qh_colorWithHex:hex
                                alpha:1.0];
}

+ (UIColor *)qh_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((hex & 0XFF0000) >> 16) / 255.0
                           green:((hex & 0X00FF00) >> 8)  / 255.0
                            blue:(hex & 0X0000FF)         / 255.0
                           alpha:alpha];
}

+ (UIColor *)qh_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//默认alpha值为1
+ (UIColor *)qh_colorWithHexString:(NSString *)color
{
    return [self qh_colorWithHexString:color alpha:1.0f];
}

@end
