//
//  Friendship.h
//  LocShare
//
//  Created by yxiao on 1/4/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
typedef NS_ENUM(NSInteger, AllLocPermissions) {
    PermissionForFamily,//show protected location; value=0;
    PermissionForFriends//show precise location; value=1;
};

@interface Friendship : NSObject<KCSPersistable>
@property (nonatomic, retain) KCSUser* from_user;
@property (nonatomic, retain) KCSUser* to_user;
@property (nonatomic, retain) NSNumber* permission;
@property (nonatomic, retain) NSNumber* shownColor;
@property (nonatomic, retain) NSString* from_id;
@property (nonatomic, retain) NSString* to_id;
@property (nonatomic, copy) NSString* entityId;
@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional

@end
