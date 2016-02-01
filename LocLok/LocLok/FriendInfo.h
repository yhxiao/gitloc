//
//  FriendInfo.h
//  LocShare
//
//  Created by yxiao on 1/5/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface FriendInfo : NSObject
@property (nonatomic,strong) KCSUser *user;
@property BOOL is_new_friend;
@property (nonatomic,strong) NSNumber *permission_to_me;
@property (nonatomic,strong) NSNumber * user_color;
@property (nonatomic,strong) UIImage * user_image;
@property BOOL to_be_shown;



@end
