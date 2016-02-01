//
//  LocSeries.h
//  LocShare
//
//  Created by yxiao on 6/11/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>

@interface LocSeries : NSObject <KCSPersistable>

@property (nonatomic, retain) NSString* owner;
@property (nonatomic, retain) NSString* kinveyId;
@property (nonatomic, retain) NSDate* userDate;
@property (nonatomic, retain) NSDate* validUntilWhen;
@property (nonatomic, retain) NSNumber* precision;
@property (nonatomic, retain) NSNumber* speed;
@property (nonatomic, retain) NSNumber* movement;
@property (nonatomic, retain) NSNumber* course;
@property (nonatomic, retain) NSNumber* mode;//walk,run,cycling,drive;
//@property (nonatomic, retain) UIImage* attachment;
@property (nonatomic, retain) KCSMetadata* meta;
@property (nonatomic, retain) NSArray* location;

@end
