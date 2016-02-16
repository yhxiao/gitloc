//
//  LocSeries.m
//  LocShare
//
//  Created by yxiao on 6/11/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//


#import "LocSeries.h"

@implementation LocSeries
@synthesize owner ;
@synthesize kinveyId ;
@synthesize userDate ;
//@synthesize attachment = _attachment;
@synthesize precision,speed,course,movement,mode;
@synthesize meta ;
@synthesize location ,validUntilWhen;

// Kinvey code use: any "KCSPersistable" has to implement this mapping method
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"owner"      : @"owner",
             @"userDate"   : @"userDate",
             @"validUntilWhen":@"validUntilWhen",
             //@"attachment" : @"attachment",
             @"precision"  : @"precision",
             @"speed"      : @"speed",
             @"course"     : @"course",
             @"movement"   : @"movement",
             @"mode"       : @"mode",
             @"meta"       : KCSEntityKeyMetadata,
             @"kinveyId"   : KCSEntityKeyId,
             @"location"   : KCSEntityKeyGeolocation,
             };
}
@end
