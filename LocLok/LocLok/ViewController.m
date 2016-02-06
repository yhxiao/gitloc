//
//  ViewController.m
//  LocShare
//
//  Created by yxiao on 5/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MKGeometry.h>
#import "MaskMapView.h"
#import "MaskAnnotation.h"
#import "LocSeries.h"
#import <KinveyKit/KinveyKit.h>
//#import <FacebookSDK/FacebookSDK.h>

extern NSString*  GotSelfPerturbedLocationNotification;//perturbed location updates from self;
extern NSString *  GotSelfTrueLocationNotification;//true location of self;
extern NSString * fListLoadingCompleteNotification;
extern NSString*  realtimelocationUpdateNotification;//locatioin updates from friends;
extern NSString *LocalImagePlist;

@interface ViewController ()
//@property (nonatomic, retain) id<KCSStore> updateStore;
@end

@implementation ViewController
@synthesize mapView,navigationBar;//,locManager;
//@synthesize maskView;//rect overlay
//@synthesize lastUpdateTime;//,dateFormatter;
@synthesize leftTableView,rightTableView;
@synthesize showFriends,countLocationUpdates,selfLocAnnotation,selfLokAnnotation,frdAnnotations,frdRegions;


//@synthesize myNavController;
#define MAP_BUTTON_TITLE @"Update"

