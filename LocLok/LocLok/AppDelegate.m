//
//  AppDelegate.m
//  LocShare
//
//  Created by yxiao on 6/7/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window;
//@synthesize sessionFacebook;
@synthesize fList,privacy,dateFormatter,weekdayFormatter,timestampFormatter,LocSeriesStore,LokSeriesStore, activeLocationUntilWhen,latestPerturbedLocation,yearToDateFormatter,yearToSecondFormatter,timeDateFormatter,conditionMultipleDevices,flagSetPrimaryDevice,LKmode_active,ActivityMode,LKmode_inactive,latestTrueLocation,badgeCount,myMeetEvent;
//@synthesize locManager;
NSString *const FBSuccessfulLoginNotification =
@"com.yxiao.Login:FBSessionStateChangedNotification";
NSString *const FBFailedLoginNotification=
@"com.yxiao.Login.FBLoginFailedNotification";
NSString *const GotPrivacySettingNotification=
@"com.yxiao.gotPrivacySettingFromBackend";
NSString * const GotSelfPerturbedLocationNotification=
@"com.yxiao.gotperturbedlocationupdate_from_self";
NSString * const GotSelfTrueLocationNotification=
@"com.yxiao.got_true_location_from_self";
NSString * const NotificationCategoryIdent  = @"MeetEventRequestSent";
NSString * const NotificationActionOneIdent = @"MeetEventRequestAccepted";
NSString * const NotificationActionTwoIdent = @"MeetEventRequestDeclined";



extern NSString* LocalImagePlist;
//-(void)fbResync
//{
//    ACAccountStore *accountStore;
//    ACAccountType *accountTypeFB;
//    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
//
//        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
//        id account;
//        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
//
//            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
//                //we don't actually need to inspect renewResult or error.
//                if (error){
//
//                }
//            }];
//        }
//    }
//}




-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"imageSaved"
    //                                                    object:nil
    // ];
}
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}







-(NSInteger)findFriendinFListbyID:(NSString*)friend_id{
    for(NSInteger i=0;i<fList.friends.count;i++){
        if([[[[fList.friends objectAtIndex:i] to_user] userId] isEqualToString:friend_id]){
            return i;
        }
    }
    return -1;
}

