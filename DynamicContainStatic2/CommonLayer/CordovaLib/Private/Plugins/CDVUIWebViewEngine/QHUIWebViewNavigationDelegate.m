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

#import "QHUIWebViewNavigationDelegate.h"
#import "QHViewController.h"
#import "QHCommandDelegateImpl.h"
#import "QHUserAgentUtil.h"
#import <objc/message.h>

@implementation QHUIWebViewNavigationDelegate

- (instancetype)initWithEnginePlugin:(QHPlugin*)theEnginePlugin
{
    self = [super init];
    if (self) {
        self.enginePlugin = theEnginePlugin;
    }

    return self;
}

/**
 When web application loads Add stuff to the DOM, mainly the user-defined settings from the Settings.plist file, and
 the device's data such as device ID, platform version, etc.
 */
- (void)webViewDidStartLoad:(UIWebView*)theWebView
{
    NSLog(@"Resetting plugins due to page load.");
    QHViewController* vc = (QHViewController*)self.enginePlugin.viewController;

    [vc.commandQueue resetRequestId];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHPluginResetNotification object:self.enginePlugin.webView]];
}

/**
 Called when the webview finishes loading.  This stops the activity view.
 */
- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    NSLog(@"Finished load of: %@", theWebView.request.URL);
    QHViewController* vc = (QHViewController*)self.enginePlugin.viewController;

    NSString *theTitle=[theWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (theTitle.length > 0) {
        vc.navigationItem.title = theTitle;
    }
    
    // It's safe to release the lock even if this is just a sub-frame that's finished loading.
    [QHUserAgentUtil releaseLock:vc.userAgentLockToken];

    /*
     * Hide the Top Activity THROBBER in the Battery Bar
     */
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHPageDidLoadNotification object:self.enginePlugin.webView]];
}

- (void)webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    QHViewController* vc = (QHViewController*)self.enginePlugin.viewController;

    [QHUserAgentUtil releaseLock:vc.userAgentLockToken];

    NSString* message = [NSString stringWithFormat:@"Failed to load webpage with error: %@", [error localizedDescription]];
    NSLog(@"%@", message);

    NSURL* errorUrl = vc.errorURL;
    if (errorUrl) {
        errorUrl = [NSURL URLWithString:[NSString stringWithFormat:@"?error=%@", [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] relativeToURL:errorUrl];
        NSLog(@"%@", [errorUrl absoluteString]);
        [theWebView loadRequest:[NSURLRequest requestWithURL:errorUrl]];
    }
}

- (BOOL)defaultResourcePolicyForURL:(NSURL*)url
{
    /*
     * If a URL is being loaded that's a file url, just load it internally
     */
    if ([url isFileURL]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = [request URL];
    QHViewController* vc = (QHViewController*)self.enginePlugin.viewController;

    /*
     * Execute any commands queued with cordova.exec() on the JS side.
     * The part of the URL after gap:// is irrelevant.
     */
    if ([[url scheme] isEqualToString:@"gap"]) {
        [vc.commandQueue fetchCommandsFromJs];
        // The delegate is called asynchronously in this case, so we don't have to use
        // flushCommandQueueWithDelayedJs (setTimeout(0)) as we do with hash changes.
        [vc.commandQueue executePending];
        return NO;
    }

    /*
     * Give plugins the chance to handle the url
     */
    BOOL anyPluginsResponded = NO;
    BOOL shouldAllowRequest = NO;
    
    for (NSString* pluginName in vc.pluginObjects) {
        QHPlugin* plugin = [vc.pluginObjects objectForKey:pluginName];
        SEL selector = NSSelectorFromString(@"shouldOverrideLoadWithRequest:navigationType:");
        if ([plugin respondsToSelector:selector]) {
            anyPluginsResponded = YES;
            shouldAllowRequest = (((BOOL (*)(id, SEL, id, int))objc_msgSend)(plugin, selector, request, navigationType));
            if (!shouldAllowRequest) {
                break;
            }
        }
    }
    
    if (anyPluginsResponded) {
        return shouldAllowRequest;
    }

    /*
     * Handle all other types of urls (tel:, sms:), and requests to load a url in the main webview.
     */
    BOOL shouldAllowNavigation = [self defaultResourcePolicyForURL:url];
    if (shouldAllowNavigation) {
        return YES;
    } else {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:QHPluginHandleOpenURLNotification object:url]];
    }
    
    return NO;
}

@end
