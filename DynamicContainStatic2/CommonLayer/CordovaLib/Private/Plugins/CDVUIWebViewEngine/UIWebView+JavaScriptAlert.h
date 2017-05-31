//
//  UIWebView+JavaScriptAlert.h
//  QHLoanlib
//
//  Created by guopengwen on 16/12/30.
//  Copyright © 2016年 Miaoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)

-(void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

-(BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

@end
