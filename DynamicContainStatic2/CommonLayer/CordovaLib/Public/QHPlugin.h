/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QHPluginResult.h"
#import "NSMutableArray+QHQueueAdditions.h"
#import "QHCommandDelegate.h"
#import "QHWebViewEngineProtocol.h"

@interface UIView (org_apache_cordova_UIView_Extension)

@property (nonatomic, weak) UIScrollView* scrollView;

@end

extern NSString* const QHPageDidLoadNotification;
extern NSString* const QHPluginHandleOpenURLNotification;
extern NSString* const QHPluginResetNotification;
extern NSString* const QHLocalNotification;
extern NSString* const QHRemoteNotification;
extern NSString* const QHRemoteNotificationError;
extern NSString* const QHViewWillAppearNotification;
extern NSString* const QHViewDidAppearNotification;
extern NSString* const QHViewWillDisappearNotification;
extern NSString* const QHViewDidDisappearNotification;
extern NSString* const QHViewWillLayoutSubviewsNotification;
extern NSString* const QHViewDidLayoutSubviewsNotification;
extern NSString* const QHViewWillTransitionToSizeNotification;

@interface QHPlugin : NSObject {}

@property (nonatomic, readonly, weak) UIView* webView;
@property (nonatomic, readonly, weak) id <QHWebViewEngineProtocol> webViewEngine;

@property (nonatomic, weak) UIViewController* viewController;
@property (nonatomic, weak) id <QHCommandDelegate> commandDelegate;

@property (readonly, assign) BOOL hasPendingOperation;

- (void)pluginInitialize;

- (void)handleOpenURL:(NSNotification*)notification;
- (void)onAppTerminate;
- (void)onMemoryWarning;
- (void)onReset;
- (void)dispose;

/*
 // see initWithWebView implementation
 - (void) onPause {}
 - (void) onResume {}
 - (void) onOrientationWillChange {}
 - (void) onOrientationDidChange {}
 - (void)didReceiveLocalNotification:(NSNotification *)notification;
 */

- (id)appDelegate;

@end
