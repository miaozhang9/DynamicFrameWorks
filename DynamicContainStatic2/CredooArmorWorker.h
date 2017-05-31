//
//  Credoocdid.h
//  Credoocdid
//
//  Created by yinxukun on 16/1/11.
//  Copyright © 2016年 Credoocd. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCredoocdGPSInfoDidChangeNotification; // GPS定位信息改变通知名

@interface CredooArmorWorker: NSObject

+ (instancetype)sharedInstance;

/**
 *  采集数据
 *  @param contain 是否包含通讯录
 *  * success 是否采集设备信息成功
 *  * collectData   采集到的设备信息
 *  * errorMsg 错误信息
 */
- (void)collectDataContainAllContacts:(BOOL)contain
                             callBack:(void(^)(BOOL success, NSDictionary *collectData, NSString *errorMsg))callBack;
///获取通讯录
- (void)getAddressBookWithCompletion:(void(^)(BOOL success, NSArray <NSDictionary *>*addressBook))complete;

@end



