//
//  QueryAnswerViewController.m
//  LocShare
//
//  Created by yxiao on 6/25/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "QueryAnswerViewController.h"
#import <UIKit/UIKit.h>
#import "MaskAnnotation.h"
@interface QueryAnswerViewController ()
@property (nonatomic, retain) id<KCSStore> queryStore;
@property (nonatomic, strong) NSDateFormatter *dateFormatter,*dateLocale;
@property (nonatomic, strong) NSArray* locCollection;
@end

@implementation QueryAnswerViewController
@synthesize timeArray,queryStore,locCollection;
@synthesize mapView;

-(MKMapView *)mapView{//getter
    if(!mapView)mapView=[[MKMapView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    return mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self.navigationItem.backBarButtonItem setAction:@selector(backBtnUserClicked)];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    self.dateLocale = [[NSDateFormatter alloc] init];
    [self.dateLocale setDateStyle:NSDateFormatterShortStyle];
    [self.dateLocale setTimeStyle:NSDateFormatterShortStyle];
    [self.dateLocale setTimeZone:[NSTimeZone localTimeZone]];
    
    
    CGRect mapRect=CGRectMake(self.view.bounds.origin.x,self.view.bounds.origin.y,self.view.bounds.size.width,self.view.bounds.size.height-88);
    self.mapView.frame=mapRect;
    self.mapView.hidden=NO;
    mapView.delegate=self;
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
    [self.view addSubview:self.mapView];
    
    
    
    
    
    
    
    queryStore=[KCSAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"LocSeries",KCSStoreKeyCollectionTemplateClass : [LocSeries class],
        KCSStoreKeyCachePolicy : @(KCSCachePolicyNone)
                 }];
    
    /*ask all the locSeries between start_time and end_time*/
    KCSQuery* query = [KCSQuery queryOnField:@"userDate" usingConditionalsForValues:kKCSGreaterThan, [self.dateFormatter dateFromString:[timeArray objectAtIndex:0]], kKCSLessThan, [self.dateFormatter dateFromString:[timeArray objectAtIndex:1]], nil];
    
    [query addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    [queryStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (errorOrNil == nil && objectsOrNil != nil) {
            //load is successful!
            locCollection=objectsOrNil;
            //do something here
            [self showRealTrajectory];
            
        } else {
            //load failed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load failed"
                                                            message:[errorOrNil localizedDescription]
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
        
    } withProgressBlock:nil];
    
    
}

-(void) showRealTrajectory{
    
    [mapView removeAnnotations:mapView.annotations];
    for(int i=0;i<locCollection.count;i++){
        LocSeries* result=[locCollection objectAtIndex:i];
        //declare location2D;
        CLLocation *loc2D=[CLLocation locationFromKinveyValue:result.location];
        
        //add Annotation
        MaskAnnotation *maskAnnotation=[[MaskAnnotation alloc]
                                        initWithLocation:loc2D.coordinate
                                        withMainTitle:[self.dateLocale
                                                       stringFromDate:result.userDate
                                                       ]
                                        withSubTitle:[KCSUser activeUser].email
                                        withPhoto:nil
                                    ];
        [self.mapView addAnnotation:maskAnnotation];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)backBtnUserClicked{
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"wait" message:@"message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//                       
//                       
//                       
//                    
//    [av show];
//    [self performSegueWithIdentifier:@"toMain" sender:self];
//}

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

@end