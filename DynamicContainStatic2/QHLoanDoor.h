//
//  QHLoanDoor.h
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QHLoanDoorEnvironment) {
    QHLoanDoorEnvironment_stg, //测试环境
    QHLoanDoorEnvironment_prd, //预发布环境
    QHLoanDoorEnvironment_pdt, //生产环境
};


@interface QHLoanDoor : NSObject

//test 用
@property (nonatomic, copy) NSString *startPage;

+ (instancetype)share;
/**
 *
 *  version 版本号
 *
 */
//+ (NSString *)version;
/**
 *
 *  启动SDK
 *
 *  @param  paras  启动参数实体
 *  @param  environment 环境配置
 *  @param  startPage h5url
 *  @param  successBlock 启动成功回调
 *  @param  failBlock    启动失败回调
 *
 */
- (void)launchDoor:(NSDictionary *)paras
      startPageUrl:(NSString *)startPage
       environment:(QHLoanDoorEnvironment)environment
      successBlock:(void(^)())successBlock
         failBlock:(void(^)(NSError *))failBlock;


/**
 启动SDK

 @param paras 启动参数实体
 @param title 九宫格页面title
 @param environment 环境配置
 @param successBlock 启动成功回调
 @param failBlock 启动失败回调
 */
- (void)launchScanLink:(NSDictionary *)paras
                 title:(NSString *)title
           environment:(QHLoanDoorEnvironment)environment
          successBlock:(void(^)())successBlock
             failBlock:(void(^)(NSError *error))failBlock;


/**
 启动SDK

 @param paras 启动参数实体
 @param environment 环境配置
 @param successBlock 启动成功回调
 @param failBlock 启动失败回调
 */
- (void)launchScanResult:(NSDictionary *)paras
             environment:(QHLoanDoorEnvironment)environment
            successBlock:(void(^)())successBlock
               failBlock:(void(^)(NSError *error))failBlock;
/**
 注册SDK
 */
-(void)registerQHLoanSDK;

@end

