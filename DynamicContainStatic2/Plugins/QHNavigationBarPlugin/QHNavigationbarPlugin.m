//
//  QHNavigationbar.m
//  LoanLib
//
//  Created by guopengwen on 16/12/19.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHNavigationbarPlugin.h"
#import "UIColor+QH.h"
#import "QHViewController.h"
@interface QHNavigationbarPlugin ()

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) NSDictionary *pickedContactDictionary;

@end

@implementation QHNavigationbarPlugin
static QHNavigationbarPlugin *plugin;

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plugin = [[self alloc] init];
    });
    return plugin;
}

- (void)setNaviBarTitle:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    NSString *title = [command argumentAtIndex:0 withDefault:[NSNull null]];
    self.viewController.navigationItem.title = title;
    
}

- (void)showNavigationBar:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    BOOL isShow = [[command argumentAtIndex:0 withDefault:[NSNull null]] boolValue];
    UINavigationController *naviVC = self.viewController.navigationController;
    [naviVC setNavigationBarHidden:!isShow animated:YES];
}

-(void)setNavibarTitleColor:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    NSString *color = [command argumentAtIndex:0 withDefault:[NSNull null]];
    self.viewController.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor qh_colorWithHexString:color]};
    //,NSFontAttributeName:[UIFontboldSystemFontOfSize:17]
}

-(void)setNaviBarColor:(QHInvokedUrlCommand*)command
{
    
    _callbackId = command.callbackId;
     NSString *color = [command argumentAtIndex:0 withDefault:[NSNull null]];
    self.viewController.navigationController.navigationBar.barTintColor = [UIColor qh_colorWithHexString:color];
}

-(void)setNaviLeftBarButtonItemColor:(QHInvokedUrlCommand*)command {
    _callbackId = command.callbackId;
     NSString *color = [command argumentAtIndex:0 withDefault:[NSNull null]];
//    self.viewController.navigationController.navigationBar.tintColor = [UIColor qh_colorWithHexString:color];
    [(QHViewController *)self.viewController setBackBtnTitleColor:@"" backImg:color];
}

-(void)openNewPageWithUrl:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    NSString *url = [command argumentAtIndex:0 withDefault:[NSNull null]];
    QHViewController *vc = (QHViewController *)self.viewController;
    if (vc.basicDelegate && [vc.basicDelegate respondsToSelector:@selector(openNewPageWithUrl:)]) {
        BOOL isSuccess = [vc.basicDelegate openNewPageWithUrl:url];
        QHPluginResult *result = [QHPluginResult resultWithStatus:QHCommandStatus_OK messageAsBool:isSuccess];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

-(void)closeAllPage:(QHInvokedUrlCommand*)command
{
    _callbackId = command.callbackId;
    if (self.viewController.presentingViewController)
    {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.viewController.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)openLaunchLoginPage:(QHInvokedUrlCommand*)command
{
     _callbackId = command.callbackId;
    QHViewController *vc = (QHViewController *)self.viewController;
    if (vc.basicDelegate && [vc.basicDelegate respondsToSelector:@selector(openLaunchLoginPage)]) {
        [vc.basicDelegate openLaunchLoginPage];
    }
}


@end
