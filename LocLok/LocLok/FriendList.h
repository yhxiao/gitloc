//
//  FriendList.h
//  LocShare
//
//  Created by yxiao on 1/5/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
#import "FriendInfo.h"
#import "AddFriends.h"
#import "Friendship.h"
#import "User_Photo.h"
#import "LocSeries.h"
#import "CommonFunctions.h"
@interface FriendList : NSObject
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSMutableArray *frdLocations;
@property (strong,nonatomic) id<KCSStore> frdStore;
@property (strong,nonatomic) id<KCSStore> PhotoStore;
@property (strong,nonatomic) id<KCSStore> LocStore;//true location store;
@property (strong,nonatomic) id<KCSStore> LokStore;//cloaked location store;
+(void)checkNewFriend;//check in the AddFreiend table to see if anyone just accepted my requests;
-(FriendList*)loadWithID:(NSString*)user_id;
-(void)updateLocations;
@end
