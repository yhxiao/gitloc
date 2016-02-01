//
//  User_Photo.m
//  LocShare
//
//  Created by yxiao on 5/27/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import "User_Photo.h"
//#import <UIKit/UIKit.h>

@implementation User_Photo
//@synthesize user_id,photo;

- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"entityId"   : KCSEntityKeyId, //the required _id field
             //@"metadata" : KCSEntityKeyMetadata,
             @"meta"       : KCSEntityKeyMetadata,
             @"photo"      : @"photo",
             @"photoURL"   : @"photoURL",
             @"user_id"    : @"user_id",
             @"date"       : @"date"
             };
}

+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{      @"photo":KCSFileStoreCollectionName,
             
                @"user_id" :KCSUserCollectionName
             };
}
//designate this function to save the referenced objects
//- (NSArray *)referenceKinveyPropertiesOfObjectsToSave
//{
//    return @[@"photo"];
//}

//+(NSDictionary *)kinveyObjectBuilderOptions{//optinal, reference class map - maps properties to objects
//    return @{ KCS_REFERENCE_MAP_KEY : @{
//                      @"user_id" : [KCSUserCollectionName class]
//                      ,@"photo": [KCSFileStoreCollectionName class]
//                                         }
//              };
//}

@end
