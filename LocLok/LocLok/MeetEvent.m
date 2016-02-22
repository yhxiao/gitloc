//
//  MeetEvent.m
//  LocLok
//
//  Created by yxiao on 2/18/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import "MeetEvent.h"

@implementation MeetEvent

//@synthesize from_user,to_user,start_time,end_time,MeetEventStatus,from_location,distance,to_location;

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId"      : KCSEntityKeyId, //the required _id field
             @"metadata"      : KCSEntityKeyMetadata,
             @"from_user"     : @"from_user",
             @"to_user"       : @"to_user",
             @"MeetEventStatus"        : @"status",
             @"start_time"    : @"start_time",
             @"end_time"      : @"end_time",
             @"from_location" : @"from_location",
             @"to_location"   : @"to_location",
             @"distance"      : @"distance"
             };
}



+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"from_user" /* backend field name */ : KCSUserCollectionName /* collection name for invitations */
             ,
             @"to_user":KCSUserCollectionName
             };
}

@end
