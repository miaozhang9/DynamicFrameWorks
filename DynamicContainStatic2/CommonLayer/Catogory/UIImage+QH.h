//
//  UIImage+QH.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/17.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QH)

- (BOOL)qh_saveImageName:(NSString *)imageName callBack:(void(^)(NSString *imagePath))callBack;

//指定宽度按比例缩放
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

- (UIImage *)qh_scaleImageToScale:(float)scaleSize;

- (UIImage*)qh_getSubImageInRect:(CGRect)rect;

//压缩图片所占内存大小
- (UIImage *)qh_toDiskSize:(CGFloat)size;

- (NSString *)qh_toBase64;

+ (UIImage *)qh_base64ToImage:(NSString *)strEncodeData;

@end
