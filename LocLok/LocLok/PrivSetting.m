//
//  PrivSetting.m
//  LocShare
//
//  Created by yxiao on 8/22/15.
//  Copyright (c) 2015 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivSetting.h"


@implementation PrivSetting
@synthesize owner,SharingSwitch,SharingRadius,SharingTime,StrangerVisible,user_id,entityId,SharingSwitch0,meta;//,privStore;


- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{@"entityId" : KCSEntityKeyId,
             @"owner"           : @"owner",
             @"SharingSwitch"   : @"SharingSwitch",
             @"SharingSwitch0"   : @"SharingSwitch0",
             @"SharingRadius"   : @"SharingRadius",
             @"StrangerVisible" : @"StrangerVisible",// to strangers;
             @"SharingTime"     : @"SharingTime",
             @"meta"            : KCSEntityKeyMetadata,
             @"user_id"         : @"user_id",
             @"deviceID"        : @"deviceID",
             @"activeLocationUntilWhen" : @"activeLocationUntilWhen"
             };
}

+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"user_id" :KCSUserCollectionName
             
             };
}

//+(PrivSetting*) initWithDefault{
//    PrivSetting* defaultSetting=[PrivSetting alloc];
//    defaultSetting.owner=[[KCSUser activeUser] userId];
//    defaultSetting.user_id=[KCSUser activeUser];
//    defaultSetting.StrangerVisible=[NSNumber numberWithInt:0];
//    defaultSetting.SharingSwitch=[NSNumber numberWithInt:1];
//    defaultSetting.SharingRadius=[NSNumber numberWithFloat:3.2];
//    defaultSetting.SharingTime=[[NSMutableArray alloc] init];
//    for(int i=0;i<7;i++){
//        TimePeriodPrivacy* time1=[TimePeriodPrivacy alloc];
//        switch (i) {
//            case 0:
//                time1.DayInWeek=strSunday;
//                break;
//            case 1:
//                time1.DayInWeek=strMonday;
//                break;
//            case 2:
//                time1.DayInWeek=strTuesday;
//                break;
//            case 3:
//                time1.DayInWeek=strWednesday;
//                break;
//            case 4:
//                time1.DayInWeek=strThursday;
//                break;
//            case 5:
//                time1.DayInWeek=strFriday;
//                break;
//            case 6:
//                time1.DayInWeek=strSaturday;
//                break;
//            default:
//                break;
//        }
//        
//        time1.startTime=@"09:00";
//        time1.endTime=@"17:00";
//        
//        [defaultSetting.SharingTime addObject:time1];
//    }
//    return defaultSetting;
//}

-(PrivSetting*)localizeExistingPrivacyToSave:(PrivSetting*)existingPrivacy{
    PrivSetting* newPolicy=[[PrivSetting alloc] init];
    newPolicy.entityId=existingPrivacy.entityId;
    newPolicy.owner=existingPrivacy.owner;
    newPolicy.SharingSwitch0=existingPrivacy.SharingSwitch0;
    newPolicy.SharingSwitch=existingPrivacy.SharingSwitch;
    newPolicy.StrangerVisible=existingPrivacy.StrangerVisible;
    newPolicy.SharingRadius=existingPrivacy.SharingRadius;
    newPolicy.user_id=existingPrivacy.user_id;
    newPolicy.meta=existingPrivacy.meta;
    newPolicy.deviceID=existingPrivacy.deviceID;
    newPolicy.activeLocationUntilWhen=existingPrivacy.activeLocationUntilWhen;
    
    NSMutableArray* rules=[[NSMutableArray alloc]init];
    TimePeriodPrivacy * timePriv;
    for(int i=0;i<SharingTime.count;i++){
        timePriv=[SharingTime objectAtIndex:i];
        [rules addObject:
         [[[[timePriv.DayInWeek stringByAppendingString:@";"]
            stringByAppendingString:timePriv.startTime ]
           stringByAppendingString:@";" ]
          stringByAppendingString:timePriv.endTime ]
         
         ];
    }
    
    newPolicy.SharingTime=rules;
    
    
    return newPolicy;
    
}


@end