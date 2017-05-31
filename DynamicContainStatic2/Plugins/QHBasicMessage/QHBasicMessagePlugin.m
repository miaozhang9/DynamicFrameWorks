//
//  QHBasicMessagePlugin.m
//  LoanLib
//
//  Created by guopengwen on 16/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHBasicMessagePlugin.h"
#import "NSMutableDictionary+QH.h"
#import "QHLoanDoorBundle.h"
#import "CredooArmorWorker.h"
#import "QHViewController.h"
@implementation QHBasicMessagePlugin

// 获取BundleID
- (NSString*) getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

// 获取app的名字
- (NSString*) getAppName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

// 获取app版本号
- (NSString*) getLocalAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 获取app build版本号
- (NSString *)getBundleVersion{
    return [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];
}

// 手机别名--用户定义的名称
- (NSString *)getDeviceName
{
    return [[UIDevice currentDevice] name];
}

// 手机系统名称
- (NSString *)getDeviceSystemName
{
    return [[UIDevice currentDevice] systemName];
}

// 手机系统版本
- (NSString *)getDeviceSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}


// 手机型号
- (NSString *)getDeviceModel
{
    return [[UIDevice currentDevice] model];
}

// 地方型号(国际化区域名称）
- (NSString *)getDeviceLocalModel
{
    return [[UIDevice currentDevice] localizedModel];
}

- (NSDictionary *)getAppMessage
{
    NSMutableDictionary *madic = [NSMutableDictionary dictionary];
    [madic qh_setString:[self getBundleID]  forKey:qhAppBundleID];
    [madic qh_setString:[self getAppName]  forKey:qhAppName];
    [madic qh_setString:[self getLocalAppVersion]  forKey:qhAppVersion];
    [madic qh_setString:[self getBundleVersion]  forKey:qhAppBuildVersion];
    return [madic copy];
}

- (NSDictionary *)getDeviceMessage
{
    NSMutableDictionary *madic = [NSMutableDictionary dictionary];
    [madic qh_setString:[self getDeviceName] forKey:qhDeviceName];
    [madic qh_setString:[self getDeviceSystemName] forKey:qhDeviceSystemName];
    [madic qh_setString:[self getDeviceSystemVersion] forKey:qhDeviceSystemVersion];
    [madic qh_setString:[self getDeviceModel] forKey:qhDeviceModel];
    [madic qh_setString:[self getDeviceLocalModel] forKey:qhDeviceLocalModel];
    return [madic copy];
}

- (NSDictionary *)getAllMessage
{
    NSMutableDictionary *madic = [NSMutableDictionary dictionaryWithDictionary:[self getAppMessage]];
    [madic addEntriesFromDictionary:[self getDeviceMessage]];
    [madic setObject:[QHLoanDoorBundle version] forKey:qhSDKVersion];
    return [madic copy];
}

// 获取SDK的版本号
- (void)getSDKVersion:(QHInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsString:[QHLoanDoorBundle version]];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)searchSomeMessage:(QHInvokedUrlCommand*)command{
    NSString* callbackId = command.callbackId;
    NSArray* options = [command argumentAtIndex:0 withDefault:[NSNull null]];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    if (options.count > 0 && ![options[0] isEqualToString:@"all"]) {
        NSDictionary *dic = [self getAllMessage];
        NSArray *keys = [dic allKeys];
        for (NSString *str in options) {
            if ([keys containsObject:str]) {
                [mdic setObject:[dic objectForKey:str] forKey:str];
            }
        }
    } else if ([options[0] isEqualToString:@"all"]) {
        mdic = [[self getAllMessage] copy];
    }
    
    if (mdic.count == 0) {
        mdic = [@{} mutableCopy];
    }
    
    QHPluginResult* result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:[mdic copy]];
    [self.commandDelegate sendPluginResult:result callbackId:callbackId];
}

-(void)getDeviceInfo:(QHInvokedUrlCommand *)command {
    
    [[CredooArmorWorker sharedInstance] collectDataContainAllContacts:NO callBack:^(BOOL success, NSDictionary *collectData, NSString *errorMsg) {
        
        if (success) {
            QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:collectData];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        } else {
            QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:@{@"errorMsg":errorMsg}];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        }
        
    }];

    
}

-(void)getAgentUserInfo:(QHInvokedUrlCommand *)command {
    QHViewController *vc = (QHViewController *)self.viewController;
    if (vc.basicDelegate && [vc.basicDelegate respondsToSelector:@selector(getAgentUserInfo)]) {
        NSDictionary *dic = [vc.basicDelegate getAgentUserInfo];
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsDictionary:dic];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

@end
