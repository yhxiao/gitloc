//
//  AppDelegate.h
//  LocShare
//
//  Created by yxiao on 6/7/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSKeychain.h"
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <KinveyKit/KinveyKit.h>
#import "LoginViewController.h"
#import "FriendList.h"
#import "CommonFunctions.h"
#import "PrivSetting.h"
//#import "PrivacyMath.h"
#import <LocationKit/LocationKit.h>
#import "ViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,LKLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FriendList *fList;
@property (strong, nonatomic) PrivSetting * privacy;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;//"GMT"
@property (nonatomic, retain) NSDateFormatter *weekdayFormatter;//"EEEE"
@property (nonatomic, retain) NSDateFormatter *timestampFormatter;//"HH:mm"
@property (nonatomic, retain) NSDateFormatter *yearToDateFormatter;//"yyyy-MM-dd"
@property (nonatomic, retain) NSDateFormatter *yearToSecondFormatter;//"yyyy-MM-dd HH:mm:ss"

@property (nonatomic, retain) NSDate* activeLocationUntilWhen;
@property (nonatomic, retain) CLLocation *latestPerturbedLocation;
@property (nonatomic, retain) CLLocation *latestTrueLocation;

//@property (retain) CLLocationManager *locManager;
@property (nonatomic, retain) id<KCSStore> LocSeriesStore;//true location store in backend;
@property (nonatomic, retain) id<KCSStore> LokSeriesStore;//perturbed location store in backend;
@property (nonatomic, retain) NSNumber *conditionMultipleDevices;
@property (nonatomic, retain) NSNumber* flagSetPrimaryDevice;
@property (nonatomic, retain) LKSetting* LKmode_active;
@property (nonatomic, retain) LKSetting* LKmode_inactive;
@property (nonatomic) LKActivityMode ActivityMode;
@property (nonatomic, retain, nullable) LKLocationManager *locationManager;

- (void)sessionStateChanged:(FBSDKLoginManagerLoginResult*)result
                      error:(NSError *)error;

-(void)openFacebookSession;
-(void) initPrivSettingWithDefault;
-(void) getPrivRulesFromBackend;
-(void)savePrivRulesToBackend;
-(void)DataCleanBeforeLogout;
-(BOOL) ShouldShareMyLocationOrNot;//should location be shared or not?
-(void) toggleUpdatingLocations;//startUpdatingLocaton;
-(void) stopUpdatingLocations;
//-(void) addLocalNotificationsForLocationUpdating;
- (CLLocationCoordinate2D) locationWithBearing:(double)bearing//direction;
                                      distance:(double)distanceMeters//distance in meters;
                                  fromLocation:(CLLocationCoordinate2D)origin ;

-(NSString *)getUniqueDeviceIdentifierAsString;//this method syncs the unique id through all apple devices. If this app is uninstalled and reinstalled, the id remains the same, but for all devices.
@end
