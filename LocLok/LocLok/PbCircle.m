//
//  PbCircle.m
//  LocLok
//
//  Created by yxiao on 2/4/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import "PbCircle.h"

@implementation PbCircle

-(id)initWithCenter:(CLLocationCoordinate2D)coord
             radius:(CLLocationDistance)R{
    
    
    return (PbCircle*)[MKCircle circleWithCenterCoordinate:coord radius:R];

}

@end
