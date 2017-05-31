//
//  QHLoanDoor.m
//  LoanLib
//
//  Created by yinxukun on 2016/12/16.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import "QHLoanDoor.h"

#import "QHViewController.h"
#import "QHInterceptProtocol.h"
#import "QHLoanDoorBundle.h"
#import "UIColor+QH.h"
#import "QHNavigationbarPlugin.h"
#import "QH.h"
#import "QHNineBoxViewController.h"
#import "QHScanResultViewController.h"

@interface  QHLoanDoor ()

@property (nonatomic, assign) QHLoanDoorEnvironment environment;
@property (nonatomic, strong) QHViewController *viewController;
@end

@implementation QHLoanDoor

static QHLoanDoor *door;

+ (instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        door = [[self alloc] init];
    });
    return door;
}

- (instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

-(void)registerQHLoanSDK{
    [NSURLProtocol registerClass:[QHInterceptProtocol class]];
   
}

- (void)launchDoor:(NSDictionary *)paras
      startPageUrl:(NSString *)startPage
       environment:(QHLoanDoorEnvironment)environment
      successBlock:(void(^)())successBlock
         failBlock:(void(^)(NSError *))failBlock{

    [NSURLProtocol registerClass:[QHInterceptProtocol class]];

    self.environment = environment;
   
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (!window) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    UIViewController *rootCtrl = window.rootViewController;
    if (!rootCtrl) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    QHViewController *viewController = [[QHViewController alloc] init];
    _viewController = viewController;
    viewController.startPage = startPage ? startPage : nil;
    viewController.baseUserAgent = @"ToCred";
    [viewController view];
    viewController.navigationController.navigationBar.translucent = NO;
    // self.viewController.title = @"支持插件列表";
    [rootCtrl presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:^{
        
        if (successBlock) {
            successBlock();
        }
    }];
   
    [self setPageUI:paras];
    
}

-(void)setPageUI:(NSDictionary *)paras {
    _viewController.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor qh_colorWithHexString:paras[@"BarTitleColor"]]};
    _viewController.navigationController.navigationBar.barTintColor = [UIColor qh_colorWithHexString:paras[@"BarColor"]];
}

- (void)launchScanLink:(NSDictionary *)paras
                 title:(NSString *)title
           environment:(QHLoanDoorEnvironment)environment
          successBlock:(void(^)())successBlock
             failBlock:(void(^)(NSError *error))failBlock{
    
    [NSURLProtocol registerClass:[QHInterceptProtocol class]];
    
    self.environment = environment;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (!window) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    UIViewController *rootCtrl = window.rootViewController;
    if (!rootCtrl) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    QHNineBoxViewController *viewController = [[QHNineBoxViewController alloc] init];
    viewController.titleStr = title;
    [viewController view];
    viewController.navigationController.navigationBar.translucent = NO;
    [rootCtrl presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:^{
        
        if (successBlock) {
            successBlock();
        }
    }];
    [self setPageUI:paras];
}

- (void)launchScanResult:(NSDictionary *)paras
           environment:(QHLoanDoorEnvironment)environment
          successBlock:(void(^)())successBlock
             failBlock:(void(^)(NSError *error))failBlock{
    
    [NSURLProtocol registerClass:[QHInterceptProtocol class]];
    
    self.environment = environment;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (!window) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    UIViewController *rootCtrl = window.rootViewController;
    if (!rootCtrl) {
        NSError *error = [NSError errorWithDomain:@"no key window" code:0 userInfo:@{}];
        if (failBlock) {
            failBlock(error);
        }
        return;
    }
    QHScanResultViewController *viewController = [[QHScanResultViewController alloc] init];
    [viewController view];
    viewController.navigationController.navigationBar.translucent = NO;
    [rootCtrl presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:^{
        
        if (successBlock) {
            successBlock();
        }
    }];
    [self setPageUI:paras];
}



@end

