//
//  MaskAnnotation.h
//  LocShare
//
//  Created by yxiao on 6/2/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MaskAnnotation : NSObject <MKAnnotation>{
    NSString *title1,*title2;
    CLLocationCoordinate2D coordAnnotation;
    
}
    
@property (retain) NSString* title1,*title2;
@property  CLLocationCoordinate2D coordAnnotation;
@property (nonatomic, retain) UIImage* photo;//******for image
-(id)initWithLocation:(CLLocationCoordinate2D)locAnnotation
        withMainTitle:(NSString*)t1
         withSubTitle:(NSString*)t2
            withPhoto:(UIImage*)image;
@end