-(MKMapView *)mapView{//getter
    if(!mapView)mapView=[[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    return mapView;
}
//-(CLLocationManager*)locManager{//getter
//    if(!locManager)locManager=[[CLLocationManager alloc] init];
//    return locManager;
//}

-(void)logoutButtonWasPressed:(id)sender {
    
    //FBSDK 3.x below
    //[FBSession.activeSession closeAndClearTokenInformation];
    
    [[[FBSDKLoginManager alloc] init] logOut];
    
    /****************for_test****************/
    /*[KCSUser clearSavedCredentials];
    [[KCSUser activeUser] removeWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            NSLog(@"error %@ when deleting active user", errorOrNil);
        } else {
            NSLog(@"active user deleted");
        }
    }];
    */
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:0.4];
    UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    /*If not logged in, modally present login page*/
    //if ([KCSUser hasSavedCredentials] == NO){
    if(![KCSUser activeUser]){
        LoginViewController* loginVC = [[LoginViewController alloc]
                                        initWithNibName:@"LoginViewController" bundle:nil];
        //LoginViewController* loginVC =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        //LoginViewController* loginVC=[[LoginViewController alloc] init];
        //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        //[self presentViewController:navigationController animated:NO completion: nil];
        
        
        loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
        //[self.window makeKeyAndVisible];
        [self presentViewController:loginVC animated:NO completion:nil];
        
    }
    
    
    
    
    
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Start"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(toggleUpdate)];
    
    
    
    //lastUpdateTime=[NSDate date];
    //dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    //Kinvey use code: create a new collection with a linked data store
    // no KCSStoreKeyOfflineSaveDelegate is specified
    /*KCSCollection* collection = [KCSCollection collectionFromString:@"LocSeries" ofClass:[LocSeries class]];
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                          KCSStoreKeyResource : collection,
                                       KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth),
                       KCSStoreKeyUniqueOfflineSaveIdentifier : @"" ,
                               KCSStoreKeyOfflineSaveDelegate : self
                        }];*/
    //updateStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LocSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class]
    //             }];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
    CGRect mapRect=CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y+20,self.view.bounds.size.width,self.view.bounds.size.height-69);
    self.mapView.frame=mapRect;
    self.mapView.hidden=NO;
    mapView.delegate=self;
    self.mapView.showsUserLocation=YES;
    
    
    //initial map; init locManager
    //initWindow=0;
    //self.locManager=[[CLLocationManager alloc] init];
    //self.locManager.delegate = self;
    
    
    /*When requesting high-accuracy location data, the initial event delivered by the location service may not have the accuracy you requested. The location service delivers the initial event as quickly as possible. It then continues to determine the location with the accuracy you requested and delivers additional events, as necessary, when that data is available.
     used only in conjunction with the standard location services and is not used when monitoring significant location changes.
     */
    //self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    /*The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
     used only in conjunction with the standard location services and is not used when monitoring significant location changes.
     */
    
    
    
    //self.locManager.distanceFilter=kCLDistanceFilterNone;
    //self.locManager.distanceFilter=500;
    //[self.locManager startUpdatingLocation];
    
    
    
    
    
    
    [self.view addSubview:self.mapView];
    //initWindow=1;
    
    
    self.leftTableView=[[UITableView alloc] init];
    //add friend list here;
    self.leftTableView=[[UITableView alloc] init];
    self.leftTableView.hidden=NO;
    self.leftTableView.frame=CGRectMake(-160, 20, 160, self.view.bounds.size.height);
    //self.notifTable.style=UITableViewStylePlain;
    [self.view addSubview:self.leftTableView ];
    //self.resultTable.=bgColor;
    self.leftTableView.delegate=self;
    self.leftTableView.dataSource=self;
    
    //friends table;
    self.showFriends = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showFriends.frame = CGRectMake(10, 10+44+20, 70, 22);
    [self.showFriends setTitle:@"Friends" forState:UIControlStateNormal];
    self.showFriends.backgroundColor = bgColor4;
    [self.showFriends setTitleColor:bgColor2 forState:UIControlStateNormal ];
    self.showFriends.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    self.showFriends.clipsToBounds = YES;
    self.showFriends.layer.cornerRadius = 4;//half of the width
    self.showFriends.layer.borderColor=[UIColor blackColor].CGColor;
    self.showFriends.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.showFriends addTarget:self action:@selector(leftTVTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.showFriends];
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    selfLocAnnotation=[[MKPointAnnotation alloc] init];
    
    
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(loadLeftTV)
     name:fListLoadingCompleteNotification
     object:nil
     ];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(toggleUpdate)
     name:fListLoadingCompleteNotification
     object:nil
     ];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(GotSelfPerturbedLocationUpdate)
     name:GotSelfPerturbedLocationNotification
     object:nil
     ];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(GotSelfTrueLocationUpdate)
     name:GotSelfTrueLocationNotification
     object:nil
     ];
    
    
    countLocationUpdates=[NSNumber numberWithInt:0];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(drawFriendsLocations)
     name:realtimelocationUpdateNotification
     object:nil
     ];
    
    
    
}
-(void)GotSelfTrueLocationUpdate{//show true location;
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //selfLocAnnotation.coordinate=appDelegate.latestTrueLocation.coordinate;
}
- (void)GotSelfPerturbedLocationUpdate {
    
    //NSLog(@"received location updating");
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CLLocation *location = appDelegate.latestPerturbedLocation;
    //NSTimeInterval howRecent = [[dateFormatter dateFromString:[dateFormatter stringFromDate:location.timestamp]
    //                             ] timeIntervalSinceDate:lastUpdateTime
    //                            ];
    //NSLog(@"how recent of current location update: %f",howRecent);
    //lastUpdateTime=[NSDate date];
    
    /*
    if(howRecent>10 || howRecent<-10){
        [self.locManager startUpdatingLocation];
    }
    else
        [self.locManager stopUpdatingLocation];
    */
    
    
    BOOL isInBackground = NO;
    //if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    //{
    //    isInBackground = YES;
    //}
    
    /*foreground mode*/
    if(!isInBackground){
            //probability data
            int x=5,y=6;
            float prob_data[6][5];
            float *matrixVal[5];
            //matrixVal=malloc(sizeof(float)*25);
            for(int i=0;i<x;i++){
                for(int j=0;j<y;j++){
                    //matrix[i]=0.04;
                    prob_data[i][j]=0.039*(x*i+j);
                }
                matrixVal[i]=&prob_data[i];
            }
        
            //generate maskView
            /*//rect overlay
            MKCoordinateRegion maskRgn=MKCoordinateRegionMakeWithDistance(location.coordinate, 5000, 5000);
            MaskMap *mask=[[MaskMap alloc] initWithLocation:maskRgn
                                                   x_degree:x
                                                   y_degree:y
                                                probability:matrixVal];
            if(maskView!=nil){
                [mapView removeOverlays: mapView.overlays];
                maskView=nil;
            }
            //add maskView;
            [self.mapView addOverlay:mask];
             */
            
            //add Annotation
            //[mapView removeAnnotations:mapView.annotations];
//            MaskAnnotation *maskAnnotation=[[MaskAnnotation alloc]
//                                            initWithLocation:location.coordinate
//                                            withMainTitle:[KCSUser activeUser].username
//                                            withSubTitle:[KCSUser activeUser].email
//                                            withPhoto:[CommonFunctions loadImageFromLocal:[[KCSUser activeUser] userId]]];
//            [self.mapView addAnnotation:maskAnnotation];
        
            //empire.image = [UIImage imageNamed:@"profile_default.png"];//[CommonFunctions loadImageFromLocal:[[KCSUser activeUser] userId]];
        
            //self.mapView.region=MKCoordinateRegionMakeWithDistance(location.coordinate, 10000, 10000);;
        
            dispatch_async( dispatch_get_main_queue(), ^{
                //move the annotation of self-location;
                selfLokAnnotation.thumbnail.subtitle =[appDelegate.yearToSecondFormatter stringFromDate:location.timestamp];
                selfLokAnnotation.thumbnail.coordinate=location.coordinate;
                //[selfLokAnnotation.thumbnail setCoordinate:location.coordinate];
                [selfLokAnnotation updateThumbnail:selfLokAnnotation.thumbnail animated:YES];
                [selfLokAnnotation setCoordinate:selfLokAnnotation.thumbnail.coordinate];
            });
        
        
            
            
            
    }
    
    
    
}