//Push Notifications;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[KCSPush sharedPush] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken completionBlock:^(BOOL success, NSError *error) {
        //if there is an error, try again later
    }];
    // Additional registration goes here (if needed)
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //payload customized at:http://devcenter.kinvey.com/html5/reference/business-logic/reference.html
    
    [[KCSPush sharedPush] application:application didReceiveRemoteNotification:userInfo];
    // Additional push notification handling code should be performed here
    
    
    //NSLog(@"%d",[[userInfo objectForKey:@"code"] intValue]-100);
    //NSLog(@"%ld",(long)MeetEventRequest);
    if([[userInfo objectForKey:@"code"] unsignedIntegerValue]-100== MeetEventRequest){//friend permission from_user;
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Request"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"Agree"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self AgreeMeetEventRequest:userInfo];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        UIAlertAction* right = [UIAlertAction
                                actionWithTitle:@"Decline"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self DeclineMeetEventRequest:userInfo];
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
        
        [alert addAction:left];
        [alert addAction:right];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    if([[userInfo objectForKey:@"code"] unsignedLongValue]-100==MeetEventNotice){//family permission
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Request"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self AgreeMeetEventRequest:userInfo];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        
        [alert addAction:left];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    
    if([[userInfo objectForKey:@"code"] unsignedLongValue]-100==MeetEventAgreed){//agreed
        
        //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:[self findFriendinFListbyID:[userInfo objectForKey:@"to_user"]]];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Agreed"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self ReceiveAgreedMeeting:userInfo];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        
        [alert addAction:left];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    if([[userInfo objectForKey:@"code"] unsignedLongValue]-100==MeetEventDeclined){//declined
        
        //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:[self findFriendinFListbyID:[userInfo objectForKey:@"to_user"]]];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Declined"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //[self ReceiveAgreedMeeting:userInfo];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        
        [alert addAction:left];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    if([[userInfo objectForKey:@"code"] unsignedLongValue]-100==MeetEventHalfway){//halfway
        
        //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:[self findFriendinFListbyID:[userInfo objectForKey:@"to_user"]]];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Update"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        
        [alert addAction:left];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    if([[userInfo objectForKey:@"code"] unsignedLongValue]-100==MeetEventNearby){//nearby
        
        //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:[self findFriendinFListbyID:[userInfo objectForKey:@"to_user"]]];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Update"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        
        [alert addAction:left];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    
    
    if([[userInfo objectForKey:@"code"] unsignedLongValue]-100==MeetEventFinished){//meeting finished;
        myMeetEvent=nil;
        //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:-1];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Real-time Meeting Finished"
                                      message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //[self AgreeMeetEventRequest:userInfo];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
        
        [alert addAction:left];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    if([[userInfo objectForKey:@"code"] unsignedIntegerValue]==200){
        NSLog(@"permission request received.");
    }
    
    
}
/*- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    //payload customized at:http://devcenter.kinvey.com/html5/reference/business-logic/reference.html
    
    [[KCSPush sharedPush] application:application didReceiveRemoteNotification:userInfo];
    
    //30 seconds to fetch data, then must call completionhandler;
    handler(UIBackgroundFetchResultNoData);
    
    
}*/
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[KCSPush sharedPush] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
    
}






- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //self.window.rootViewController= self.viewController;
	//[self.window makeKeyAndVisible];
    
    
    //Check if its first time
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"is_first_time"]) {
        [application cancelAllLocalNotifications]; // Restart the Local Notifications list
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"is_first_time"];
        
        
    }
    
    
    /*
    // Handle launching from a notification
    UILocalNotification *localNotification1 = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];//UIApplicationLaunchOptionsLocalNotificationKey
    if (localNotification1) {
        if([localNotification1.userInfo objectForKey:@"endTime"]!=nil){
            // Set icon badge number to zero
            //application.applicationIconBadgeNumber = 0;
            //activeLocationUntilWhen=[locationNotification.userInfo objectForKey:@"endTime"];
            //save activeLocationUntilWhen to local file;
            //[CommonFunctions writeToPlist:@"BasicData.plist" :[NSArray arrayWithObject:[locationNotification.userInfo objectForKey:@"endTime"]] :@"activeLocationUntilWhen"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activeLocationUntilWhen"];
            [[NSUserDefaults standardUserDefaults] setObject:[localNotification1.userInfo objectForKey:@"endTime"] forKey:@"activeLocationUntilWhen"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
    //NSLog(@"written in plist: %@",[[[CommonFunctions retrieveFromPlist:@"BasicData.plist"] objectForKey:@"activeLocationUntilWhen"] objectAtIndex:0]);
    activeLocationUntilWhen=[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLocationUntilWhen"];
    
    NSLog(@"%@",activeLocationUntilWhen);
    */
    
    
    //[[KCSPush sharedPush] setPushBadgeNumber:100];
    /*my Kinvey Key LocLok*/
    //set LocLok version for backend;
    KCSRequestConfiguration* requestConfig = [KCSRequestConfiguration requestConfigurationWithClientAppVersion:@"1.0.0" andCustomRequestProperties:nil];
    KCSClientConfiguration* config =
    [KCSClientConfiguration configurationWithAppKey:@"kid_PeVcDHs6oJ"
                                             secret:@"95bf9dd03735465fb5f83955c92eade5"
                                            options:nil
                               requestConfiguration: requestConfig
     ];
    [[KCSClient sharedClient] initializeWithConfiguration:config];
    
    /*
    [[KCSClient sharedClient]
            initializeKinveyServiceForAppKey:@"kid_PeVcDHs6oJ"
                               withAppSecret:@"95bf9dd03735465fb5f83955c92eade5"
                                usingOptions:nil
            ];
    */
    UIMutableUserNotificationAction *action1;
    action1 = [[UIMutableUserNotificationAction alloc] init];
    [action1 setActivationMode:UIUserNotificationActivationModeBackground];
    [action1 setTitle:@"Accept"];
    [action1 setIdentifier:NotificationActionOneIdent];
    [action1 setDestructive:NO];
    [action1 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *action2;
    action2 = [[UIMutableUserNotificationAction alloc] init];
    [action2 setActivationMode:UIUserNotificationActivationModeBackground];
    [action2 setTitle:@"Decline"];
    [action2 setIdentifier:NotificationActionTwoIdent];
    [action2 setDestructive:NO];
    [action2 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationCategory *actionCategory;
    actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    [actionCategory setIdentifier:NotificationCategoryIdent];
    [actionCategory setActions:@[action1, action2]
                    forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObject:actionCategory];
    
    
    
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if([version floatValue] >=8.0){//register LocalNotification;
        UIUserNotificationType types = UIUserNotificationTypeNone | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    
    /* my Kinvey Key ~loclok
    (void) [[KCSClient sharedClient]
            initializeKinveyServiceForAppKey:@"kid_byd3m3O74g"
            withAppSecret:@"628c0f447db84fda80820485257bc93b"
            usingOptions:nil
            ];
    */
    //deprecated in Kinvey 1.90
//    [KCSPush initializePushWithPushKey:@"JuTMmvO0Qcym03YZtY0uLw"
//                            pushSecret:@"SPAar7M7SsyasVm2bQLsfQ"
//                                  mode:KCS_PUSHMODE_DEVELOPMENT
//                               enabled:YES];
    
    //Start push service
    [KCSPush registerForPush];
    
    
    UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:1];
    UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    tabBar.backgroundColor=[UIColor whiteColor];
    tabBar.backgroundImage=nil;
    UITabBarItem *tabBarItem0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    
    
    //[tabBarItem1 initWithTitle:@"My Privacy" image:[UIImage imageNamed:@"User-Shield.png"] selectedImage:[UIImage imageNamed:@"User-Shield.png"]];
    
    
    /*Navigation Bar*/
    /*UIViewController *loginViewController = [[LoginViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                            initWithRootViewController:loginViewController
                                                   ];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = navigationController;
    [window makeKeyAndVisible];
    */
    //return YES;
    /*
    self.locManager=[[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter=10;//only when the movement >100 meters, does the update generated and the event sent to delegate;
    //self.locManager.distanceFilter=500;
    //[self.locManager startUpdatingLocation];
     */
    
    /*
    //NSDictionary *option_motion = @{LKOptionUseiOSMotionActivity: @YES};
    //NSDictionary *option_motion =@{LKOptionTimedUpdatesInterval: @300};
    //[[LocationKit sharedInstance] startWithApiToken:@"b0a6bcd54fe52138" delegate:self options:option_motion];
    //[[LocationKit sharedInstance] pause];
    
    [self checkAlwaysAuthorization];
    
    LKmode_inactive = [[LKSetting alloc] initWithType:LKSettingTypeLow];
    LKmode_inactive.distanceFilter=kCLDistanceFilterNone;
    LKmode_inactive.desiredAccuracy=kCLLocationAccuracyThreeKilometers;
    
    LKmode_active = [[LKSetting alloc] initWithType:LKSettingTypeAuto];
    LKmode_active.desiredAccuracy = kCLLocationAccuracyBest;
    //LKmode.distanceFilter = 10;
    LKmode_active.distanceFilter=kCLDistanceFilterNone;
    
    [[LocationKit sharedInstance] setOperationMode:LKmode_active];
    */
    
    //LocationKit 3.x version API;
    [self checkAlwaysAuthorization];
    self.locationManager = [[LKLocationManager alloc] init];
    self.locationManager.apiToken = @"b0a6bcd54fe52138";
    self.locationManager.advancedDelegate=self;
    self.locationManager.debug=YES;
    [self.locationManager stopUpdatingLocation];
    
    
    
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    weekdayFormatter=[[NSDateFormatter alloc] init];
    [weekdayFormatter setDateFormat:@"EEEE"];
    timestampFormatter = [[NSDateFormatter alloc] init] ;
    [timestampFormatter setDateFormat:@"HH:mm"];
    yearToDateFormatter= [[NSDateFormatter alloc]init];
    [yearToDateFormatter setDateFormat:@"yyyy-MM-dd"];
    yearToSecondFormatter = [[NSDateFormatter alloc]init];
    [yearToSecondFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    timeDateFormatter = [[NSDateFormatter alloc]init];
    [timeDateFormatter setDateFormat:@"HH:mm:ss MM-dd-yyyy"];
    
    
    LocSeriesStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LocSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
    }];
    LokSeriesStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LokSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
    }];
    
    //if(privacy==nil){
    //    [self getPrivRulesFromBackend];
    //}
    
    conditionMultipleDevices=[NSNumber numberWithBool:YES];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(toggleUpdatingLocations)
     name:GotPrivacySettingNotification
     object:nil
     ];
    
    
    
    
    
    
    //if ([KCSUser hasSavedCredentials] == YES) {
    if([KCSUser activeUser]){
        // FBSample logic
        // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.
        //[FBSDKAppEvents activateApp];
        
        // FBSample logic
        // We need to properly handle activation of the application with regards to SSO
        //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
        //[FBAppCall handleDidBecomeActive];
        
        //currentUser=[KCSUser activeUser];
        NSLog(@"has a user's credential");
        
        //[locManager startUpdatingLocation];
        
        //NSLog(@"%@",fList);
        if(privacy==nil){
            
            [self getPrivRulesFromBackend];
        }
        else{
            [self toggleUpdatingLocations];
        }
        
        //[self performSegueWithIdentifier:@"toMap" sender:self];
    } else {
        NSLog(@"has not user's credential");
    }
    
    fList=[FriendList alloc];
    //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:-1];
    myMeetEvent=nil;
    
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];//auto update profile;
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}
// Displays an alert that can take the user to Settings if the location authorization status is not satisfactory.
- (void)checkAlwaysAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title =  (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        

       
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* left = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* right = [UIAlertAction
                                 actionWithTitle:@"Settings"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:left];
        [alert addAction:right];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    
    else if (status == kCLAuthorizationStatusNotDetermined) {
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        if([manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [manager requestAlwaysAuthorization];
        }
    }
}


/*
//foreground;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if([notification.userInfo objectForKey:@"endTime"]!=nil){
        //activeLocationUntilWhen=[notification.userInfo objectForKey:@"endTime"];
        
        //save activeLocationUntilWhen to local file;
        //[CommonFunctions writeToPlist:@"BasicData.plist" :[NSArray arrayWithObject:[notification.userInfo objectForKey:@"endTime"]] :@"activeLocationUntilWhen"];
        NSLog(@"In local notif: %@; activeLocationUntilWhen=%@",notification.userInfo,activeLocationUntilWhen);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activeLocationUntilWhen"];
        [[NSUserDefaults standardUserDefaults] setObject:[notification.userInfo objectForKey:@"endTime"] forKey:@"activeLocationUntilWhen"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        activeLocationUntilWhen=[notification.userInfo objectForKey:@"endTime"];
    }
    
    //NSLog(@"local notif's fireDate=%@",notification.fireDate);
    NSLog(@"activeLocationUntilWhen=%@",activeLocationUntilWhen);
    [self toggleUpdatingLocations];//open or close location updating;

}
*/

- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:NotificationActionOneIdent]) {
        //NSLog(@"You chose action Accept.");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Push Action"
                                      message:@"You chose to accept the meeting request"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        
        
        [self  AgreeMeetEventRequest:userInfo];
        
    }
    if ([identifier isEqualToString:NotificationActionTwoIdent]) {
        //NSLog(@"You chose action Decline.");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Push Action"
                                      message:@"You chose to decline the meeting request"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        
        
        
        [self DeclineMeetEventRequest:userInfo];
    }
    if (completionHandler) {
        
        completionHandler();
    }
}
-(void)AgreeMeetEventRequest:(NSDictionary *)userInfo{
    id<KCSStore> meetStore=
    [KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName:@"MeetEvent",
        KCSStoreKeyCollectionTemplateClass:[MeetEvent class],
                                        KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)
    }];
    NSString *meet_id=[userInfo objectForKey:@"meet_id"];
    //NSLog(@"%@",meet_id);
    KCSQuery* query1 = [KCSQuery queryOnField:KCSEntityKeyId
                       withExactMatchForValue:meet_id
                        ];
    
    //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:[self findFriendinFListbyID:[userInfo objectForKey:@"from_user"]]];
    [meetStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil2, NSError *errorOrNil2) {
        if (errorOrNil2 == nil && objectsOrNil2.count>0) {
            myMeetEvent=objectsOrNil2[0];
            
            //save permission of meetinglink to Friendlist;
            id<KCSStore>frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                                           KCSStoreKeyCollectionName : @"Friendship",
                                                                           KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                                           KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
                                                                           }];
            KCSQuery* query2 = [KCSQuery queryOnField:@"to_user._id"
                               withExactMatchForValue:[[KCSUser activeUser] userId]
                                ];
            [query2 addQueryOnField:@"from_user._id" withExactMatchForValue:[userInfo objectForKey:@"from_user"]];
            [frdStore queryWithQuery:query2 withCompletionBlock:^(NSArray *objectsOrNil1, NSError *errorOrNil1) {
                if(objectsOrNil1!=nil){
                    Friendship* friend1=objectsOrNil1[0];
                    friend1.meetinglink=objectsOrNil2[0];
                    [frdStore saveObject:friend1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                        if(errorOrNil!=nil){
                            NSLog(@"error when saving meetinglink in Friendship");
                        }
                        
                    } withProgressBlock:nil];
                }
            } withProgressBlock:nil];
            
            
            
            
            
            
            [self.locationManager requestLocation:^(CLLocation * _Nullable location, NSError * _Nullable error) {
                // We have to make sure the location is set, could be nil
                if (location != nil) {
                    myMeetEvent.to_location=[location kinveyValue];
                    myMeetEvent.distance=[NSNumber numberWithInt:(int)[location distanceFromLocation:[CLLocation locationFromKinveyValue:myMeetEvent.from_location]] ];
                    if([myMeetEvent.distance doubleValue]>Nearby_meters){
                        myMeetEvent.MeetEventStatus=[NSNumber numberWithInteger:MeetEventAgreed];
                    }
                    else{ if([myMeetEvent.distance doubleValue]<Meet_meters){
                        myMeetEvent.end_time=[NSDate date];
                        myMeetEvent.MeetEventStatus=[NSNumber numberWithInteger:MeetEventFinished];
                    }
                    else{
                        myMeetEvent.MeetEventStatus=[NSNumber numberWithInteger:MeetEventNearby];
                    }
                    }
                    [meetStore saveObject:myMeetEvent withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                        //finished meeting event;
                        if(myMeetEvent.MeetEventStatus==MeetEventFinished){
                            myMeetEvent=nil;
                            //fList.myMeetingFriendIndex=[NSNumber numberWithInteger:-1];
                        }
                    } withProgressBlock:nil];
                }
            }];
        } else {
            NSLog(@"error occurred: %@", errorOrNil2);
        }
    } withProgressBlock:nil];
    
    
}
-(void)DeclineMeetEventRequest:(NSDictionary *)userInfo{
    id<KCSStore> meetStore=
    [KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName:@"MeetEvent",
                                              KCSStoreKeyCollectionTemplateClass:[MeetEvent class],
                                              KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)
                                              }];
    NSString *meet_id=[userInfo objectForKey:@"meet_id"];
    //NSLog(@"%@",meet_id);
    KCSQuery* query1 = [KCSQuery queryOnField:KCSEntityKeyId
                       withExactMatchForValue:meet_id
                        ];
    
    [meetStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil2, NSError *errorOrNil2) {
        if (errorOrNil2 == nil && objectsOrNil2.count>0) {
            MeetEvent*  meet1=objectsOrNil2[0];
            meet1.MeetEventStatus=[NSNumber numberWithInteger:MeetEventDeclined];
            
            [meetStore saveObject:meet1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if(errorOrNil!=nil){
                    NSLog(@"%@",errorOrNil);
                }
            } withProgressBlock:nil];
            
        }
    }
    withProgressBlock:nil];
    
    
    
}
-(void)ReceiveAgreedMeeting:(NSDictionary  * _Nullable )userInfo{
    NSString * strMeetID=[userInfo objectForKey:@"meet_id"];
    
    NSInteger i=[self findFriendinFListbyID:[userInfo objectForKey:@"to_user"]];
    
    NSString* originalMeetID=[[fList.friends objectAtIndex:i] meetinglink].entityId;
    
    //if agreed meeting is not the proposed meeting when several requests were sent;
    if(![originalMeetID isEqualToString:strMeetID]){
        id<KCSStore> meetStore=
        [KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName:@"MeetEvent",
                                                  KCSStoreKeyCollectionTemplateClass:[MeetEvent class],
                                                  KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)
                                                  }];
        KCSQuery* query1 = [KCSQuery queryOnField:KCSEntityKeyId
                           withExactMatchForValue:strMeetID
                            ];
        
        [meetStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil2, NSError *errorOrNil2) {
            if (errorOrNil2 == nil && objectsOrNil2.count>0) {
                myMeetEvent=objectsOrNil2[0];
                
                
                id<KCSStore>frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                                               KCSStoreKeyCollectionName : @"Friendship",
                                                                               KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                                               KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
                                                                               }];
                KCSQuery* query2 = [KCSQuery queryOnField:@"to_user._id"
                                   withExactMatchForValue:[[KCSUser activeUser] userId]
                                    ];
                [query2 addQueryOnField:@"from_user._id" withExactMatchForValue:[userInfo objectForKey:@"to_user"]];
                [frdStore queryWithQuery:query2 withCompletionBlock:^(NSArray *objectsOrNil1, NSError *errorOrNil1) {
                    if(objectsOrNil1!=nil){
                        Friendship* friend1=objectsOrNil1[0];
                        friend1.meetinglink=objectsOrNil2[0];
                        [frdStore saveObject:friend1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if(errorOrNil!=nil){
                                NSLog(@"error when saving meetinglink in Friendship");
                            }
                            
                        } withProgressBlock:nil];
                    }
                } withProgressBlock:nil];
                
                
            }
        }withProgressBlock:nil];
         
    }
}
///*
// * If we have a valid session at the time of openURL call, we handle
// * Facebook transitions by passing the url argument to handleOpenURL
// */
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    // attempt to extract a token from the url
//    return [FBSession.activeSession handleOpenURL:url];
//}


// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    // Handling app cold starts
     
    // Since most login flows require an app switch to complete, it's possible your app gets terminated by iOS in low memory conditions (or if your app does not support backgrounding). In that case, the state change handler block supplied to your open call is lost. To handle that scenario, you can explicitly assign a state change handler block to the FBSession instance any time prior to the handleOpenURL: call.
     
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}
*/

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // We need to properly handle activation of the app with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    
    //[FBSession.activeSession handleDidBecomeActive];
    
    //if privacy is not saved, then save the privacy to backend and schedule local notif;
    //NSArray* existingNotifs=[[UIApplication sharedApplication] scheduledLocalNotifications];
    //if(existingNotifs.count==0 && privacy.SharingTime.count!=0){
    //    [self savePrivRulesToBackend];
    //}
    
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[KCSPush sharedPush] registerForRemoteNotifications];
    
    [FBSDKAppEvents activateApp];
    //[self.window makeKeyAndVisible];
}

-(void)DataCleanBeforeLogout{
    //[[KCSUser activeUser] logout] should clear the cache, but it does not work;
    //[KCSCachedStore clearCaches];
    
    /*FBSDK 3.x below
     if (appDelegate.sessionFacebook.isOpen || appDelegate.sessionFacebook.state==FBSessionStateCreated) {
     //the status is FBSessionCreated;
     [appDelegate.sessionFacebook closeAndClearTokenInformation];
     
     }
     */
    if([FBSDKAccessToken currentAccessToken]){
        [[[FBSDKLoginManager alloc] init] logOut];
    }
    
    fList=nil;
    privacy=nil;
    
    [KCSUser clearSavedCredentials];
    [KCSCachedStore clearCaches];
    NSLog(@"Logged out.");
    [[KCSUser activeUser] logout];
    
    
    //close location manager;
    /*
    [locManager stopUpdatingLocation];*/
    
    //close
    //[[LocationKit sharedInstance] pause];
    [self.locationManager stopUpdatingLocation];
    
    latestTrueLocation=nil;
    latestPerturbedLocation=nil;
    
    
    //cancel all local notifications;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    //remove all annotations of pervious user;
    //UITabBarController* tabController = (UITabBarController*)  self.window.rootViewController;
    //[[[[[tabController viewControllers] objectAtIndex:0] objectAtIndex:0] mapView] removeAnnotations:[[[[tabController viewControllers] objectAtIndex:0] objectAtIndex:0] mapView].annotations];
    
    [[KCSPush sharedPush] onUnloadHelper];
}




- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self DataCleanBeforeLogout];
    
    
}


- (void) handeLogin:(NSError*)errorOrNil
{
    //[self reenableButtons];
    if (errorOrNil != nil) {
        BOOL wasUserError = [[errorOrNil domain]  isEqual: KCSUserErrorDomain];
        NSString* title = wasUserError ? NSLocalizedString(@"Invalid Credentials", @"credentials error title") : NSLocalizedString(@"An error occurred.", @"Generic error message");
        NSString* message = wasUserError ? NSLocalizedString(@"Wrong username or password. Please check and try again.", @"credentials error message") : [errorOrNil localizedDescription];
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:message
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alert addAction:ok];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        NSLog(@"Facebook->Kinvey error==nil");
        
    }
    
}


-(void)openFacebookSession{
    
    
    /*if ([KCSUser hasSavedCredentials] == YES) {
     [self performSegueWithIdentifier:@"toMain" sender:self];
     NSLog([KCSUser activeUser].userId);
     return;
     }*/
    /*open Facebook session*/
    
    //If your app asks for more than than public_profile, email and user_friends it will require review by Facebook before your app can be used by people other than the app's developers.
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"public_profile",
                            //@"user_friends",
                            nil];
    /*
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,FBSessionState state,NSError *error) {*/
                                      /*
                                       Following comments only works when user swithed facebook id on their iphone.
                                       */
                                      /*if(error)
                                       {
                                       NSLog(@"Session error");
                                       [self fbResync];
                                       [NSThread sleepForTimeInterval:0.5];   //half a second
                                       [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                       completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                       [self sessionStateChanged:session state:state error:error];
                                       }];
                                       
                                       }
                                       else
                                       */
                                      
                                      /*
                                      AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                                      [appDelegate sessionStateChanged:session
                                                                 state:state
                                                                 error:error
                                       ];
                                  }
     ];
                                       */
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:permissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                //AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
                [self sessionStateChanged:result
                                           error:error
                 ];
            }
        }
    }];
}


