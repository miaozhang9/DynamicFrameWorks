//
//  NSBundle+QH.m
//  QHLoanlib
//
//  Created by Miaoz on 2017/4/12.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "NSBundle+QH.h"

#import <objc/runtime.h>

#define credoo_exchangeMethod(oneClass, fromSEL, toSEL)\
if (!class_addMethod(oneClass, @selector(toSEL), \
method_getImplementation(class_getInstanceMethod(oneClass, @selector(toSEL))), method_getTypeEncoding(class_getInstanceMethod(oneClass, @selector(fromSEL))))) {\
method_exchangeImplementations(class_getInstanceMethod(oneClass, @selector(fromSEL)), class_getInstanceMethod(oneClass, @selector(toSEL)));\
}\
else{\
class_replaceMethod(oneClass, @selector(toSEL), method_getImplementation(class_getInstanceMethod(oneClass, @selector(fromSEL))),method_getTypeEncoding(class_getInstanceMethod(oneClass, @selector(fromSEL))));\
}

@implementation NSBundle (QH)

//+ (void)load {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        credoo_exchangeMethod([self class], bundleIdentifier, hook_bundleIdentifier);
//    });
//}
//
//- (NSString *)hook_bundleIdentifier {
//    NSString *realIdentifer = [self hook_bundleIdentifier];
//    if (self == [NSBundle mainBundle]) {
//        NSLog(@"%@", realIdentifer);
//        if ([realIdentifer isEqualToString:@"com.pingan.yztDev"]) {
//            return @"cn.com.yuelaoban";
//        } else {
//        return @"com.pingan.yztDev";
//        }
//    }
//    return realIdentifer;
//}
@end