-(IBAction)toggleUpdate{//should update friends' locations;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.fList  updateLocations];
    
    [mapView removeAnnotations:mapView.annotations];
    frdAnnotations=nil;
    [mapView removeOverlays:mapView.overlays];
    frdRegions=nil;
    
    
}


-(IBAction) rightTVTapped{
    
}

/*//rect overlay
- (MKOverlayView *)mapView:(MKMapView *)mapView1 viewForOverlay:(id <MKOverlay>)overlay
{
    maskView=[[MaskMapView alloc] initWithOverlay:overlay];
    return maskView;
}
*/
- (MKAnnotationView *)mapView:(MKMapView *)mapView1 viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(YXThumbnailAnnotationProtocol)]) {
        return [((NSObject<YXThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView1];
    }
//    if ([annotation isKindOfClass:[MKPointAnnotation class]])
//    {
//        // Try to dequeue an existing pin view first.
//        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
//        if (!pinView)
//        {
//            // If an existing pin view was not available, create one.
//            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
//            //pinView.animatesDrop = NO;
//            pinView.canShowCallout = NO;
//            pinView.image = [UIImage imageNamed:@"five_star_small.png"];
//        } else {
//            pinView.annotation = annotation;
//        }
//        
//        return pinView;
//    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView1 didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(YXThumbnailAnnotationViewProtocol)]) {
        [((NSObject<YXThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView1];
    }
}
- (void)mapView:(MKMapView *)mapView1 didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(YXThumbnailAnnotationViewProtocol)]) {
        [((NSObject<YXThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView1];
    }
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:MKCircle.class]) {
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.strokeColor = [UIColor blueColor];
        circleView.alpha=0.1;
        circleView.fillColor=[UIColor blueColor];
        circleView.lineWidth=2.0;
        return circleView;
    }
    
    return nil;
}



/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
    if (pinView == nil)
    {
        // if an existing pin view was not available, create one
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:annotation.title];
        customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.canShowCallout = YES;
        customPinView.image=[UIImage imageNamed:@"profile_default.png"];
        
        // add a detail disclosure button to the callout which will open a new view controller page
        //
        // note: when the detail disclosure button is tapped, we respond to it via:
        //       calloutAccessoryControlTapped delegate method
        //
        // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
        //
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        customPinView.rightCalloutAccessoryView = rightButton;
        
        return customPinView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}
