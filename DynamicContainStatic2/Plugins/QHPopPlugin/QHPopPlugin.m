//
//  QHPopPlugin.m
//  QHLoanlib
//
//  Created by yinxukun on 2016/12/28.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QHPopPlugin.h"

@implementation QHPopPlugin

- (void)sheet:(QHInvokedUrlCommand *)command{
    NSString *title = command.arguments[0];
    NSString *detail = command.arguments[1];
    NSArray *btnTitles = command.arguments[2];

    UIAlertController *actSheet = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleActionSheet];
    [self.viewController presentViewController:actSheet animated:YES completion:nil];

    __weak typeof(self) weakself = self;
    for (NSString *btnTitle in btnTitles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [actSheet addAction:action];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [actSheet addAction:cancelAction];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

}


@end
