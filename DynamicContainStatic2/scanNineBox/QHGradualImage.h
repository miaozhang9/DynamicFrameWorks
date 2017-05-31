//
//  QHGradualImage.h
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/14.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QHGradualImage : NSObject

/**
 创建一个圆形（圆心在左下角）的渐变色image
 
 @param rect 图片大小
 @param startColor 起始颜色
 @param endColor 结束颜色
 @return 渐变色image
 */
- (UIImage *)createCircleGradualImageWithRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor;


/**
 裁剪图片的指定区域
 
 @param clipRect 指定裁剪的区域
 @param clipImage 被裁剪图片
 @return 裁剪所得图片
 */
- (UIImage *)clipImageWithRect:(CGRect)clipRect image:(UIImage *)clipImage;

@end
