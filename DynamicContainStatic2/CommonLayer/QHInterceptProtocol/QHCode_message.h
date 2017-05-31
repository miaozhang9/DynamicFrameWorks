//
//  QHStateProtocol.h
//  QHLoanLib
//
//  Created by yinxukun on 2016/12/22.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>


//// 相机
//{code: 0, message: "设备无相机"};
//{code: 1, message: "无使用相机的权限"};
//{code: 2, message: "人脸识别失败"};

#define QHMsgLoseParas @{@"code": @"2000", @"message": @"缺少必要参数"}

#define QHMsgAbandonUsePlugin @{@"code": @"2001", @"message": @"主动退出插件"}

#define QHMsgOther @{@"code": @"2006", @"message": @"未知错误"}

#define QHMsgNoCamera @{@"code": @0, @"message": @"设备无相机"}

#define QHMsgNoAuthority @{@"code": @1, @"message": @"无相机权限"}

#define QHMsgFaceRecognitionFailed @{@"code": @2, @"message": @"人脸识别失败"}

