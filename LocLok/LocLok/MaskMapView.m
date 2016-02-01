//
//  MaskMapView.m
//  LocShare
//
//  Created by yxiao on 5/29/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "MaskMapView.h"
#import "MaskMap.h"

#import <CoreGraphics/CoreGraphics.h>

#define NUM_COLORS 12

@implementation MaskMapView

// Create a table of possible colors to draw a grid cell with
- (void)initColors
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    colors = malloc(sizeof(CGColorRef) * NUM_COLORS);
    int i = 0;
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    0,      0,     1 }); // 0.95
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    .1,     0,     1 }); // 0.9
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    .3,     0,     1 }); // 0.85
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    .5,    0.2,     1 }); // 0.8
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    .7,    0.2,   1 }); // 0.7
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    .8,     .3,     1 }); // 0.6
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 1,    .8,     .4,     1 }); // 0.5
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ .9,   .9,     .4,     1 }); // 0.4
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ .8,   .9,     .5,   1 }); // 0.3
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ .7,   1,      .6,      1 }); // 0.15
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ .6,   1,      .6,      .8 }); // 0.1
    colors[i++] = CGColorCreate(rgb, (CGFloat[]){ 0.4,   1,      .6, .6 }); // 0.05
    CGColorSpaceRelease(rgb);
}

// Look up a color in the table of colors for a peak ground acceleration
- (CGColorRef)colorForAcceleration:(CGFloat)value
{
    if (value > 0.95) return colors[0];
    if (value > 0.9) return colors[1];
    if (value > 0.85) return colors[2];
    if (value > 0.8) return colors[3];
    if (value > 0.7) return colors[4];
    if (value > 0.6) return colors[5];
    if (value > 0.5) return colors[6];
    if (value > 0.4) return colors[7];
    if (value > 0.3) return colors[8];
    if (value > 0.15) return colors[9];
    if (value > 0.1) return colors[10];
    if (value > 0.05) return colors[11];
    return NULL;
}

- (id)initWithOverlay:(id <MKOverlay>)overlay
{
    if (self = [super initWithOverlay:overlay]) {
        [self initColors];
    }
//    for(int i=0;i<25;i++){
//        printf("%f",overlay.grid[i]);
//    }
    return self;
}

- (void)dealloc
{
    int i;
    for (i = 0; i < NUM_COLORS; i++) {
        CGColorRelease(colors[i]);
    }
    free(colors);
    //[super dealloc];
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{
    MaskMap *maskMap = (MaskMap *)self.overlay;
    

    CLLocationCoordinate2D upperLeft0=CLLocationCoordinate2DMake(maskMap.maskRegion.center.latitude+maskMap.maskRegion.span.latitudeDelta/2,maskMap.maskRegion.center.longitude-maskMap.maskRegion.span.longitudeDelta/2);
    float step_x_degree,step_y_degree;
    step_x_degree=maskMap.maskRegion.span.longitudeDelta/maskMap.nWidth;
    step_y_degree=maskMap.maskRegion.span.latitudeDelta/maskMap.nHeight;
    
    
    for (int y=0;y<maskMap.nHeight;y++) {
        for (int x = 0; x < maskMap.nWidth; x ++) {
            // Convert an upper-left, lower-right latitude and longitude to an MKMapRect
            CLLocationCoordinate2D coord1=
            CLLocationCoordinate2DMake(upperLeft0.latitude - (y * step_y_degree),
                                       upperLeft0.longitude + (x * step_x_degree));
            CLLocationCoordinate2D coord2=
            CLLocationCoordinate2DMake(upperLeft0.latitude - ((y+1) * step_y_degree),
                                       upperLeft0.longitude + ((x+1) * step_x_degree));
            MKMapPoint upperLeft = MKMapPointForCoordinate(coord1);
            MKMapPoint lowerRight = MKMapPointForCoordinate(coord2);
            
            MKMapRect boundary = MKMapRectMake(upperLeft.x,
                                                upperLeft.y,
                                                lowerRight.x - upperLeft.x,
                                                lowerRight.y - upperLeft.y);
            
            
            
            
            float value = [[maskMap.grid objectAtIndex:y*maskMap.nWidth+x] floatValue];
            CGColorRef color = [self colorForAcceleration:value];
            if (color) {
                CGContextSetAlpha(ctx, 0.4);
                CGContextSetFillColorWithColor(ctx, color);
                
                // Convert the MKMapRect (absolute points on the map proportional to screen points) to
                // a CGRect (points relative to the origin of this view) that can be drawn.
                CGRect boundaryCGRect = [self rectForMapRect:boundary];
                CGContextFillRect(ctx, boundaryCGRect);
                CGContextSetAlpha(ctx, 0.9);
                
                CGContextSetStrokeColorWithColor(ctx,color);
                CGContextStrokeRectWithWidth(ctx, boundaryCGRect,maskMap.maskRegion.span.latitudeDelta*1000);
            }
            
        }
    }
    
    
}

@end
