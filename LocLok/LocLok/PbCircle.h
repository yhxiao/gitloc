//
//  PbCircle.h
//  LocLok
//
//  Created by yxiao on 2/4/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PbCircle : MKCircle<MKOverlay>

-(id)initWithCenter:(CLLocationCoordinate2D)coord
             radius:(CLLocationDistance)radius;

@end
