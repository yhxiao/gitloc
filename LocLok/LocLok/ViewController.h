//
//  ViewController.h
//  LocShare
//
//  Created by yxiao on 5/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MaskMapView.h"
#import "AppDelegate.h"
#import "User_Photo.h"
#import "Friendship.h"
#import "LocSeries.h"
#import "MeetEvent.h"
//#import "YXThumbnail.h"
#import "YXThumbnailAnnotation.h"

@interface ViewController : UIViewController<MKMapViewDelegate,//CLLocationManagerDelegate,
        UITableViewDelegate,UITableViewDataSource>{
    IBOutlet MKMapView *mapView;
    //CLLocationManager *locManager;
    
    //UINavigationController *myNavController;
    //int initWindow;
    //MaskMapView *maskView;//rect overlay
    //CLLocationCoordinate2D initLoc;
    //NSMutableArray *initLoc;
    BOOL leftTVOpen,rightTVOpen;
    IBOutlet UITableView *leftTableView;
    IBOutlet UITableView *rightTableView;
    
}

-(IBAction) toggleUpdate;
-(IBAction) leftTVTapped;
-(IBAction) rightTVTapped;
@property (retain) IBOutlet MKMapView *mapView;
//@property (retain) CLLocationManager *locManager;
@property (retain) IBOutlet UITableView *leftTableView;
@property (retain) IBOutlet UITableView *rightTableView;
//@property (retain) MaskMapView *maskView;//rect overlay
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
//@property (nonatomic, retain) NSDate* lastUpdateTime;
//@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) IBOutlet UIButton *showFriends;
@property (nonatomic,strong) NSNumber* countLocationUpdates;
@property (nonatomic,strong) MKPointAnnotation *selfLocAnnotation;//self true location annotation;
@property (nonatomic,strong) YXThumbnailAnnotation *selfLokAnnotation;//self perturbed location annotation;
@property (nonatomic,strong) MKCircle* selfLokOverlay;//self perturbed circle;
@property (nonatomic,strong) NSMutableArray* frdAnnotations;
@property (nonatomic,strong) NSMutableArray* frdRegions;
-(void)loadLeftTV;
-(void) drawFriendsLocations;
- (void)GotSelfTrueLocationUpdate;
- (void)GotSelfPerturbedLocationUpdate;
- (NSUInteger)indexofAnnotation:(NSString*)name at:(CLLocationCoordinate2D)pos in:(NSArray*)mapannotations;
-(void)sendMeetingRequestFromUser:(NSInteger)userInFList;
@end
