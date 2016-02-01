//
//  MaskMapView.h
//  LocShare
//
//  Created by yxiao on 5/29/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//


#import <MapKit/MapKit.h>
#import "MaskMap.h"

@interface MaskMapView : MKOverlayView {
    CGColorRef *colors;
}

@end