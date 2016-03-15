//
//  MeetEvent.h
//  LocLok
//
//  Created by yxiao on 2/18/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
const int Nearby_meters=300;
const int Meet_meters=50;

typedef NS_ENUM(NSInteger, MeetEventStatus) {
    MeetEventFinished=0,//0//if their distance<Meet_meters, status=MeetEventFinished, set end_time;
    MeetEventNearby=1,//1//if one of the two users reaches Nearby_meters, then status=MeetEventNearby;
    MeetEventHalfway=2,//2//if one of the two users reaches halfway, then status=MeetEventHalfway;
    MeetEventAgreed=3,//3//to_user agrees the request, then save the meetEvent with from_user, to_user, status=MeetEventAgreed,start_time,end_time=nil,from_location,to_location,distance;
    MeetEventRequest=4,//4//from_user sends request to to_user, save a meetEvent with from_user, to_user, status=MeetEventRequest,start_time,end_time=nil,from_location,to_location=nil,distance=nil;
    MeetEventNotice=5,//5//if has the family permission (seeing true location), then it is just a notice;
    MeetEventDeclined=6//6; rejected meeting
};

@interface MeetEvent : NSObject<KCSPersistable>
@property (nonatomic, retain) KCSUser* from_user;
@property (nonatomic, retain) NSString* from_givenName;
@property (nonatomic, retain) NSString* from_surname;
@property (nonatomic, retain) NSString* to_givenName;
@property (nonatomic, retain) NSString* to_surname;
@property (nonatomic, retain) KCSUser* to_user;
@property (nonatomic, retain) NSNumber* MeetEventStatus;//only when to_user agrees, this meet event is valid;
@property (nonatomic, retain) NSDate* start_time;//time of sending the meet request from from_user;
@property (nonatomic, retain) NSDate* end_time;//time of meeting;or 5 minutes after distance<Meet_meters;
@property (nonatomic, retain) NSArray* from_location;
@property (nonatomic, retain) NSArray* to_location;
@property (nonatomic, retain) NSNumber* distance;//distance between from_location and to_location;
@property (nonatomic, copy) NSString* entityId;
@property (nonatomic, retain) KCSMetadata* metadata; //Kinvey metadata, optional

@end
