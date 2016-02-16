//
//  QueryAnswerViewController.h
//  LocShare
//
//  Created by yxiao on 6/25/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import "LocSeries.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
@interface QueryAnswerViewController : UIViewController<MKMapViewDelegate>{
    IBOutlet MKMapView *mapView;
}

@property NSMutableArray *timeArray;
@property IBOutlet MKMapView *mapView;
@end
