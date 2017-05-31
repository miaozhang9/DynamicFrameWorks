//
//  UIImage+QH.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/17.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "UIImage+QH.h"

@implementation UIImage (QH)

#pragma mark  保存图片到document

- (BOOL)qh_saveImageName:(NSString *)imageName callBack:(void(^)(NSString *imagePath))callBack{

    NSString *path = [self qh_getImageDocumentFolderPath];
    NSData *imageData = UIImagePNGRepresentation(self);
    NSString *documentsDirectory = [NSString stringWithFormat:@"%@/", path];
    // Now we get the full path to the file
    NSString *imageFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //如果文件路径存在的话
    BOOL bRet = [fileManager fileExistsAtPath:imageFile];
    if (bRet)
    {
        //        NSLog(@"文件已存在");
        if ([fileManager removeItemAtPath:imageFile error:nil])
        {
            //            NSLog(@"删除文件成功");
            if ([imageData writeToFile:imageFile atomically:YES])
            {
                //                NSLog(@"保存文件成功");
                callBack(imageFile);
            }
        }
        else
        {

        }
    }
    else
    {
        BOOL success = [imageData writeToFile:imageFile atomically:YES];
        if (!success)
        {
            [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            if ([imageData writeToFile:imageFile atomically:YES])
            {
                callBack(imageFile);
            }
        }
        else
        {
            callBack(imageFile);
            return YES;
        }

    }
    return NO;
}

#pragma mark  从文档目录下获取Documents路径

- (NSString *)qh_getImageDocumentFolderPath{

    NSString *patchDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSString stringWithFormat:@"%@/Images", patchDocument];
}

//1.等比率缩放
- (UIImage *)qh_scaleImageToScale:(float)scaleSize

{
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize);
    rect = CGRectIntegral(rect);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//图片裁剪
-(UIImage*)qh_getSubImageInRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);

    return smallImage;
}

//压缩图片所占内存大小

- (UIImage *)qh_toDiskSize:(CGFloat)size{

    UIImage *newImage = self;
    NSData *newImageData = nil;
    for (CGFloat scale = 0.95; scale > 0; scale -= 0.05) {
        newImageData = UIImageJPEGRepresentation(newImage, scale);
        newImage = [UIImage imageWithData:newImageData];
        NSLog(@"____%li____", newImageData.length);
        if (newImageData.length/1000 < size) {
            break;
        }
        else if (newImageData.length/1000 > size) {
            scale = scale * 2.0/3.0;
        }
    }
    NSLog(@"%li", newImageData.length/1000);

    return newImage;
}

//指定宽度按比例缩放
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{

    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if(CGSizeEqualToSize(imageSize, size) == NO){

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if(widthFactor > heightFactor){

            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;

        }else if(widthFactor < heightFactor){

            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil){

        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


- (NSString *)qh_toBase64{

    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)qh_base64ToImage:(NSString *)strEncodeData{

    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}


@end
