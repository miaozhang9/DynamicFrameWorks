//
//  QHFaceCheckDelegate.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/20.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QHFaceCheckDelegate : NSObject

+ (instancetype)shareDelegate;

/// 0、isSuccess 1、picture  2、faceImage 3、otherInfo
@property (nonatomic, copy) void(^faceRecognitionComplete)(BOOL isSuccess, UIImage *oriImg, UIImage *faceImg, NSDictionary *);

//@property (nonatomic, assign) CGFloat maxSize;

@end