- (void)sessionStateChanged:(FBSDKLoginManagerLoginResult *)result
                      error:(NSError *)error
{
    /*switch (state) {
        case FBSessionStateOpen: {
            //session is open
            NSLog(@"Facebook: FBSessionStateOpen");
            NSString* accessToken = session.accessToken;
            
            
//            
//            NSString * strFirstName_1,*strLastName_1,*strEmail_1;
//            FBProfilePictureView *profilePictureView_1;

     */
    
    
                                          
                                
                                          
                                          
                                          //convert the profilePicture to UIImage;
//                                          //save the profile image
//                                          UIImage *img = nil;
//                                          
//                                          //1 - Solution to get UIImage obj
//                                          
//                                          for (NSObject *obj in [profilePictureView subviews]) {
//                                              if ([obj isMemberOfClass:[UIImageView class]]) {
//                                                  UIImageView *objImg = (UIImageView *)obj;
//                                                  img = objImg.image;
//                                                  break;
//                                              }
//                                          }
//                                          NSData* data = UIImageJPEGRepresentation(img, 0.9); //convert to a 90% quality jpeg
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
      //NSLog(@"%@",[FBSDKAccessToken currentAccessToken].tokenString);
      //log in to Kinvey ;
      [KCSUser loginWithSocialIdentity:KCSSocialIDFacebook
                      accessDictionary:@{KCSUserAccessTokenKey : [FBSDKAccessToken currentAccessToken].tokenString}
                   withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result1) {
                       
            [self handeLogin:errorOrNil];
            
           
                       
            BOOL first_time_user=[user.email length]==0?YES:NO;
            
            if(!first_time_user){//not the first time user, successfully login;
                /*save user info to plist;*/
                NSMutableArray *userInfo;
                userInfo=[NSMutableArray arrayWithObjects:[[NSString alloc] initWithString:[KCSUser activeUser].email],[[NSString alloc] initWithString:[KCSUser activeUser].givenName],[[NSString alloc] initWithString:[KCSUser activeUser].surname],nil];
                [CommonFunctions writeToPlist:@"UserInfo.plist" :userInfo :@"userInfo"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FBSuccessfulLoginNotification
                                                                    object:nil
                 ];
                //friend list;
                //fList=[[FriendList alloc] loadWithID:[user userId ]];
                //privacy setting;
                [self getPrivRulesFromBackend];
            }
               
                       
                       
            else{// is first time user;
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     
                     if (!error) {
                         NSString * strFirstName,*strLastName,*strEmail;
                         FBSDKProfilePictureView *profilePictureView;
                         NSString * profilePictureURL;
                         
                         // result is the json response from a successful request
                         NSDictionary *dictionary = (NSDictionary *)result;
                         strFirstName=(NSString*)[dictionary objectForKey:@"first_name"];
                         strLastName=(NSString*)[dictionary objectForKey:@"last_name"];
                         strEmail=[(NSString*)[dictionary objectForKey:@"email"] lowercaseString];
                         profilePictureURL=[[[dictionary objectForKey:@"picture"] objectForKey:@"data"]
                                            objectForKey:@"url"
                                            ];
                         
                         
                         profilePictureView.profileID=(NSString *)[dictionary objectForKey:@"id"];
                         //NSLog(@"%@",result);
                
                
                
                
                
                
                
                       //to assign an outside variable in the block;
                       //__block BOOL first_time_email;
                       //check if the username has already existed;
                        //if(first_time_user)
                        [KCSUser checkUsername:strEmail withCompletionBlock:^(NSString *username_1, BOOL usernameAlreadyTaken, NSError *error1) {
                            
                               if (usernameAlreadyTaken == YES && first_time_user) {
                                   
                                   
                                   UIAlertController * alert=   [UIAlertController
                                                                 alertControllerWithTitle:@"Email Already Taken"
                                                                 message:[NSString stringWithFormat:@"\"%@\" is already in use, you can log in with \"%@\" if it is your email. Or you can reclaim this email as your user name by clicking \"Forgot Password\". Thanks.", username_1,username_1]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                   
                                   UIAlertAction* ok = [UIAlertAction
                                                        actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                                        {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                        }];
                                   
                                   [alert addAction:ok];
                                   
                                   [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                                   
                                   
                                   //remove KCS user;
                                   [[KCSUser activeUser] removeWithCompletionBlock:^(NSArray *objectsOrNil3, NSError *errorOrNil3) {
                                       if (errorOrNil3 != nil) {
                                           NSLog(@"when deleting active user, error %@ ", errorOrNil3);
                                       } else {
                                           NSLog(@"active user deleted");
                                       }
                                   }];
                                   //log out Facebook;
                                   if([FBSDKAccessToken currentAccessToken]){
                                       [[[FBSDKLoginManager alloc] init] logOut];
                                   }
                                   //clear credentials;
                                   [KCSUser clearSavedCredentials];
                                   
                                   //login error;
                                   [KCSCachedStore clearCaches];
                                   
                                   fList=nil;
                                   privacy=nil;
                                   //send Login Failure Notification;
                                   [[NSNotificationCenter defaultCenter] postNotificationName:FBFailedLoginNotification
                                                                                       object:nil
                                    ];
                                   
                                   
                               
                               } else {//now we can safely login;
                                   
                                   
                                   
                                   /*test
                                   NSDictionary* temp=[self retrieveFromPlist:@"UserInfo.plist"];
                                   NSLog(@"%@",temp);*/
                                   
                                   
                                   /*test
                                   temp=[self retrieveFromPlist:@"UserInfo.plist"];
                                   NSLog(@"%@",temp);*/
                                   
                                   
                                   
                                   
                                   //friend list;
                                   //fList=[[FriendList alloc] loadWithID:[user userId ]];
                                   //NSLog(@"%@",[user userId]);
                                   
                                   
                                   
                                   
                                   
                                   
                                   [self getPrivRulesFromBackend];
                                   
                                   
                                   
                                   
                                   
                                   //save the frist_name, last_name, email (from Facebook) on SERVER to complete the user's information;
                                   
                                   
                                       /* FBSDK 3.x below
                                        //request current user's first_name, last_name and profile picture;
                                        [FBSDKRequestConnection startWithGraphPath:@"me"
                                        parameters:[NSDictionary dictionaryWithObject:@"picture,id,email,first_name,last_name"//picture.type(large)
                                        forKey:@"fields"]
                                        HTTPMethod:@"GET"
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        */
                                       
                                                
                                                
                                   
                                    
                                    if([user.givenName length]==0)user.givenName=strFirstName;
                                    if([user.surname length]==0)user.surname=strLastName;
                                    if([user.email length]==0){
                                        user.email=strEmail;
                                        user.username=strEmail;
                                    }
                                   /*save user info to plist;*/
                                   NSMutableArray *userInfo;
                                   userInfo=[NSMutableArray arrayWithObjects:[[NSString alloc] initWithString:[KCSUser activeUser].email],[[NSString alloc] initWithString:[KCSUser activeUser].givenName],[[NSString alloc] initWithString:[KCSUser activeUser].surname],nil];
                                   [CommonFunctions writeToPlist:@"UserInfo.plist" :userInfo :@"userInfo"];
                                   
                                    
                                    
                                    [user saveWithCompletionBlock:^(NSArray *objectsOrNil4, NSError *errorOrNil1) {
                                        if(first_time_user ){
                                            if (errorOrNil1 == nil) {
                                                //was successful!
                                                
                                                UIAlertController * alert=   [UIAlertController
                                                                              alertControllerWithTitle:@"Facebook Log in Successful"
                                                                              message:[NSString stringWithFormat:NSLocalizedString(@"Welcome, %@ %@! \"%@\" will be your account name. You can either reset a password for it or still log in with facebook in the future.",@"account success message body"), strFirstName,strLastName,strEmail ]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction* ok = [UIAlertAction
                                                                     actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action)
                                                                     {
                                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                                         
                                                                     }];
                                                
                                                [alert addAction:ok];
                                                
                                                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                                                
                                                
                                                
                                                //fList=[[FriendList alloc] loadWithID:[user userId ]];
                                                //send notification of successful login;
                                                [[NSNotificationCenter defaultCenter] postNotificationName:FBSuccessfulLoginNotification
                                                                                                    object:nil
                                                 ];
                                                //test;
                                                NSLog(@"FBLogin notif sent, configuring the 1st-time user.");
                                                
                                            } else {
                                                //there was an error with the update save
                                                NSString* message = [errorOrNil1 localizedDescription];
                                                
                                                UIAlertController * alert=   [UIAlertController
                                                                              alertControllerWithTitle:@"Log in account failed"
                                                                              message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction* ok = [UIAlertAction
                                                                     actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action)
                                                                     {
                                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                                         
                                                                     }];
                                                
                                                
                                                [alert addAction:ok];
                                                
                                                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                                            }
                                        }
                                    }
                                     ];//save user;
                                   
                                   
                                   
                                   
                                   //save the image to local directory
                                   [CommonFunctions saveImageFromURLToLocal:profilePictureURL :[[KCSUser activeUser] userId]];
                                   [CommonFunctions writeToPlist:LocalImagePlist
                                                                :[NSArray arrayWithObject:profilePictureURL]
                                                                :[[KCSUser activeUser] userId]
                                   ];
                                   /*NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                   
                                   //Get Image From URL
                                   //NSLog(@"%@",profilePictureURL);
                                   UIImage * imageFromURL = [self getImageFromURL:profilePictureURL];
                                   
                                   //Load Image From Directory
                                   UIImage* Profileimage = [self loadImage:[[KCSUser activeUser] userId] ofType:@"png" inDirectory:documentsDirectoryPath];
                                   if(Profileimage==nil){//MyProfilePicture.jpg does not exist, then save it;
                                       
                                       //Save Image to Directory
                                       [self saveImage:imageFromURL withFileName:user.username ofType:@"png" inDirectory:documentsDirectoryPath
                                        ];
                                   }
                                   */
                                   
                                   //save image to SERVER
                                   NSString* filename = [user.username stringByAppendingString:@".png" ];
                                   NSURL* documentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
                                   NSURL* sourceURL = [NSURL URLWithString:filename relativeToURL:documentsDir];
                                   //NSLog(@"%@",sourceURL);
                                   
                                   //__block NSString * imageID;
                                   [KCSFileStore
                                    uploadFile:sourceURL
                                    options:nil completionBlock:^(KCSFile *uploadInfo, NSError *error) {
                                        //NSLog(@"Upload finished. File id='%@', error='%@'.", [uploadInfo fileId], error);
                                        //imageID=[uploadInfo fileId];
                                        NSArray* myArray = [[[uploadInfo remoteURL] absoluteString]  componentsSeparatedByString:@"?"];
                                        NSString * imageURL=[myArray objectAtIndex:0];
                                        
                                        
                                        //save photo to User_Photos collection at backend;
                                        id<KCSStore> PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName : @"UserPhotos", KCSStoreKeyCollectionTemplateClass : [User_Photo class]}];
                                        //upload new photo;
                                        //if no KCSUser found, save to a new record;
                                        User_Photo * uPhoto=[[User_Photo alloc] init];
                                        uPhoto.user_id=[KCSUser activeUser];
                                        //UIImage* image1=[[UIImage alloc] init];image1=image;
                                        uPhoto.photo=[CommonFunctions loadImageFromLocal:[[KCSUser activeUser] userId]];
                                        if (!uPhoto.meta) {
                                            uPhoto.meta = [[KCSMetadata alloc] init];
                                        }
                                        [uPhoto.meta setGloballyReadable:YES];
                                        uPhoto.photoURL=imageURL;
                                        uPhoto.date=[NSDate date];
                                        
                                        [PhotoStore saveObject:uPhoto withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                            if (errorOrNil != nil) {
                                                //save failed, show an error alert
                                                
                                                UIAlertController * alert=   [UIAlertController
                                                                              alertControllerWithTitle:@"Save failed"
                                                                              message:[errorOrNil localizedFailureReason]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction* ok = [UIAlertAction
                                                                     actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action)
                                                                     {
                                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                                         
                                                                     }];
                                                
                                                
                                                [alert addAction:ok];
                                                
                                                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                                            } else {
                                                //save was successful
                                                NSLog(@"Successfully saved photo.");
                                            }
                                        } withProgressBlock:nil
                                         ];
                                        
                                    } progressBlock:nil];
                                   /*[user setValue:nil
                                    forAttribute:@"ProfilePictureFile"
                                    ];*/
                                   
                                   
                                   
                                   //test
                                   NSLog(@"first time user login successful");
                                   
                                   
                                   //start update locations;
                                   //[locManager startUpdatingLocation];
                                 
                                 
                                 
                             }//sfaely login bracket;
                             }
                             ];//check username bracket;
                                     
                                     
                   }//safely login bracket;
                   }];//Facebook Request ;
                
                
                
            }//first time user bracket;
            
                
        }
       ];//KCSUser loginwithFacebook bracket;
    
              
    
                                          
                                          
                                          
                                          

            
            //[self performSegueWithIdentifier:@"toMap" sender:self];
            
            
                    
                    
                    
                    
                    
                    
                    
                    
                    
          
            
            
            
        /*}
        
            break;
        case FBSessionStateClosed:
            NSLog(@"Facebook: FBSessionStateClosed");
        case FBSessionStateClosedLoginFailed:
            //
            
            NSLog(@"Facebook: FBSessionStateClosedLoginFailed");
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
         */
    //[[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification
    //                                                    object:nil
    // ];
    
    if (error) {
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Facebook session error"
                                      message:[error localizedDescription]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        //Clear this token
        //[FBSession.activeSession closeAndClearTokenInformation];
        [[[FBSDKLoginManager alloc] init] logOut];
    }
