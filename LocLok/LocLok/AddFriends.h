//
//  AddFriends.h
//  LocShare
//
//  Created by yxiao on 1/3/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
//#import "Friendship.h"

typedef NS_ENUM(NSInteger, AddFriendagreed) {
    AddFriendFirstTime=0,//first time add friend; value=0;
    AddFriendModifyPermission=1,//modify permission; value=1;
    AddFriendRequestBack=2//after agree friendship, request friendship back to the requester;
};

@interface AddFriends : NSObject<KCSPersistable>
@property (nonatomic, retain) KCSUser* from_user;
@property (nonatomic, retain) KCSUser* to_user;
@property (nonatomic, retain) NSString* from_givenName;
@property (nonatomic, retain) NSString* from_surname;
@property (nonatomic, retain) NSString* to_givenName;
@property (nonatomic, retain) NSString* to_surname;
@property (nonatomic, retain) NSNumber* permission;
@property (nonatomic, retain) NSNumber* agreed;
@property (nonatomic, retain) NSNumber* finished;
@property (nonatomic, copy) NSString* entityId;
@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional
@property (nonatomic, retain) NSDate* date;


@end