*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    //sign up;
    //    if (CGRectContainsPoint([self.signupLabel frame], [touch locationInView:self.view]))
    //    {
    //        [self createAccount];
    //    }
    //NSLog(@"%f",self.leftTableView.frame.origin.x);
    if(!CGRectContainsPoint([self.leftTableView frame], [touch locationInView:self.mapView]) && self.leftTableView.frame.origin.x==0){
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             CGRect frame = self.leftTableView.frame;
                             frame.origin.x=-160;//makeAnimation
                             self.leftTableView.frame=frame;
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }
    
    
    
    
}





-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    //    if ([animationID isEqualToString:@"slideMenu"]){
    //        UIView *sq = (UIView *) context;
    //        [sq removeFromSuperview];
    //        [sq release];
    //    }
}

-(IBAction) leftTVTapped{
    
//    CGRect frame = self.leftTableView.frame;
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector( animationDidStop:finished:context: )];
//    //[UIView beginAnimations:@"slideMenu" context:self.mapView];
//    
//    if(leftTVOpen) {
//        frame.origin.x = -160;
//        leftTVOpen = NO;
//    }
//    else
//    {
//        frame.origin.x = 0;
//        leftTVOpen = YES;
//    }
//    
//    self.leftTableView.frame = frame;
//    [UIView commitAnimations];
//    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect frame = self.leftTableView.frame;
                         frame.origin.x=0;//makeAnimation
                         self.leftTableView.frame=frame;
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
    
}
-(void)loadLeftTV{
    [self.leftTableView reloadData];
    
    //update realtime locations of friends;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.fList updateLocations];
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //[self loadLeftTV];
    
    //[FriendList checkNewFriend ];
    /*appDelegate.fList=[[FriendList alloc] loadWithID:[[KCSUser activeUser] userId ]];
    */
    
    /*retrive initLoc from plist;*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"BasicData.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"BasicData" ofType:@"plist"];
        //NSLog(@"BasicData does not exist");
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSError *errorDesc =[NSError alloc];
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    
    CLLocationCoordinate2D startLoc;
    startLoc.latitude=[[[temp objectForKey:@"lastLoc"] objectAtIndex:0] doubleValue];
    startLoc.longitude=[[[temp objectForKey:@"lastLoc"] objectAtIndex:1] doubleValue];
    MKCoordinateSpan startSpan;
    startSpan.latitudeDelta=[[[temp objectForKey:@"spanDelta"] objectAtIndex:0] doubleValue];
    startSpan.longitudeDelta=[[[temp objectForKey:@"spanDelta"] objectAtIndex:1] doubleValue];
    
    MKCoordinateRegion initRegion=MKCoordinateRegionMake(startLoc,startSpan);
    self.mapView.region=initRegion;
    
    
    
    
    
    
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    //if(appDelegate.fList==nil && [KCSUser activeUser]!=nil){
        appDelegate.fList=[[FriendList alloc] loadWithID:[[KCSUser activeUser] userId ]];
    //[appDelegate.locManager startUpdatingLocation];
    
    //Also update friends' locations;
    //[self toggleUpdate];
    
    //}
    //if(appDelegate.privacy==nil){
    //    [appDelegate getPrivRulesFromBackend];
    //}
    
    
    //update the latest updated location;
    /*[[NSNotificationCenter defaultCenter]
     postNotificationName:GotSelfLocationUpdateNotification
     object:nil
     ];
     */
    //NSLog(@"Info: %@ ,%@",appDelegate.latestUpdatedLocation,appDelegate.activeLocationUntilWhen);
    
}