//    // Handle errors
//    if (error){
//        NSLog(@"Error");
//        NSString *alertText;
//        NSString *alertTitle;
//        // If the error requires people using an app to make an action outside of the app in order to recover
//        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
//            alertTitle = @"Something went wrong";
//            alertText = [FBErrorUtility userMessageForError:error];
//            [self showMessage:alertText withTitle:alertTitle];
//        } else {
//            
//            // If the user cancelled login, do nothing
//            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
//                NSLog(@"User cancelled login");
//                
//                // Handle session closures that happen outside of the app
//            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
//                alertTitle = @"Session Error";
//                alertText = @"Your current session is no longer valid. Please log in again.";
//                [self showMessage:alertText withTitle:alertTitle];
//                
//                // Here we will handle all other errors with a generic error message.
//                // We recommend you check our Handling Errors guide for more information
//                // https://developers.facebook.com/docs/ios/errors/
//            } else {
//                //Get more error information from the error
//                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
//                
//                // Show the user an error message
//                alertTitle = @"Something went wrong";
//                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
//                [self showMessage:alertText withTitle:alertTitle];
//            }
//        }
//        // Clear this token
//        [FBSession.activeSession closeAndClearTokenInformation];
//        // Show the user the logged-out UI
//        //[self userLoggedOut];
//    }
}

