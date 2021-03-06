//
//  Friendship.m
//  LocShare
//
//  Created by yxiao on 1/4/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import "Friendship.h"

@implementation Friendship
@synthesize from_user,to_user,permission,shownColor;

//const int PermissionFamily=0,PermissionFriends=10;


- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId"   : KCSEntityKeyId, //the required _id field
             @"metadata"   : KCSEntityKeyMetadata,
             @"from_user"  : @"from_user",
             @"to_user"    : @"to_user",
             @"permission" : @"permission",
             @"shownColor" : @"shownColor",
             @"from_surname"  : @"from_surname",
             @"to_givenName"  : @"to_givenName",
             @"to_surname"    : @"to_surname",
             @"from_givenName": @"from_givenName",
             @"meetinglink": @"meetinglink"
             };
}

+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"from_user" /* backend field name */ : KCSUserCollectionName /* collection name for invitations */
             ,
             @"to_user":KCSUserCollectionName,
             @"meetinglink":@"MeetEvent"
             };
}
//+(NSDictionary *)kinveyObjectBuilderOptions{//optinal, reference class map - maps properties to objects
//    return @{ KCS_REFERENCE_MAP_KEY : @{ //@"from_user" : [KCSUserCollectionName class],
//                                         //@"to_user":[KCSUserCollectionName class],
//                                         @"meetinglink":[MeetEvent class]
//                                         }
//              };
//}
//- (NSArray *)referenceKinveyPropertiesOfObjectsToSave
//{
//    return @[@"meetinglink"];
//}
@end