-(void)viewWillDisappear:(BOOL)animated{
    //[self.navigationController setNavigationBarHidden:YES];
    
    [super viewWillDisappear:animated];
    
    
    /*save initLoc to plist;*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"BasicData.plist"];
    
    CLLocationCoordinate2D endLoc;
    endLoc=mapView.region.center;
    MKCoordinateSpan endSpan=mapView.region.span;
    
    NSMutableArray *lastLoc,*spanDelta;
    lastLoc=[NSMutableArray arrayWithObjects:[[NSNumber alloc] initWithDouble:endLoc.latitude],[[NSNumber alloc] initWithDouble:endLoc.longitude],nil];
    spanDelta=[NSMutableArray arrayWithObjects:[[NSNumber alloc] initWithDouble:endSpan.latitudeDelta],[[NSNumber alloc] initWithDouble:endSpan.longitudeDelta], nil];
    
    // create dictionary with values in UITextFields
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: lastLoc, spanDelta, nil] forKeys:[NSArray arrayWithObjects: @"lastLoc", @"spanDelta", nil]];
    
    NSError *error = [NSError alloc];
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:0
                                                                    error:&error
                         ];
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
    }
}

-(void)drawFriendsLocations{//after receiving location updates, draw friends' locations on map;
    if([countLocationUpdates intValue]==0){
        countLocationUpdates=[NSNumber numberWithInt:1];
        return;
    }
    else{
        countLocationUpdates=[NSNumber numberWithInt:0];
    }
    
    
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    if(frdAnnotations==nil && frdRegions==nil){
        frdAnnotations=[[NSMutableArray alloc] init];
        frdRegions=[[NSMutableArray alloc] init];
        for(int i=0;i<appDelegate.fList.friends.count;i++){
            YXThumbnail *annotation1=[[YXThumbnail alloc] init];
            Friendship *aFriend=[appDelegate.fList.friends objectAtIndex:i];
            annotation1.title = [[[[aFriend.to_user givenName]
                                   stringByAppendingString:@" "]
                                  stringByAppendingString:[aFriend.to_user surname]]
                                 stringByAppendingString:@""
                                 ];
            
            UIImage* profileImg=[CommonFunctions loadImageFromLocal:[aFriend.to_user userId]];
            annotation1.image= (profileImg==nil?[UIImage imageNamed:@"profile_default.png"]:profileImg);
            annotation1.disclosureBlock = ^{ NSLog(@"selected Empire"); };
            //annotation1.subtitle=nil;
            //annotation1.coordinate=appDelegate.latestPerturbedLocation.coordinate;
            
            [frdAnnotations addObject:[YXThumbnailAnnotation annotationWithThumbnail:annotation1]];
        }
        for(int i=0;i<appDelegate.fList.friends.count;i++){
            LocSeries* frdLoc=[appDelegate.fList.frdLocations objectAtIndex:i];
            if(frdLoc!=nil && ![frdLoc isKindOfClass:[NSNull class]]){
                YXThumbnailAnnotation* frd1=[frdAnnotations objectAtIndex:i];
                frd1.thumbnail.subtitle=[appDelegate.yearToSecondFormatter stringFromDate: frdLoc.userDate];
                frd1.thumbnail.coordinate=[CLLocation locationFromKinveyValue:frdLoc.location].coordinate;
                [frd1 updateThumbnail:frd1.thumbnail animated:YES];
                //[frd1 setCoordinate:frd1.thumbnail.coordinate];
                
                //NSLog(@"%f",[frdLoc.precision doubleValue]);
                [frdRegions addObject:[MKCircle circleWithCenterCoordinate:[CLLocation locationFromKinveyValue:frdLoc.location].coordinate radius:[frdLoc.precision doubleValue]*1000]];
            }
            
        }
        [self.mapView addAnnotations:frdAnnotations];
        [self.mapView addOverlays:frdRegions];
        
        
        
        //add self annotation;
        YXThumbnail* selfLocAnnotation1 = [[YXThumbnail alloc] init];
        selfLocAnnotation1.image =[CommonFunctions loadImageFromLocal:[[KCSUser activeUser] userId]];
        selfLocAnnotation1.title = [[[[KCSUser activeUser] givenName] stringByAppendingString:@" "]
                                    stringByAppendingString:[[KCSUser activeUser] surname] ];
        selfLocAnnotation1.subtitle = [appDelegate.yearToSecondFormatter stringFromDate:appDelegate.latestPerturbedLocation.timestamp ];
        selfLocAnnotation1.coordinate = appDelegate.latestPerturbedLocation.coordinate;
        selfLocAnnotation1.disclosureBlock = ^{ NSLog(@"selected Self location"); };
        selfLokAnnotation=[YXThumbnailAnnotation annotationWithThumbnail:selfLocAnnotation1];
        //if(![self.mapView.annotations containsObject:selfLokAnnotation]){
            [self.mapView addAnnotation:selfLokAnnotation];
            //NSLog(@"%f",[appDelegate.privacy.SharingRadius doubleValue]);
            [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:appDelegate.latestPerturbedLocation.coordinate
                                                               radius:[appDelegate.privacy.SharingRadius doubleValue]*1000]];
        
        //}
        //selfLocAnnotation.coordinate=appDelegate.latestTrueLocation.coordinate;
        //[self.mapView addAnnotation:selfLocAnnotation];
    }else{
    //start to draw locations;
    //dispatch_async( dispatch_get_main_queue(), ^{

        for(int i=0;i<appDelegate.fList.friends.count;i++){
            LocSeries* frdLoc=[appDelegate.fList.frdLocations objectAtIndex:i];
            if(frdLoc!=nil && ![frdLoc isKindOfClass:[NSNull class]]){
                YXThumbnailAnnotation* frd1=[frdAnnotations objectAtIndex:i];
                frd1.thumbnail.subtitle=[appDelegate.yearToSecondFormatter stringFromDate: frdLoc.userDate];
                frd1.thumbnail.coordinate=[CLLocation locationFromKinveyValue:frdLoc.location].coordinate;
                [frd1 updateThumbnail:frd1.thumbnail animated:YES];
                [frd1 setCoordinate:frd1.thumbnail.coordinate];
                /* change the location of MKCircle, not sure if this works
                 http://stackoverflow.com/questions/4759317/moving-mkcircle-in-mkmapview
                 */
                MKCircle *cir=[frdRegions objectAtIndex:i];
                [cir setCoordinate:frd1.thumbnail.coordinate];
            }
            
        }
        //[mapView showAnnotations:frdAnnotations animated:YES];
    //});
    }
}