-(void) getPrivRulesFromBackend{
    
    id<KCSStore> privStore=[KCSLinkedAppdataStore storeWithOptions:@{
                KCSStoreKeyCollectionName : @"UserPrivacy",
                KCSStoreKeyCollectionTemplateClass : [PrivSetting class],
                KCSStoreKeyCachePolicy:@(KCSCachePolicyNetworkFirst)
        }
    ];
    
    NSLog(@"%@",[[KCSUser activeUser] userId]);
    
    KCSQuery* query1 = [KCSQuery queryOnField:@"owner"
                       withExactMatchForValue:[[KCSUser activeUser] userId]
                        ];
    
    NSLog(@"%@",privStore);
    NSLog(@"%@",[KCSUser activeUser]);
    
    [privStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil==nil){
            
            if([objectsOrNil count]==0){
                //appDelegate1.privacy=nil;
                [self initPrivSettingWithDefault];
                [self savePrivRulesToBackend];
                
            }else{
                privacy=objectsOrNil[0];
                
                //test
                //NSArray* existingNotifs=[[UIApplication sharedApplication] scheduledLocalNotifications];
                //NSLog(@"%@,%@",existingNotifs,activeLocationUntilWhen);
                
                NSLog(@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
                if(![privacy.deviceID isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]){
                    conditionMultipleDevices=[NSNumber numberWithBool:NO];

                    
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Warning: Multiple devices detected!"
                                                  message:@"This warning was caused by one of the following conditions. 1. Reinstalling this app; 2. Using multiple devices for one user. If you set this device as your primary device, then it will represent your location. Do you want to set this device as your primary device?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"YES"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             //flagSetPrimaryDevice=[NSNumber numberWithInt:1];
                                             conditionMultipleDevices=[NSNumber numberWithBool:YES];
                                             privacy.deviceID=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
                                             [self savePrivRulesToBackend];
                                             
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    UIAlertAction* cancel = [UIAlertAction
                                             actionWithTitle:@"NO"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 //flagSetPrimaryDevice=[NSNumber numberWithInt:0];
                                                 [self DataCleanBeforeLogout];
                                                 
                                                 
                                                 LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                                                 loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                                 [self.window.rootViewController presentViewController:loginVC animated:NO completion:^{
                                                     //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                                                     //jump to the root view controller: map;
                                                     //[self tabBarController].selectedIndex=0;
                                                 }
                                                  ];
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                    
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    
                    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                }
                //check if the deviceID is current device;
                //if(![privacy.deviceID isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]){
                
                    //conditionMultipleDevices=[NSCondition new];
                    //flagSetPrimaryDevice=[NSNumber numberWithInt:-1];//not set;
                    
                    //[conditionMultipleDevices lock];
                    //while([flagSetPrimaryDevice intValue]==-1){
                        //[conditionMultipleDevices wait];
                        
                    //}
                    //[conditionMultipleDevices unlock] ;
                    //if([flagSetPrimaryDevice intValue]==0){//No;
                    //    flagSetPrimaryDevice =[NSNumber numberWithInt:-1];
                    //    return;
                    //}
                    //if([flagSetPrimaryDevice intValue]==1){//Yes;
                    //    privacy.deviceID=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
                    //   [self savePrivRulesToBackend];
                    //}
                    //flagSetPrimaryDevice=[NSNumber numberWithInt:-1];
                    
                    
                    
                    
                    
                //}//multiple devices;
                
                
                
                
                
                
                
                //type transform of SharingTime;
                for(int i=0;i<privacy.SharingTime.count;i++){
                    TimePeriodPrivacy *timePriv=[TimePeriodPrivacy alloc];
                    NSArray *tmp=[[privacy.SharingTime objectAtIndex:i] componentsSeparatedByString:@";"];
                    timePriv.DayInWeek=[tmp objectAtIndex:0];
                    timePriv.startTime=[tmp objectAtIndex:1];
                    timePriv.endTime=[tmp objectAtIndex:2];
                    [privacy.SharingTime replaceObjectAtIndex:i withObject:timePriv];
                }
                /*NSArray* existingNotifs=[[UIApplication sharedApplication] scheduledLocalNotifications];
                if(existingNotifs.count==0 &&[conditionMultipleDevices boolValue]){
                    [self addLocalNotificationsForLocationUpdating];
                }*/
                [[NSNotificationCenter defaultCenter] postNotificationName:GotPrivacySettingNotification
                                                                object:nil
                 ];
            }
            
        }
        else{
            NSLog(@"when loading user privacy, error occurred: %@",errorOrNil);
        }
    }withProgressBlock:nil
     ];
    
    
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
////    if([alertView.title isEqualToString:@"Warning: Multiple devices detected!"]){
////        if( buttonIndex == 1 ) {//Yes
////            //flagSetPrimaryDevice=[NSNumber numberWithInt:1];
////            conditionMultipleDevices=[NSNumber numberWithBool:YES];
////            privacy.deviceID=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
////            [self savePrivRulesToBackend];
////            
////            
////        }
////        else{//No
////            //flagSetPrimaryDevice=[NSNumber numberWithInt:0];
////            [self DataCleanBeforeLogout];
////            
////            
////            LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
////            loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
////            [self.window.rootViewController presentViewController:loginVC animated:NO completion:^{
////                //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
////                //jump to the root view controller: map;
////                //[self tabBarController].selectedIndex=0;
////            }
////             ];
////            //conditionMultipleDevices=[NSNumber numberWithBool:YES];
////            
////        }
////    }
//    
////    if([alertView.title isEqualToString:@"Location services are off"] || [alertView.title isEqualToString:@"Background location is not enabled"])
////    {//location Authorization alert;
////        if (buttonIndex == 1) {
////            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
////        }
////    }
//}

-(void)savePrivRulesToBackend{
    //AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    
    //PrivSetting * toSavePrivacy=[[PrivSetting alloc] initWithExistingPrivacy:appDelegate1.privacy];
    //[appDelegate1 addLocalNotificationsForLocationUpdating];
    //if(privStore==nil){
    //NSLog(@"%@",privStore);
    /*
     privStore=[KCSLinkedAppdataStore storeWithOptions:@{
     KCSStoreKeyCollectionName : @"UserPrivacy",
     KCSStoreKeyCollectionTemplateClass : [PrivSetting class],
     KCSStoreKeyCachePolicy:@(KCSCachePolicyNetworkFirst)
     }
     ];
     */
    //}
    
    
    PrivSetting *localizedPolicy=[privacy localizeExistingPrivacyToSave:privacy];
    
    id<KCSStore> privStore=[KCSLinkedAppdataStore storeWithOptions:@{
                KCSStoreKeyCollectionName : @"UserPrivacy",
                KCSStoreKeyCollectionTemplateClass : [PrivSetting class],
                KCSStoreKeyCachePolicy:@(KCSCachePolicyNetworkFirst)
        }
        ];
    
    
    [privStore saveObject:localizedPolicy withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil!=nil){
            
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:[@"when saving privacy setting to cloud server, error occured. " stringByAppendingString:[errorOrNil localizedDescription]]
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            
            [alert addAction:ok];
            
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            //NSLog(@"when saving privacy setting to backend, error occured. %@",errorOrNil);
        }
        else{
            
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Privacy setting has been saved!"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            
            [alert addAction:ok];
            
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            
        }
        
        
        //test
        NSLog(@"%@, %@",[[[UIDevice currentDevice] identifierForVendor] UUIDString],privacy.deviceID);
        //check if current device is the primary device of the user; then add local notif;
        if([privacy.deviceID isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]){
            //[self addLocalNotificationsForLocationUpdating];
            [self toggleUpdatingLocations];
        }
    
    } withProgressBlock:nil];
    
    //NSLog(@"%@",privStore);
    
}


-(void) initPrivSettingWithDefault{
    PrivSetting* defaultSetting=[PrivSetting alloc];
    defaultSetting.owner=[[KCSUser activeUser] userId];
    defaultSetting.user_id=[KCSUser activeUser];
    defaultSetting.StrangerVisible=[NSNumber numberWithInt:0];
    defaultSetting.SharingSwitch=[NSNumber numberWithInt:1];
    defaultSetting.SharingSwitch0=[NSNumber numberWithInt:1];
    defaultSetting.SharingRadius=[NSNumber numberWithFloat:3200];//3200km = 2 miles;
    defaultSetting.SharingTime=[[NSMutableArray alloc] init];
    defaultSetting.deviceID=[[[UIDevice currentDevice] identifierForVendor] UUIDString];//device id; 1 user can only have 1 device to represent his location;
    defaultSetting.activeLocationUntilWhen=
        [yearToSecondFormatter dateFromString:[[yearToDateFormatter stringFromDate:[NSDate date]] stringByAppendingString:@" 23:00:59"]];
    for(int i=0;i<7;i++){
        TimePeriodPrivacy* time1=[TimePeriodPrivacy alloc];
        switch (i) {
            case 0:
                time1.DayInWeek=@"Sunday";
                break;
            case 1:
                time1.DayInWeek=@"Monday";
                break;
            case 2:
                time1.DayInWeek=@"Tuesday";
                break;
            case 3:
                time1.DayInWeek=@"Wednesday";
                break;
            case 4:
                time1.DayInWeek=@"Thursday";
                break;
            case 5:
                time1.DayInWeek=@"Friday";
                break;
            case 6:
                time1.DayInWeek=@"Saturday";
                break;
            default:
                break;
        }
        
        time1.startTime=@"09:00";
        time1.endTime=@"23:00";
        
        [defaultSetting.SharingTime addObject:time1];
    }
    
    privacy=defaultSetting;
    //activeLocationUntilWhen=[yearToSecondFormatter dateFromString:[[yearToDateFormatter stringFromDate:[NSDate date]]
    //                         stringByAppendingString:@" 23:00:59"]
    //                        ];
    
}


-(BOOL) ShouldShareMyLocationOrNot{
    
    if(![privacy.SharingSwitch boolValue])return NO;
    
    NSDate* currentStamp=[NSDate date];
    NSString *strWeekday=[weekdayFormatter stringFromDate:currentStamp];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps = [gregorianCal components: (NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                  fromDate: currentStamp];
    
    NSInteger currentMinute=[dateComps minute];
    NSInteger currentHour=[dateComps hour];
    
    for(int i=0;i<privacy.SharingTime.count;i++){
        
        if([strWeekday isEqualToString:[[privacy.SharingTime objectAtIndex:i] DayInWeek]]){
            //test
            //NSLog(@"%@",[[[privacy.SharingTime objectAtIndex:i] endTime] substringToIndex:2]);
            //NSLog(@"%@",[[[privacy.SharingTime objectAtIndex:i] endTime] substringFromIndex:3]);
            if(
               ([[[[privacy.SharingTime objectAtIndex:i] startTime] substringToIndex:2] integerValue]<currentHour
               || ([[[[privacy.SharingTime objectAtIndex:i] startTime] substringToIndex:2] integerValue]==currentHour
               && [[[[privacy.SharingTime objectAtIndex:i] startTime] substringFromIndex:3] integerValue]<=currentMinute)
                )
               &&
               ([[[[privacy.SharingTime objectAtIndex:i] endTime] substringToIndex:2] integerValue]>currentHour
               || ([[[[privacy.SharingTime objectAtIndex:i] endTime] substringToIndex:2] integerValue]==currentHour
               && [[[[privacy.SharingTime objectAtIndex:i] endTime] substringFromIndex:3] integerValue]>currentMinute)
                )
               
               ){
                
                return YES;
            }
        }
    }
    
    return NO;
}

-(void) toggleUpdatingLocations{
    //if it satisfies privacy policy;
    
    //test
    //[self addLocalNotificationsForLocationUpdating];
    
    if([self ShouldShareMyLocationOrNot] && [conditionMultipleDevices boolValue]){
        //NSLog(@"Not Satisfying privacy policy to update self-location.");
        //return;
        /*
        [locManager startUpdatingLocation];*/
        /*[[LocationKit sharedInstance] getCurrentLocationWithHandler:^(CLLocation *location, NSError *error) {
            if (error == nil) {
                NSLog(@"%.6f, %.6f, %@",
                      location.coordinate.latitude,
                      location.coordinate.longitude,
                      location.timestamp);
            } else {
                NSLog(@"Error: %@", error);
            }
            latestUpdatedLocation=location;
        }];*/
        [self.locationManager startUpdatingLocation];
    }
    else{
        /*
        [locManager stopUpdatingLocation];*/
        
        //[[LocationKit sharedInstance] pause];
        [self.locationManager startUpdatingLocation];
    }
}

-(void) stopUpdatingLocations{
    /*
    [locManager stopUpdatingLocation];*/
}

//failed to get locatoin
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    //check the failure reasons here;
    
}






