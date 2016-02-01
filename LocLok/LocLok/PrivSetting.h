//
//  PrivSetting.h
//  LocShare
//
//  Created by yxiao on 8/22/15.
//  Copyright (c) 2015 Yonghui Xiao. All rights reserved.
//
#import<KinveyKit/KinveyKit.h>
//#import "AppDelegate.h"
#import "TimePeriodPrivacy.h"
@interface PrivSetting : NSObject<KCSPersistable>

@property (strong, nonatomic) NSString * entityId;
@property  (strong, nonatomic) NSString* owner;
@property  (strong, nonatomic) NSNumber* SharingSwitch0;//do not share true location if NO;
@property  (strong, nonatomic) NSNumber* SharingSwitch;// do not share any location if ==NO;
@property  (strong, nonatomic) NSNumber* StrangerVisible;// let strangers find me if ==YES;
@property (strong, nonatomic) NSNumber* SharingRadius;//km
@property (strong, nonatomic) NSMutableArray* SharingTime;
@property (nonatomic, retain) KCSUser* user_id;
@property  (strong, nonatomic) NSString* deviceID;
@property  (strong, nonatomic) NSDate* activeLocationUntilWhen;//indicates the time until when current location is active;
@property (nonatomic, retain) KCSMetadata* meta;
//@property (strong,nonatomic) id<KCSStore> privStore;

//+(PrivSetting*) initWithDefault;//initialize with the default values;
//+(PrivSetting*) getFromBackend;//get privacy setting of current user from backend;
//-(void)saveToBackend;//save privacy setting of current user to backend;
-(PrivSetting*)localizeExistingPrivacyToSave:(PrivSetting*)existingPrivacy;//create another PrivSetting that can be saved to cloud;
@end