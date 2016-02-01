//
//  MaskMap.h
//  LocShare
//
//  Created by yxiao on 5/29/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MaskMap : NSObject <MKOverlay> {
    MKCoordinateRegion maskRegion; // center and span;
    
    int nWidth;  // # of cells on x
    int nHeight; // # of cells on y
    
    NSMutableArray *grid; // actual 2-D matrix of probabilities;
}

//initialize with probability;
- (id)initWithLocation:(MKCoordinateRegion )maskRgn
              x_degree:(int)x
              y_degree:(int)y
           probability:(float**)matrixVal;

- (MKMapRect)boundingMapRect;//protocol
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;//protocal getter;


@property MKCoordinateRegion maskRegion;
@property int nWidth,nHeight;
@property NSMutableArray* grid;

@end