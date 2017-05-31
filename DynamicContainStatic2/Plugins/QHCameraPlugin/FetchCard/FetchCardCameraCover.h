//
//  FetchCardCameraCover.h
//  PANewToapAPP
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FetchCardCameraCover : UIView

- (instancetype)initWithFrame:(CGRect)frame
                      bgColor:(UIColor *)bgColor
                    alphaArea:(CGRect)alphaRect
              alphaAreaRadius:(CGFloat)radius;

- (void)resetAlphaArea:(CGRect)alphaRect;

- (void)addColorRadius:(UIColor *)color;

@end

@interface QHFetchCardAlphaRect : UIView

- (instancetype)initWithRotation:(CGFloat)rotation color:(UIColor *)color lineWidth:(CGFloat)lineWidth;

@end
