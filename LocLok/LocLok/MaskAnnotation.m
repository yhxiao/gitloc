//
//  MaskAnnotation.m
//  LocShare
//
//  Created by yxiao on 6/2/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "MaskAnnotation.h"

@implementation MaskAnnotation
@synthesize title1,title2,coordAnnotation,photo;

-(id)initWithLocation:(CLLocationCoordinate2D)locAnnotation
        withMainTitle:(NSString*)t1
         withSubTitle:(NSString*)t2
            withPhoto:(UIImage*)image
{
    if (self = [super init]) {
        coordAnnotation.longitude=locAnnotation.longitude;
        coordAnnotation.latitude=locAnnotation.latitude;
        title1=t1;
        title2=t2;
        photo=image;
    }
    return self;
}


- (CLLocationCoordinate2D)coordinate
{
    return coordAnnotation;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return title1;
}

// optional
- (NSString *)subtitle
{
    return title2;
}

@end
