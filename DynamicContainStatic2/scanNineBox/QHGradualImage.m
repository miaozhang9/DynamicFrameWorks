//
//  QHGradualImage.m
//  QHLoanlib
//
//  Created by guopengwen on 2017/5/14.
//  Copyright © 2017年 Miaoz. All rights reserved.
//

#import "QHGradualImage.h"

@implementation QHGradualImage

#pragma mark - 创建圆形的渐变色image
- (UIImage *)createCircleGradualImageWithRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    //创建CGContextRef
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    [self drawRadialGradient:gc path:path startColor:startColor.CGColor endColor:endColor.CGColor];
    CGPathRelease(path);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMaxY(pathRect));
    
    double r = pow(pathRect.size.width, 2) + pow(pathRect.size.height, 2);
    
    CGFloat radius = sqrt(r);
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - 裁剪image
- (UIImage *)clipImageWithRect:(CGRect)clipRect image:(UIImage *)clipImage {
    CGImageRef imageRef = CGImageCreateWithImageInRect([clipImage CGImage], clipRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

@end