/*
//got an update;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //test gamma distribution;
//    int v=0;
//    for(int i=0;i<10000;i++){
//        double x=GenGammaRV([privacy.SharingRadius floatValue]);
//        //NSLog(@"%f",x);
//        if(x<3.8900/2*[privacy.SharingRadius floatValue]){
//            v++;
//        }
//    }
    
    
    
    //NSLog(@"received location updating");
    CLLocation *currentLocation=[locManager location];
    
    if(dateFormatter==nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    
    
    if(LocSeriesStore==nil){
        LocSeriesStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LocSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
                                                            }];
    }
    if(LokSeriesStore==nil){
        LokSeriesStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LokSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
                                                            }];
    }
    
    double speed=currentLocation.speed;
    if(latestUpdatedLocation!=nil){
        ///find the next-5-minute local notif as tmp;
        NSArray* existingNotifs=[[UIApplication sharedApplication] scheduledLocalNotifications];
        UILocalNotification *tmp;
        for(int i=0;i<existingNotifs.count;i++){
            //find the previous scheduled localNotif(the next-5minute notif)
            if([[[existingNotifs objectAtIndex:i] userInfo] objectForKey:@"temporary"]){
                tmp=[existingNotifs objectAtIndex:i];
            }
        }
        
        
        NSTimeInterval howRecent = [
                                    [dateFormatter dateFromString:[dateFormatter stringFromDate:currentLocation.timestamp]
                                     ]
                                    timeIntervalSinceDate:latestUpdatedLocation.timestamp
                                    ];
        //absolute value of speed.
        //speed=currentLocation.speed;
        NSLog(@"speed of user: %f m/s",speed);
        
        //a special case; if iphone locate itself, several locations are updated within 1 second;
        if(howRecent>1){
        if(speed>1){
            //ajust distanceFilter to reduce  updating frequency;
            locManager.distanceFilter=speed*300;
            

            if(tmp!=nil){
                [[UIApplication sharedApplication] cancelLocalNotification:tmp];
            }
            
            NSDate* nextLaunchTime=[[NSDate date] dateByAddingTimeInterval:300];
            tmp = [[UILocalNotification alloc] init];
            tmp.fireDate =nextLaunchTime;
            tmp.timeZone = [NSTimeZone defaultTimeZone];
            tmp.hasAction=NO;
            tmp.repeatInterval=0;
            tmp.userInfo=@{@"temporary":[NSNumber numberWithBool:YES]};
            [[UIApplication sharedApplication] scheduleLocalNotification:tmp];
            
        }
        else{
        //if(speed<1){//walking very slowly, even slower than me;
            //ajust distanceFilter to reduce  updating frequency;
            locManager.distanceFilter=10;
        //}
        }}
        
    }
    
    
    
    NSLog(@"latestUpdatedLocation=%@",latestUpdatedLocation);
    //save perturbed location to lokSeries;
    if([[locManager location] distanceFromLocation:latestUpdatedLocation]>100  || latestUpdatedLocation==nil){//only update the perturbed location if movement>100m;
        LocSeries* perturbed = [[LocSeries alloc] init];
        perturbed.owner =[KCSUser activeUser].userId;
        perturbed.userDate = currentLocation.timestamp;
        perturbed.precision=privacy.SharingRadius;//in km;
        perturbed.validUntilWhen=activeLocationUntilWhen;
        
        double bearing=GenRandomU01()*2*M_PI;
        double r=GenGammaRV([privacy.SharingRadius floatValue]*1000);
        CLLocationCoordinate2D  perturbedCoordinate=[self locationWithBearing:bearing
                                                                     distance:r
                                                                 fromLocation:currentLocation.coordinate ];
        
        perturbed.location =CLLocationCoordinate2DToKCS(perturbedCoordinate);
        perturbed.speed=[NSNumber numberWithDouble:[currentLocation distanceFromLocation:[CLLocation locationFromKinveyValue:CLLocationCoordinate2DToKCS(perturbedCoordinate)]]];
        NSLog(@"%f",[currentLocation distanceFromLocation:[CLLocation locationFromKinveyValue:CLLocationCoordinate2DToKCS(perturbedCoordinate)]]);
        
        [LokSeriesStore saveObject:perturbed withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                
            } else {
                BOOL wasNetworkError = [errorOrNil domain] == KCSNetworkErrorDomain;
                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a netowrk error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message                                                           delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } withProgressBlock:nil];
        
    }
    
    
    
    
    //save true location to backend
    if([[locManager location] distanceFromLocation:latestUpdatedLocation]>10 || latestUpdatedLocation==nil){//only update the perturbed location if movement>1.5m;
        LocSeries* update = [[LocSeries alloc] init];
        update.owner =[KCSUser activeUser].userId;
        update.userDate = currentLocation.timestamp;
        update.precision=[NSNumber numberWithInt:0];
        update.location =[currentLocation kinveyValue];
        update.validUntilWhen=activeLocationUntilWhen;
        update.speed=[NSNumber numberWithDouble:speed];
        update.course=[NSNumber numberWithDouble:currentLocation.course];
        update.movement=[NSNumber numberWithDouble:[[locManager location] distanceFromLocation:latestUpdatedLocation]];
        //update.validUntilWhen=[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLocationUntilWhen"];
        
        //Kinvey use code: add a new update to the updates collection
        [LocSeriesStore saveObject:update withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                
            } else {
                BOOL wasNetworkError = [errorOrNil domain] == KCSNetworkErrorDomain;
                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a netowrk error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message                                                           delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } withProgressBlock:nil];
        
        
        
        
        // *********update latestUpdatedLocation**********************
        latestUpdatedLocation = [self.locManager location];
    }
    
    
    
    
   
    //send notification to viewController to update map, when in active status;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ||
        [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:GotSelfLocationUpdateNotification
         object:nil
         ];
    }
}
*/

//- (void)locationKit:(LocationKit *)locationKit
-(void)locationManager:(LKLocationManager *)manager
  didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation=[locations firstObject];
    NSLog(@"%f, %f, %@,%f,%f",
          currentLocation.coordinate.latitude,
          currentLocation.coordinate.longitude,
          currentLocation.timestamp,
          [currentLocation distanceFromLocation:latestTrueLocation],
          currentLocation.horizontalAccuracy);
    
    if([self ShouldShareMyLocationOrNot]){
        //[[LocationKit sharedInstance] setOperationMode:LKmode_active];
    }
    else{
        //[[LocationKit sharedInstance] setOperationMode:LKmode_inactive];
        return;
    }
    
    if(dateFormatter==nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
    
    
    if(LocSeriesStore==nil){
        LocSeriesStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LocSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
                                                            }];
    }
    if(LokSeriesStore==nil){
        LokSeriesStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LokSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
                                                            }];
    }
    
    double speed=currentLocation.speed;
    
    
    //save perturbed location to lokSeries;
    if(currentLocation.horizontalAccuracy>0 && currentLocation.horizontalAccuracy<=100.0){
    if([currentLocation distanceFromLocation:latestTrueLocation]>100  || latestPerturbedLocation==nil){//only update the perturbed location if movement>100m;
        LocSeries* perturbed = [[LocSeries alloc] init];
        perturbed.owner =[KCSUser activeUser].userId;
        perturbed.userDate = currentLocation.timestamp;
        perturbed.precision=privacy.SharingRadius;//in km;
        perturbed.validUntilWhen=activeLocationUntilWhen;
        
        double bearing=GenRandomU01()*2*M_PI;
        //test
        //for(int i=0;i<10;i++){
        //    NSLog(@"%f",GenGammaRV59([privacy.SharingRadius floatValue])*1000);
        //}
        //double r=GenGammaRV([privacy.SharingRadius floatValue]*1000);
        //change radius to the circle containing 99% probability mass.
        double r=GenGammaRV59([privacy.SharingRadius floatValue]);//(2/radius)-differential privacy;
        CLLocationCoordinate2D  perturbedCoordinate=[self locationWithBearing:bearing
                                                                     distance:r
                                                                 fromLocation:currentLocation.coordinate ];
        
        perturbed.location =CLLocationCoordinate2DToKCS(perturbedCoordinate);
        perturbed.speed=[NSNumber numberWithDouble:[currentLocation distanceFromLocation:[CLLocation locationFromKinveyValue:CLLocationCoordinate2DToKCS(perturbedCoordinate)]]];
        NSLog(@"%f",[currentLocation distanceFromLocation:[CLLocation locationFromKinveyValue:CLLocationCoordinate2DToKCS(perturbedCoordinate)]]);
        
        [LokSeriesStore saveObject:perturbed withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                
            } else {
//                BOOL wasNetworkError = [errorOrNil domain] == KCSNetworkErrorDomain;
//                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a netowrk error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
//                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
//                                                                message:message                                                           delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                                      otherButtonTitles:nil];
//                [alert show];
            }
        } withProgressBlock:nil];
        
        
        latestPerturbedLocation=[[CLLocation alloc] initWithLatitude:perturbedCoordinate.latitude longitude:perturbedCoordinate.longitude];
        
        //send notification to viewController to update map, when in active status;
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ||
            [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:GotSelfPerturbedLocationNotification
             object:nil
             ];
        }
        
    }}
    
    
    
    
    //save true location to backend
    //if(currentLocation.horizontalAccuracy>0 && currentLocation.horizontalAccuracy<=200.0){
    if(1){
    if([currentLocation distanceFromLocation:latestTrueLocation]>10 || latestTrueLocation==nil){
        //only update the true location if movement>10m;
        LocSeries* update = [[LocSeries alloc] init];
        update.owner =[KCSUser activeUser].userId;
        update.userDate = currentLocation.timestamp;
        update.precision=[NSNumber numberWithDouble: currentLocation.horizontalAccuracy];
        //update.precision=[NSNumber numberWithInt:currentLocation.horizontalAccuracy];
        update.location =[currentLocation kinveyValue];
        update.validUntilWhen=activeLocationUntilWhen;
        update.speed=[NSNumber numberWithDouble:speed];
        update.course=[NSNumber numberWithDouble:currentLocation.course];
        update.movement=[NSNumber numberWithDouble:[currentLocation distanceFromLocation:latestTrueLocation]];
        update.mode=[NSNumber numberWithInteger:ActivityMode];
        //update.validUntilWhen=[[NSUserDefaults standardUserDefaults] objectForKey:@"activeLocationUntilWhen"];
        
        //Kinvey use code: add a new update to the updates collection
        [LocSeriesStore saveObject:update withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                
            } else {
//                BOOL wasNetworkError = [errorOrNil domain] == KCSNetworkErrorDomain;
//                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a netowrk error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
//                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
//                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
//                                                                message:message                                                           delegate:self
//                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                                      otherButtonTitles:nil];
//                [alert show];
            }
        } withProgressBlock:nil];
        
        
        // *********check the meeting friends & update meeting status*****
        [fList checkMeetingFriends:currentLocation];
        
        // *********update latestUpdatedLocation**********************
        latestTrueLocation = currentLocation;
        
        //send notification to viewController to update map, when in active status;
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ||
            [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:GotSelfTrueLocationNotification
             object:nil
             ];
        }
    }}
    
    
    
    
    
    
    
}

