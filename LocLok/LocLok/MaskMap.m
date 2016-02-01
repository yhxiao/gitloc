//
//  MaskMap.m
//  LocShare
//
//  Created by yxiao on 5/29/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "MaskMap.h"


@implementation MaskMap
@synthesize maskRegion;
@synthesize nWidth,nHeight,grid;

- (id)initWithLocation:(MKCoordinateRegion )maskRgn
              x_degree:(int)m
              y_degree:(int)n
           probability:(float**)matrixVal;
{
    int i,j;
    if (self = [super init]) {
        
        nWidth=m;
        nHeight=n;
        maskRegion=maskRgn;
        //grid=matrixVal;
        
        grid = [NSMutableArray arrayWithCapacity:m*n];
        
        float f1;
        for(i=0;i<m;i++){
            for(j=0;j<n;j++){
                f1=matrixVal[i][j];
                [grid addObject:[[NSNumber alloc] initWithFloat:f1]];
            }
        }
        
        
    }
    return self;
}

- (void)dealloc
{
    
    //[super dealloc];
}

// From MKAnnotation, for areas this should return the centroid of the area.
- (CLLocationCoordinate2D)coordinate
{
    return maskRegion.center;
}

// boundingMapRect should be the smallest rectangle that completely contains the overlay.
- (MKMapRect)boundingMapRect
{
    
//    MKMapPoint upperLeft = MKMapPointForCoordinate(origin);
//    
//    CLLocationCoordinate2D lowerRightCoord =
//    CLLocationCoordinate2DMake(origin.latitude - (gridSize * gridHeight),
//                               origin.longitude + (gridSize * gridWidth));
//    
//    MKMapPoint lowerRight = MKMapPointForCoordinate(lowerRightCoord);
//    
//    double width = lowerRight.x - upperLeft.x;
//    double height = lowerRight.y - upperLeft.y;
//    
//    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, width, height);
//    return bounds;
    
    
    
    CLLocationCoordinate2D upperLeft,lowerRight;
    upperLeft=CLLocationCoordinate2DMake(maskRegion.center.latitude+maskRegion.span.latitudeDelta/2,
                                         maskRegion.center.longitude-maskRegion.span.longitudeDelta/2);
    lowerRight=CLLocationCoordinate2DMake(maskRegion.center.latitude-maskRegion.span.latitudeDelta/2,
                                          maskRegion.center.longitude+maskRegion.span.longitudeDelta/2);
    
    MKMapPoint ul=MKMapPointForCoordinate(upperLeft),lr=MKMapPointForCoordinate(lowerRight);
    MKMapRect bounds=MKMapRectMake(ul.x,ul.y,lr.x-ul.x,lr.y-ul.y);
    return bounds;

}

@end

