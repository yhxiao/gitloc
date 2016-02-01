//
//  User_Photo.h
//  LocShare
//
//  Created by yxiao on 5/27/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>


@interface User_Photo : NSObject<KCSPersistable>
@property (nonatomic, retain) KCSUser* user_id;
@property (nonatomic, retain) UIImage* photo;//******for image
@property (nonatomic, retain) NSString* entityId;
@property (nonatomic, retain) NSString* photoURL;
@property (nonatomic, retain) KCSMetadata* meta;
@property (nonatomic, retain) NSDate* date;
//@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional

@end