/*
- (void)locationKit:(LocationKit *)locationKit willChangeActivityMode:(LKActivityMode )mode {
    ActivityMode=mode;
    
//    if(mode==LKActivityModeStationary && latestUpdatedLocation.horizontalAccuracy<=50.0){//if stay put, then save power with lower accuracy;
//        [[LocationKit sharedInstance] setOperationMode:LKmode_inactive];
//    }
    
}
*/

/*
-(void) addLocalNotificationsForLocationUpdating{
    
    NSArray* existingNotifs=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for(int i=0;i<existingNotifs.count;i++){
        NSLog(@"%@",[[existingNotifs objectAtIndex:i] userInfo]);
        
        //find the previous scheduled localNotif(not the next-5minute notif)
        if([[[existingNotifs objectAtIndex:i] userInfo] objectForKey:@"endTime"]!=nil){
            [[UIApplication sharedApplication] cancelLocalNotification:[existingNotifs objectAtIndex:i]];
            
        }
        //looks weired but works;
        NSLog(@"%d",existingNotifs.count);
        NSLog(@"%d",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    }
    
    NSDate * today =[NSDate date];
    NSInteger DayToday=[CommonFunctions Weekday2Number:[weekdayFormatter stringFromDate:today]];
    NSString *strNotificationTimes;
    
    NSDate *startDate, *endDate;
    
    // Schedule the notification
    for(int i=0;i<privacy.SharingTime.count;i++){
        NSInteger DayPrivacy=[CommonFunctions Weekday2Number:[[privacy.SharingTime objectAtIndex:i] DayInWeek]];
        NSInteger days=(DayPrivacy-DayToday+7)%7;
        if(days==0){//for today, only add two non-repeatable local notifications;
            days=7;
            strNotificationTimes=[yearToDateFormatter stringFromDate:today];
            strNotificationTimes=[[[strNotificationTimes stringByAppendingString:@" " ] stringByAppendingString:[[privacy.SharingTime objectAtIndex:i] startTime]]
                stringByAppendingString:@":00"];
            startDate=[yearToSecondFormatter dateFromString:strNotificationTimes];
            
            strNotificationTimes=[yearToDateFormatter stringFromDate:today];
            strNotificationTimes=[[[strNotificationTimes stringByAppendingString:@" " ] stringByAppendingString:[[privacy.SharingTime objectAtIndex:i] endTime]]
                stringByAppendingString:@":59"];
            endDate=[yearToSecondFormatter dateFromString:strNotificationTimes];
            
            //only if currentTime<endDate, should we add this local notif;
            if([today timeIntervalSinceDate:endDate]<0){
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate =startDate;
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.applicationIconBadgeNumber=1;
                //localNotification.hasAction=NO;
                //localNotification.applicationIconBadgeNumber=7;
                localNotification.userInfo=@{@"startTime":startDate,@"endTime":endDate};
                localNotification.repeatInterval=0;
                //localNotification.userInfo=[NSDictionary ];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                
                
                
                UILocalNotification* localNotification2 = [[UILocalNotification alloc] init];
                localNotification2.fireDate =endDate;
                localNotification2.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.applicationIconBadgeNumber=2;
                //localNotification2.hasAction=NO;
                localNotification2.repeatInterval=0;
                //localNotification2.userInfo=@{@"startTime":startDate,@"endTime":endDate};
                localNotification2.userInfo=@{@"endTime":endDate};
                //localNotification.userInfo=[NSDictionary ];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification2];
            }
            
        }//if(days==0)
        
        
        strNotificationTimes=[yearToDateFormatter stringFromDate:[today dateByAddingTimeInterval:60*60*24*days]];
        strNotificationTimes=[[[strNotificationTimes stringByAppendingString:@" " ] stringByAppendingString:[[privacy.SharingTime objectAtIndex:i] startTime]]
            stringByAppendingString:@":00"];
        startDate=[yearToSecondFormatter dateFromString: strNotificationTimes];
        strNotificationTimes=[yearToDateFormatter stringFromDate:[today dateByAddingTimeInterval:60*60*24*days]];
        strNotificationTimes=[[[strNotificationTimes stringByAppendingString:@" " ] stringByAppendingString:[[privacy.SharingTime objectAtIndex:i] endTime]]
            stringByAppendingString:@":59"];
        endDate=[yearToSecondFormatter dateFromString: strNotificationTimes];
        NSLog(@"startDate=%@,endDate=%@",startDate,endDate);
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate =startDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.hasAction=NO;
        localNotification.userInfo=@{@"startTime":startDate,@"endTime":endDate};
        //localNotification.applicationIconBadgeNumber=7;
        localNotification.repeatInterval=NSWeekCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        UILocalNotification* localNotification2 = [[UILocalNotification alloc] init];
        localNotification2.fireDate =endDate;
        localNotification2.timeZone = [NSTimeZone defaultTimeZone];
        localNotification2.hasAction=NO;
        //localNotification2.userInfo=@{@"startTime":startDate,@"endTime":endDate};
        localNotification2.userInfo=@{@"endTime":endDate};
        localNotification2.repeatInterval=NSWeekCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification2];
        
        
        
    }
    
    
}
*/
 
 
 
- (CLLocationCoordinate2D) locationWithBearing:(double)bearing distance:(double)distanceMeters fromLocation:(CLLocationCoordinate2D)origin {
    //bearing: The bearing (or azimuth) is the compass direction to travel from the starting point, and must be within the range 0 to 360. 0 represents north, 90 is east, 180 is south and 270 is west.
    CLLocationCoordinate2D target;
    double distRadians = distanceMeters / 6372797.6; // earth radius in meters
    
    double lat1 = origin.latitude * M_PI / 180;
    double lon1 = origin.longitude * M_PI / 180;
    
    double lat2 = asin( sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing));
    double lon2 = lon1 + atan2( sin(bearing) * sin(distRadians) * cos(lat1),
                              cos(distRadians) - sin(lat1) * sin(lat2) );
    
    target.latitude = lat2 * 180 / M_PI;
    target.longitude = lon2 * 180 / M_PI; // no need to normalize a heading in degrees to be within -179.999999° to 180.00000°
    
    return target;
}

-(NSString *)getUniqueDeviceIdentifierAsString
{
    
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID = [SSKeychain passwordForService:appName account:@"incoding"];
    if (strApplicationUUID == nil)
    {
        strApplicationUUID  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:strApplicationUUID forService:appName account:@"incoding"];
    }
    
    return strApplicationUUID;
}

@end
