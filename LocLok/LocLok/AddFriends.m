//
//  AddFriends.m
//  LocShare
//
//  Created by yxiao on 1/3/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import "AddFriends.h"

@implementation AddFriends
//@synthesize from_user,to_user,agreed,finished,permission,date;
//@synthesize entityId,metadata;


- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId"      : KCSEntityKeyId, //the required _id field
             @"metadata"      : KCSEntityKeyMetadata,
             @"from_user"     : @"from_user",
             @"to_user"       : @"to_user",
             @"from_givenName": @"from_givenName",
             @"from_surname"  : @"from_surname",
             @"to_givenName"  : @"to_givenName",
             @"to_surname"    : @"to_surname",
             @"agreed"        : @"agreed",
             @"finished"      : @"finished",
             @"permission"    : @"permission",
             @"date"          : @"date"
             };
}

+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"from_user" /* backend field name */
             : KCSUserCollectionName /* collection name for invitations */
             ,
             @"to_user"
             :KCSUserCollectionName
             };
}
//+(NSDictionary *)kinveyObjectBuilderOptions{// reference class map - maps properties to objects
//    return @{ KCS_REFERENCE_MAP_KEY : @{ @"from_user" : [KCSUserCollectionName class]
//                                         
//                                         }
//              ,
//              KCS_REFERENCE_MAP_KEY:@{@"to_user":[KCSUserCollectionName class]
//                                      }
//              };
//}

//- (NSArray *)referenceKinveyPropertiesOfObjectsToSave
//{
//    return @[@"from_user"];
//}

@end
