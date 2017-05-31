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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QHPlugin.h"

enum QHLocationStatus {
    QHPERMISSIONDENIED = 1,
    QHPOSITIONUNAVAILABLE,
    QHTIMEOUT
};
typedef NSUInteger QHLocationStatus;

// simple object to keep track of location information
@interface QHLocationData : NSObject {
    QHLocationStatus locationStatus;
    NSMutableArray* locationCallbacks;
    NSMutableDictionary* watchCallbacks;
    CLLocation* locationInfo;
}

@property (nonatomic, assign) QHLocationStatus locationStatus;
@property (nonatomic, strong) CLLocation* locationInfo;
@property (nonatomic, strong) NSMutableArray* locationCallbacks;
@property (nonatomic, strong) NSMutableDictionary* watchCallbacks;

@end

@interface QHGeoLocationPlugin : QHPlugin <CLLocationManagerDelegate>{
    @private BOOL __locationStarted;
    @private BOOL __highAccuracyEnabled;
    @private BOOL _showAlertSetting;
    QHLocationData *locationData;
}

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) QHLocationData* locationData;

- (void)getLocation:(QHInvokedUrlCommand*)command;
- (void)addWatch:(QHInvokedUrlCommand*)command;
- (void)clearWatch:(QHInvokedUrlCommand*)command;
- (void)returnLocationInfo:(NSString*)callbackId andKeepCallback:(BOOL)keepCallback;
- (void)returnLocationError:(NSUInteger)QHErrorCode withMessage:(NSString*)message;
- (void)startLocation:(BOOL)enableHighAccuracy;

- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation;

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error;

- (BOOL)isLocationServicesEnabled;
@end
