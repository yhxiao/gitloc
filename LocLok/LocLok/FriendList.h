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
#import "MeetEvent.h"
#import "CommonFunctions.h"
//#import "AppDelegate.h"

@interface FriendList : NSObject
@property (strong, nonatomic) NSArray *friends;//out friends, I can view their locations;
//@property (strong, nonatomic) NSArray *frdMeetings;
@property (strong, nonatomic) NSMutableArray *frdLocations;
@property (strong, nonatomic) NSMutableArray *inFriends;//in friends, who can view my locations;
@property (nonatomic, retain) NSMutableArray* NotifsFromMe;//add friends requests from me;
@property (nonatomic, retain) NSMutableArray* NotifsToMe;// add friends requests to me;
@property (nonatomic, retain) NSMutableArray* NotifsMeeting;//unfinished meetings;

@property (nonatomic, retain) id<KCSStore> addFriendStore;//AddFriend store;
@property (strong,nonatomic) id<KCSStore> frdStore;
@property (strong,nonatomic) id<KCSStore> PhotoStore;
@property (strong,nonatomic) id<KCSStore> meetStore;

//@property (strong,nonatomic) id<KCSStore> MeetStore;
@property (strong,nonatomic) id<KCSStore> LocStore;//true location store;
@property (strong,nonatomic) id<KCSStore> LokStore;//cloaked location store;
//@property (strong,nonatomic)NSNumber* myMeetingFriendIndex;

+(void)checkNewFriend;//check in the AddFreiend table to see if anyone just accepted my requests;
-(FriendList*)loadWithID:(NSString*)user_id;
-(void)updateLocations;
-(void)checkMeetingFriends:(CLLocation*)myLocation;

+(void)AddOneFriend:(KCSUser*)addUser Permission:(NSNumber*)perm Controller:(id)controller Initial:(NSNumber*)initial;
//initial can be either AddFriendFirstTime or AddFriendModifyPermission;

-(void)searchNotifInAddFriends;
-(void)searchNotifAboutMeetings;
-(void)searchFriendsHavingMyPermissions;
@end