#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//From me and to me;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	if(section==0){
        return appDelegate.fList.friends.count;
    }
    else{
        return 0;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"";
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mainTableViewCell";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //__block NSString* userName1=[NSString alloc ];
    //the text
    if(indexPath.section==0){//toCollection;
        
        Friendship *aFriend=[appDelegate.fList.friends objectAtIndex:indexPath.row];
        //cell.textLabel.text =[(NSDictionary*)aFriend.to_user objectForKey:@"_id"];
        cell.textLabel.text = [[[[aFriend.to_user givenName]
                                 stringByAppendingString:@" "]
                                stringByAppendingString:[aFriend.to_user surname]]
                               stringByAppendingString:@""
                               ];
        
        //NSLog(@"",[(NSDictionary*)aFriend.to_user objectForKey:@"_id"]);
        
        
        /*Loading the details below*/
//            cell.textLabel.text = [[[aFriend.to_user givenName]
//                                     stringByAppendingString:@" "]
//                                    stringByAppendingString:[aFriend.to_user surname]
//                                   ];
//        
//            cell.detailTextLabel.text = [aFriend.to_user username];
//            
//            NSString* userName1=[[NSString alloc ]  initWithString:[aFriend.to_user username]];
//            
//            
//            //NSLog(@"%@",[[[self.searchResult objectAtIndex:indexPath.row] username] lowercaseString]);
//            KCSQuery* pngQuery = [KCSQuery queryOnField:KCSFileFileName withExactMatchForValue:
//                                  [userName1 stringByAppendingString:@".png"]
//                                  ];
//            
//            //[self.activityIndicator startAnimating];
//            [KCSFileStore downloadFileByQuery:pngQuery completionBlock:^(NSArray *downloadedResources, NSError *error) {
//                if (error == nil && downloadedResources.count>0) {
//                    //if(downloadedResources.count>0){
//                    //profileImage=[UIImage imageWithData:[downloadedResources objectAtIndex:0].data];
//                    //profileURL=[[downloadedResources objectAtIndex:0] remoteURL];
//                    KCSFile* file = [downloadedResources objectAtIndex:0];
//                    NSURL* fileURL = file.localURL;
//                    UIImage* image1 = [UIImage imageWithContentsOfFile:[fileURL path]]; //note this blocks for awhile
//                    
//                    //placeholder image while loading;
//                    [cell.imageView  setImage:[UIImage imageNamed:@"profile_default.png"]];
//                    
//                    //Get the main thread to update the UI
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [cell.imageView  setImage:image1];
//                        
//                    });
//                    
//                    
//                } else {
//                    NSLog(@"Got an error: %@", error);
//                }
//            } progressBlock:nil
//             ];
        
        
        
        
    
	
    
    
    
    //The icon on the right side of a row;
	//cell.accessoryType = UITableViewCellAccessoryNone;
    UIImage *image =  [UIImage imageNamed:@"icon_cell_add60.png"] ;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
    
    
    
    /*id<KCSStore> PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName : @"UserPhotos", KCSStoreKeyCollectionTemplateClass : [User_Photo class]}];
    
    //should first query if KCSUser exists; if yes, then store the image to it; otherwise, create a new record and store;
    KCSQuery* query = [KCSQuery queryOnField:@"user_id._id"
                      withExactMatchForValue:[[KCSUser activeUser] userId]
                       ];
    
    __block User_Photo * uPhoto=[[User_Photo alloc] init];
    [PhotoStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (objectsOrNil != nil && [objectsOrNil count]>0) {
            uPhoto=objectsOrNil[0];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //The profile image on the left;
            [cell.imageView  setImage:[UIImage imageNamed:@"profile_default.png"]];
            //[cell.imageView  setImage:uPhoto.photo];
            [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
        });
    }withProgressBlock:nil
     ];
    */
    
    //KCSQuery* pngQuery = [KCSQuery queryOnField:KCSFileFileName
                      //withExactMatchForValue:[[[KCSUser activeUser] username] stringByAppendingString:@".png"]
                       //];
    /*KCSQuery* pngQuery = [KCSQuery query];
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"_kmd.ect" inDirection:kKCSDescending];
    //[pngQuery addSortModifier:sortByDate]; //sort the return by the date field
    //[pngQuery setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    [KCSFileStore downloadFileByQuery:pngQuery completionBlock:^(NSArray *downloadedResources, NSError *error) {
    //[KCSFileStore downloadFile:@"ceb7b96c-569f-476e-8019-f507bc0dcc03" options:nil completionBlock:^(NSArray *downloadedResources, NSError *error) {
    
        if (error == nil) {
            NSLog(@"Downloaded %i images.", downloadedResources.count);
        } else {
            NSLog(@"Got an error: %@", error);
        }
    } progressBlock:nil];
    */
    
        UIImage* profileImg=[CommonFunctions loadImageFromLocal:[aFriend.to_user userId]];
        [cell.imageView  setImage:profileImg==nil?[UIImage imageNamed:@"profile_default.png"]:profileImg];
        //[cell.imageView  setImage:uPhoto.photo];
        [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
    
        //use rounded corner for the image;
        cell.imageView.layer.cornerRadius =4;
        cell.imageView.layer.masksToBounds = YES;
        //cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
        //cell.imageView.layer.borderWidth = 3.0;
    }//section==0

    
    
    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //		NSString *section = [self.sections objectAtIndex:indexPath.section];
        //		NSMutableArray *wordsInSection = [[self.words objectForKey:section] mutableCopy];
        //		[wordsInSection removeObjectAtIndex:indexPath.row];
        //		[self.words setObject:wordsInSection forKey:section];
        //
        //		// Delete the row from the table view
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



/*Decide if the index like "A-Z" appears on the right*/
/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
 {
 return self.sections;
 }*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
    
}


@end
