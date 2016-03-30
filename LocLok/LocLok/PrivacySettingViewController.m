
//  PrivacySettingViewController.m
//  LocShare
//
//  Created by yxiao on 6/26/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "PrivacySettingViewController.h"

//NSString const * strSunday=@"Sunday";
//NSString const * strMonday=@"Monday";
//NSString const * strTuesday=@"Tuesday";
//NSString const * strWednesday=@"Wednesday";
//NSString const * strThursday=@"Thursday";
//NSString const * strFriday=@"Friday";
//NSString const * strSaturday=@"Saturday";
extern NSString* GotPrivacySettingNotification;

@interface PrivacySettingViewController ()
//@property(nonatomic,retain) NSIndexPath *lastSelectedIndexPath;

@end

@implementation PrivacySettingViewController
@synthesize sharing_switch,stranger_switch,sharing_switch0,labelShare,labelShare0,labelRadius;
//@synthesize radius_text_mile,radius_text_km;
@synthesize radius_slider_mile,radius_slider_km,saveButton;
@synthesize rulesTableView,seperatorView;
@synthesize info1,info2,info3;
@synthesize scrollView,labelAdd1,labelEdit1;
//@synthesize privStore;


static NSString * strShareProtectedYES=@"Enable location function: Yes";
static NSString * strShareProtectedNO=@"Enalble location function: No";
static NSString * strShareTrueYES=@"Share true locations: Yes";
static NSString * strShareTrueNO=@"Share true locations: No";
static NSString * strRadiusEmpty=@"Radius of protected locations: ";
static NSString * strDelete=@"Delete";
static NSString * strDone=@"Done";


static NSString *CellIdentifier1 = @"CellID_PrivacySetting";

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
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor purpleColor]}];
    //self.title=@"LocLok";
    self.navigationItem.title=@"My Privacy";
    
    [self.navigationController setNavigationBarHidden:NO];
    /*saveButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Save"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(savePrivRulesToBackend)
                                           ];
     self.navigationItem.rightBarButtonItem =saveButton;
     */
    //self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Save"
                                              style:UIBarButtonItemStyleDone
                                              target:self
                                              action:@selector(savePrivRulesToBackend1)
                                              ];;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(AdjustPageLength)
     name:GotPrivacySettingNotification
     object:nil
     ];
    
    
    
    //test
    //[privStore saveObject:[PrivSetting initWithDefault] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
    //} withProgressBlock:nil];
    
    //CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    //scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    scrollView=[[UIScrollView alloc] initWithFrame:
        CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-49)
    ];
    //[self.view addSubview:scrollView];
    self.view=scrollView;
    //scrollView.delegate=self;
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    //NSLog(@"%f",scrollView.bounds.origin.y);
    
    //[scrollView setUserInteractionEnabled:YES];
    //[scrollView setMultipleTouchEnabled:YES];
    
    /*
     UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
        initWithTarget:self
        action:@selector(touchRecognizer_scrollView)
    ];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:recognizer];
    */
    
    //share true location ?
    sharing_switch0=[[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+240,self.view.bounds.origin.y+40,0,0)];
    [sharing_switch0 addTarget:self
                       action:@selector(flipSwitch:)
             forControlEvents:UIControlEventValueChanged
     ];
    //[self.scrollView addSubview:sharing_switch0];
    
    labelShare0 = [ [UILabel alloc ]
                  initWithFrame:CGRectMake(self.view.bounds.origin.x+10,self.view.bounds.origin.y+40,200,40)
                  ];
    labelShare0.textAlignment =  NSTextAlignmentLeft;
    labelShare0.textColor = [UIColor blackColor];
    labelShare0.backgroundColor = [UIColor whiteColor];
    labelShare0.font = [UIFont fontWithName:@"Verdana" size:14];
    //[self.scrollView addSubview:labelShare0];
    /*UITapGestureRecognizer *recognizer01 = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(hideKeyboard)
                                          ];
    [recognizer01 setNumberOfTapsRequired:1];
    [recognizer01 setNumberOfTouchesRequired:1];
    [labelShare0 setUserInteractionEnabled:YES];
    [labelShare0 addGestureRecognizer:recognizer01];
    */
    
    labelShare0.text = strShareTrueYES;
    //Info image view;
    info1=[[UIImageView alloc] init];
    info1.image=[UIImage imageNamed:@"Info_light.png"];
    info1.frame=CGRectMake(self.view.bounds.origin.x+190,self.view.bounds.origin.y+45,25,25);
    //[self.scrollView addSubview:info1];
    
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(touchRecognizer_info1)
    ];
    [recognizer1 setNumberOfTapsRequired:1];
    [recognizer1 setNumberOfTouchesRequired:1];
    info1.userInteractionEnabled = YES;
    [info1 addGestureRecognizer:recognizer1];
    
    
    //share protected location ?
    CGRect switchRect=CGRectMake(self.view.bounds.origin.x+260,self.view.bounds.origin.y+80,0,0);
    sharing_switch=[[UISwitch alloc] initWithFrame:switchRect];
    //sharing_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [sharing_switch addTarget:self
                       action:@selector(flipSwitch:)
             forControlEvents:UIControlEventValueChanged
     ];
    [self.scrollView addSubview:sharing_switch];
    
    labelShare = [ [UILabel alloc ]
                  initWithFrame:CGRectMake(self.view.bounds.origin.x+10,self.view.bounds.origin.y+80,220,40)
    ];
    labelShare.textAlignment =  NSTextAlignmentLeft;
    labelShare.textColor = [UIColor blackColor];
    labelShare.backgroundColor = [UIColor whiteColor];
    labelShare.font = [UIFont fontWithName:@"Verdana" size:12];
    [self.scrollView addSubview:labelShare];
    /*UITapGestureRecognizer *recognizer02 = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(hideKeyboard)
                                            ];
    [recognizer02 setNumberOfTapsRequired:1];
    [recognizer02 setNumberOfTouchesRequired:1];
    [labelShare setUserInteractionEnabled:YES];
    [labelShare addGestureRecognizer:recognizer02];
     */
    
    labelShare.text = strShareProtectedYES;
    //Info image view;
    info2=[[UIImageView alloc] init];
    info2.image=[UIImage imageNamed:@"Info_light.png"];
    info2.frame=CGRectMake(self.view.bounds.origin.x+229,self.view.bounds.origin.y+85,15,15);
    [self.scrollView addSubview:info2];
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(touchRecognizer_info2)
    ];
    [recognizer2 setNumberOfTapsRequired:1];
    [recognizer2 setNumberOfTouchesRequired:1];
    info2.userInteractionEnabled = YES;
    [info2 addGestureRecognizer:recognizer2];
    
    
    
    //radius for protected location:
    labelRadius=[ [UILabel alloc ]
                          initWithFrame:CGRectMake(self.view.bounds.origin.x+10,self.view.bounds.origin.y+120,self.view.bounds.size.width-20,40)
    ];
    labelRadius.textAlignment =  NSTextAlignmentLeft;
    labelRadius.textColor = [UIColor blackColor];
    labelRadius.backgroundColor = [UIColor whiteColor];
    labelRadius.font = [UIFont fontWithName:@"Verdana" size:12];
    [self.scrollView addSubview:labelRadius];
    labelRadius.text = strRadiusEmpty;
    /*UITapGestureRecognizer *recognizer03 = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(hideKeyboard)
                                            ];
    [recognizer03 setNumberOfTapsRequired:1];
    [recognizer03 setNumberOfTouchesRequired:1];
    [labelRadius setUserInteractionEnabled:YES];
    [labelRadius addGestureRecognizer:recognizer03];
     */
    
    //Info image view;
    info3=[[UIImageView alloc] init];
    info3.image=[UIImage imageNamed:@"Info_light.png"];
    info3.frame=CGRectMake(self.view.bounds.origin.x+223,self.view.bounds.origin.y+125,15,15);
    [self.scrollView addSubview:info3];
    UITapGestureRecognizer *recognizer3 = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(touchRecognizer_info3)
    ];
    [recognizer3 setNumberOfTapsRequired:1];
    [recognizer3 setNumberOfTouchesRequired:1];
    info3.userInteractionEnabled = YES;
    [info3 addGestureRecognizer:recognizer3];
    
    
    
    /*radius_text_mile=[[UITextField alloc] initWithFrame:
            CGRectMake(self.view.bounds.origin.x+80, self.view.bounds.origin.y+160, 60, 30)
    ];
    radius_text_mile.borderStyle = UITextBorderStyleRoundedRect;
    radius_text_mile.font = [UIFont systemFontOfSize:16];
    radius_text_mile.placeholder = @"mile";
    radius_text_mile.autocorrectionType = UITextAutocorrectionTypeNo;
    radius_text_mile.keyboardType = UIKeyboardTypeDecimalPad;
    radius_text_mile.returnKeyType = UIReturnKeyDone;
    //radius_text_mile.clearButtonMode = UITextFieldViewModeWhileEditing;
    radius_text_mile.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    radius_text_mile.delegate = self;
    [self.scrollView addSubview:radius_text_mile];
    
    radius_text_km=[[UITextField alloc] initWithFrame:
                      CGRectMake(self.view.bounds.origin.x+180, self.view.bounds.origin.y+160, 60, 30)
                      ];
    radius_text_km.borderStyle = UITextBorderStyleRoundedRect;
    radius_text_km.font = [UIFont systemFontOfSize:16];
    radius_text_km.placeholder = @"km";
    radius_text_km.autocorrectionType = UITextAutocorrectionTypeNo;
    radius_text_km.keyboardType = UIKeyboardTypeDecimalPad;
    radius_text_km.returnKeyType = UIReturnKeyDone;
    //radius_text_km.clearButtonMode = UITextFieldViewModeWhileEditing;
    radius_text_km.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    radius_text_km.delegate = self;
    [self.scrollView addSubview:radius_text_km];
    */
    
    
    radius_slider_km=[[UISlider alloc] initWithFrame:
        CGRectMake(self.view.bounds.origin.x+10, self.view.bounds.origin.y+160, self.view.bounds.size.width-20, 30)
    ];
    
    [radius_slider_km addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    //[slider setBackgroundColor:[UIColor clearColor]];
    radius_slider_km.minimumValue = 0.1;
    radius_slider_km.maximumValue = 20.0;
    radius_slider_km.continuous =YES;
    //slider.value = 25.0;
    [scrollView addSubview:radius_slider_km];
    
    
    //Edit rulesTable;
    labelEdit1=[ [UILabel alloc ]
                 initWithFrame:CGRectMake(self.view.bounds.origin.x+10,self.view.bounds.origin.y+200,80,40)
                 ];
    labelEdit1.textAlignment =  NSTextAlignmentLeft;
    labelEdit1.textColor = [UIColor redColor];
    labelEdit1.backgroundColor = [UIColor whiteColor];
    labelEdit1.font = [UIFont fontWithName:@"Verdana" size:18];
    [self.scrollView addSubview:labelEdit1];
    labelEdit1.text = strDelete;
    UITapGestureRecognizer *recognizer_Edit1 = [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(rulesTableEdit)
     ];
     [recognizer_Edit1 setNumberOfTapsRequired:1];
     [recognizer_Edit1 setNumberOfTouchesRequired:1];
     [labelEdit1 setUserInteractionEnabled:YES];
     [labelEdit1 addGestureRecognizer:recognizer_Edit1];
    
    //Add a new row to rulesTable;
    labelAdd1=[ [UILabel alloc ]
                initWithFrame:CGRectMake(self.view.bounds.size.width-100,self.view.bounds.origin.y+200,90,40)
                ];
    labelAdd1.textAlignment =  NSTextAlignmentRight;
    labelAdd1.textColor = [UIColor redColor];
    labelAdd1.backgroundColor = [UIColor whiteColor];
    labelAdd1.font = [UIFont fontWithName:@"Verdana" size:18];
    [self.scrollView addSubview:labelAdd1];
    labelAdd1.text = @"Add";
    UITapGestureRecognizer *recognizer_Add1 = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(rulesTableAdd)
                                                ];
    [recognizer_Add1 setNumberOfTapsRequired:1];
    [recognizer_Add1 setNumberOfTouchesRequired:1];
    [labelAdd1 setUserInteractionEnabled:YES];
    [labelAdd1 addGestureRecognizer:recognizer_Add1];
    
    //a separate line;
    CGRect sepFrame = CGRectMake(0, self.view.bounds.origin.y+199, self.view.bounds.size.width, 1);
    seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
    [self.scrollView addSubview:seperatorView];
    
    
    //rules tableview;
    rulesTableView=[[UITableView alloc ]init];
    
    rulesTableView.dataSource=self;
    rulesTableView.delegate=self;
    //rulesTableView.allowsMultipleSelection=NO;
    [self.scrollView addSubview:rulesTableView];
    
    //load privacy rules from backend;
    AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    if(appDelegate1.privacy==nil){
        [appDelegate1 getPrivRulesFromBackend];
    }
    
    
    
    ////get weekday string, like Sunday, Monday, Tuesday,...
    //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    //[dateFormat setDateFormat:@"EEEE"];
    //NSDate *now = [[NSDate alloc] init];
    //NSString *theDate = [dateFormat stringFromDate:now];
    //NSLog(@"%@",theDate);
    
    ////get weekday number: Sunday=1, Monday=2,...
    //NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    //NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    //int weekday1 = [comps weekday];
    //NSLog(@"%d",weekday1);
    
    
    //NSLog(@"%f",scrollView.bounds.origin.y);
    
    
}

//- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
//{
//    CGPoint touchPoint=[gesture locationInView:scrollView];
//}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//
//    [scrollView endEditing:YES];
//
//
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint pt = [touch locationInView:self.scrollView];
//
//    if(CGRectContainsPoint(info1.frame, pt)){//info1: true locations;
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
//            message:@"Info about true location."
//            delegate:self
//            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//            otherButtonTitles:nil
//        ];
//        [alert show];
//    }
////}
////-(void)touchRecognizer_info2{
//    if(CGRectContainsPoint(info2.frame, pt)){//info1: true locations;
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Info about protected location."
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                              otherButtonTitles:nil
//                              ];
//        [alert show];
//    }
////}
////-(void)touchRecognizer_info3{
//    if(CGRectContainsPoint(info3.frame, pt)){//info1: true locations;
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Info about radius."
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                              otherButtonTitles:nil
//                              ];
//        [alert show];
//    }
////}
//}



//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
-(void)hideKeyboard
{
    [self.view endEditing:YES];
}
-(void)touchRecognizer_info1{
    
    //if(CGRectContainsPoint(info1.frame, pt)){//info1: true locations;
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:@"Info about true location."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    //}
}
-(void)touchRecognizer_info2{
    //if(CGRectContainsPoint(info2.frame, pt)){//info1: true locations;
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Trun On/Off LocLok"
                                  message:@"If you turn this off, neither your true location nor your cloaked location will be shared with anyone. Your true location will not be recoreded either. The meeting function does not work too. Press Save afterward."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
    //}
}
-(void)touchRecognizer_info3{
    //if(CGRectContainsPoint(info3.frame, pt)){//info1: true locations;
    
    //}
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Radius Setting"
                                  message:@"Change the radius of your cloaked area. Press Save afterward."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}


/*
#pragma textField delegate;
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    double r;
    if(textField==radius_text_mile){
        r=[radius_text_mile.text doubleValue];
        radius_text_km.text=[NSString stringWithFormat:@"%.02f",1.6*r];
        labelRadius.text=[[[[strRadiusEmpty stringByAppendingString:radius_text_mile.text] stringByAppendingString:@"mile / "] stringByAppendingString:radius_text_km.text] stringByAppendingString:@"km"];
    }
    if(textField==radius_text_km){
        r=[radius_text_km.text doubleValue];
        radius_text_mile.text=[NSString stringWithFormat:@"%.02f",r/1.6];
        labelRadius.text=[[[[strRadiusEmpty stringByAppendingString:radius_text_mile.text] stringByAppendingString:@"mile / "] stringByAppendingString:radius_text_km.text] stringByAppendingString:@"km"];
    }
    return YES;
}
*/
-(void)sliderAction:(id)sender{
    float r=radius_slider_km.value;
    labelRadius.text=[[[[strRadiusEmpty stringByAppendingString:[NSString stringWithFormat:@"%.01f",r/1.6]] stringByAppendingString:@"mile / "] stringByAppendingString:[NSString stringWithFormat:@"%.01f",r]] stringByAppendingString:@"km"];
}





-(void) viewWillAppear:(BOOL)animated{
    //set the default value of privSetting;
    [self.navigationController setNavigationBarHidden:NO];
    
    //set the values according to privSetting;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //if(appDelegate.privacy==nil){
    //    appDelegate.privacy=[PrivSetting initWithDefault];
    //}
    
    //NSLog(@"%f",scrollView.bounds.origin.y);
    //[scrollView setContentSize:CGSizeMake(
    //    self.view.bounds.size.width,
    //    44*appDelegate.privacy.SharingTime.count+230
    //)];
    
    //set the size of TableView;
    
    //rulesTableView.frame=CGRectMake(10, 240, scrollView.bounds.size.width-20,44*appDelegate.privacy.SharingTime.count);
    //NSLog(@"%@",rulesTableView.frame);
    
    //sharing_switch.on=appDelegate.privacy.SharingSwitch.intValue==1;
    //sharing_switch0.on=appDelegate.privacy.SharingSwitch0.intValue==1;
    //stranger_switch.on=appDelegate.privacy.StrangerVisible.intValue==1;
    //[self flipSwitch:sharing_switch];
    //[self flipSwitch:sharing_switch0];
    labelAdd1.enabled=YES;
    
    
    
    //[scrollView setContentSize:CGSizeMake(
    //    self.view.bounds.size.width,
    //    44*appDelegate1.privacy.SharingTime.count+190
    //)];
    [self AdjustPageLength];
    
    [super viewWillAppear:animated];
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self becomeFirstResponder];
//}
//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)flipSwitch:(id)sender{
    AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    if(sender==sharing_switch){
        switch(sharing_switch.on){
            case YES:
                labelShare.text = strShareProtectedYES;
                break;
            case NO:
                labelShare.text = strShareProtectedNO;
                break;
            default:
                break;
            
        }
    }
    
    if(sender==sharing_switch0){
        switch(sharing_switch0.on){
            case YES:
                labelShare0.text = strShareTrueYES;
                break;
            case NO:
                labelShare0.text = strShareTrueNO;
                //[sharing_switch setOn:NO animated:YES];
                break;
            default:
                break;
                
        }
    }
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.privacy.SharingTime.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if(cell==nil)cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
    
    //cell.textLabel.preferredMaxLayoutWidth = 200;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [[appDelegate.privacy.SharingTime objectAtIndex:indexPath.row] DayInWeek]
    ;
    cell.detailTextLabel.text =[[[[appDelegate.privacy.SharingTime objectAtIndex:indexPath.row] startTime]
        stringByAppendingString:@" ~ "]
        stringByAppendingString:[[appDelegate.privacy.SharingTime objectAtIndex:indexPath.row] endTime]]
    ;
    //cell.detailTextLabel.textColor=[UIColor blackColor] ;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
/*- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    //[rulesTableView setEditing:editing animated:YES];
    
    NSMutableArray* paths = [[NSMutableArray alloc] init];
    
    // fill paths of insertion rows here
    
    if( editing ){
        [rulesTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    }
    else{
        [rulesTableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}
*/

//called by [tableView setEditing];
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //if(someCondtion){
    //    return UITableViewCellEditingStyleInsert;
    //} else {
        return UITableViewCellEditingStyleDelete;
    //}
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
        
        //[tableView deleteRowsAtIndexPaths:indexPath.row
        //                 withRowAnimation:UITableViewRowAnimationFade];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.privacy.SharingTime removeObjectAtIndex:indexPath.row];
        
        [tableView reloadData];
        [self AdjustPageLength];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
*/

#pragma mark - Table view delegate
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
    
    [self hideKeyboard];
    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    //targetCell.accessoryType = UITableViewCellAccessoryCheckmark;
    /*if(self.lastSelectedIndexPath) {
        
        [tableView deselectRowAtIndexPath:self.lastSelectedIndexPath animated:YES];
    }
    
    self.lastSelectedIndexPath = indexPath;
     */
    
    if([targetCell.reuseIdentifier isEqualToString:@"CellID_PrivacySetting" ]){
        //[self performSegueWithIdentifier:@"toRuleSetting" sender:self];
        
        /*TimeSettingVC *timeVC = [[TimeSettingVC alloc] init];
         timeVC.timedelegate = self;
         [[self navigationController] pushViewController:timeVC animated:YES];*/
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        PrivacyRuleSettingVC *ruleVC=[[PrivacyRuleSettingVC alloc] initWithNibName:@"PrivacyRuleSettingVC" bundle:nil];
        ruleVC.detailedText=[[NSMutableArray alloc] init];
        [ruleVC.detailedText addObject:targetCell.textLabel.text];
        [ruleVC.detailedText addObject:[[appDelegate.privacy.SharingTime objectAtIndex:indexPath.row] startTime]];
        [ruleVC.detailedText addObject:[[appDelegate.privacy.SharingTime objectAtIndex:indexPath.row] endTime]];
        
        ruleVC.delegate=self;
        [self.navigationController pushViewController:ruleVC animated:YES];
        //[self presentViewController:ruleVC animated:NO completion:NULL];

    }
    
    //[tableView reloadData];
}

//get rule data from rule setting VC;
-(void) getRuleData:(NSMutableArray*)timeRule{
    NSIndexPath *selectedIndexPath = [rulesTableView indexPathForSelectedRow];
    
    AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    
    TimePeriodPrivacy* time1=[TimePeriodPrivacy alloc];
    time1.DayInWeek=[timeRule objectAtIndex:0];
    time1.startTime=[timeRule objectAtIndex:1];
    time1.endTime=[timeRule objectAtIndex:2];
    if(labelAdd1.enabled==YES){
        //replace the privacy setting of the user;
        [appDelegate1.privacy.SharingTime replaceObjectAtIndex:selectedIndexPath.row withObject:time1];
    }
    else{
        //labelAdd1.enabled=YES;
        [appDelegate1.privacy.SharingTime addObject:time1];
        
        
        selectedIndexPath=[NSIndexPath indexPathForRow:appDelegate1.privacy.SharingTime.count-1 inSection:0];
        [rulesTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //set selected row to be the new row;
        [rulesTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        
    }
    
    //change the table content by the new rules;
    UITableViewCell *targetCell = [rulesTableView cellForRowAtIndexPath:selectedIndexPath];
    
    //targetCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    targetCell.textLabel.text = [[appDelegate1.privacy.SharingTime objectAtIndex:selectedIndexPath.row] DayInWeek]
    ;
    targetCell.detailTextLabel.text =[[[[appDelegate1.privacy.SharingTime objectAtIndex:selectedIndexPath.row] startTime]
                                 stringByAppendingString:@" ~ "]
                                stringByAppendingString:[[appDelegate1.privacy.SharingTime objectAtIndex:selectedIndexPath.row] endTime]]
    ;
    
    //only reload the new row;
    NSArray* rowsToReload = [NSArray arrayWithObjects:selectedIndexPath, nil];
    [rulesTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
/*
-(void) getPrivRulesFromBackend{
    
    
    
    KCSQuery* query1 = [KCSQuery queryOnField:@"owner"
                       withExactMatchForValue:[[KCSUser activeUser] userId]
                        ];
    
    //NSLog(@"%@",privStore);
    
    [privStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil==nil){
            AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
            
            
            if([objectsOrNil count]==0){
                //appDelegate1.privacy=nil;
                [self initPrivSettingWithDefault];
            }else{
                appDelegate1.privacy=objectsOrNil[0];
            
                //type transform of SharingTime;
                for(int i=0;i<appDelegate1.privacy.SharingTime.count;i++){
                    TimePeriodPrivacy *timePriv=[TimePeriodPrivacy alloc];
                    NSArray *tmp=[[appDelegate1.privacy.SharingTime objectAtIndex:i] componentsSeparatedByString:@";"];
                    timePriv.DayInWeek=[tmp objectAtIndex:0];
                    timePriv.startTime=[tmp objectAtIndex:1];
                    timePriv.endTime=[tmp objectAtIndex:2];
                    [appDelegate1.privacy.SharingTime replaceObjectAtIndex:i withObject:timePriv];
                }
            }
            
            self.rulesTableView.frame=CGRectMake(10, 200, scrollView.bounds.size.width-20,44*appDelegate1.privacy.SharingTime.count);
            [self.rulesTableView reloadData];
            
            
            sharing_switch.on=appDelegate1.privacy.SharingSwitch.intValue==1;
            sharing_switch0.on=appDelegate1.privacy.SharingSwitch0.intValue==1;
            stranger_switch.on=appDelegate1.privacy.StrangerVisible.intValue==1;
            [self flipSwitch:sharing_switch];
            [self flipSwitch:sharing_switch0];
            radius_slider_km.value=appDelegate1.privacy.SharingRadius.floatValue;
            [self sliderAction:radius_slider_km];
            
            
            //[scrollView setContentSize:CGSizeMake(
            //    self.view.bounds.size.width,
            //    44*appDelegate1.privacy.SharingTime.count+190
            //)];
            [self AdjustPageLength];
        }
        else{
            NSLog(@"when loading user privacy, error occurred: %@",errorOrNil);
        }
    }withProgressBlock:nil
    ];
    
    
    
}
*/



-(void)savePrivRulesToBackend1{
    AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    appDelegate1.privacy.SharingRadius=[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.01f",radius_slider_km.value] floatValue]*1000];
    
    appDelegate1.privacy.SharingSwitch=sharing_switch.on?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
    
    [appDelegate1 toggleUpdatingLocations];
    
//    if(!sharing_switch.on){//if stop sharing, turn the mode inactive;
//        [appDelegate1.locationManager stopUpdatingLocation];
//        //[appDelegate1.locationManager setOperationMode:appDelegate1.LKmode_inactive];
//    }
//    else{//is sharing;
//        [appDelegate1.locationManager startUpdatingLocation];
//    }
    
    [appDelegate1 savePrivRulesToBackend];
    
}

-(void)AdjustPageLength{
    AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    
    //adjust rulesTable length;
    //rulesTableView.frame=CGRectMake(10, 240, scrollView.bounds.size.width-20,44*appDelegate1.privacy.SharingTime.count);
    
    
    [scrollView setContentSize:CGSizeMake(
            self.view.bounds.size.width,
            44*appDelegate1.privacy.SharingTime.count+230
    )];
    
    
    //radius_slider_km.value=appDelegate1.privacy.SharingRadius.floatValue/1000;
    //[self sliderAction:radius_slider_km];
    self.rulesTableView.frame=CGRectMake(10, 240, scrollView.bounds.size.width-20,44*appDelegate1.privacy.SharingTime.count);
    [self.rulesTableView reloadData];
    
    [sharing_switch setOn:appDelegate1.privacy.SharingSwitch.intValue==1];
    [sharing_switch0 setOn: appDelegate1.privacy.SharingSwitch0.intValue==1];
    [stranger_switch setOn:appDelegate1.privacy.StrangerVisible.intValue==1];
    [self flipSwitch:sharing_switch];
    [self flipSwitch:sharing_switch0];
    radius_slider_km.value=appDelegate1.privacy.SharingRadius.floatValue/1000;
    [self sliderAction:radius_slider_km];
    
    
}

-(void)rulesTableEdit{
    if([labelEdit1.text isEqual:strDelete]){
        [rulesTableView setEditing:YES animated:YES];
        labelEdit1.text=strDone;
    }
    else{
        [rulesTableView setEditing:NO animated:YES];
        labelEdit1.text=strDelete;
    }
}

-(void) rulesTableAdd{
    if(labelAdd1.enabled==YES){
        labelAdd1.enabled=NO;
        
        //AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
        //[appDelegate1.privacy.SharingTime addObject:[TimePeriodPrivacy alloc]];
        

        //NSIndexPath* newIndexPath=[NSIndexPath indexPathForRow:appDelegate1.privacy.SharingTime.count inSection:0];
        //[rulesTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //set selected row to be the new row;
        //[rulesTableView selectRowAtIndexPath:newIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        
        //present the rule-setting VC;
        PrivacyRuleSettingVC *ruleVC=[[PrivacyRuleSettingVC alloc] initWithNibName:@"PrivacyRuleSettingVC" bundle:nil];
        ruleVC.detailedText=[[NSMutableArray alloc] init];
        [ruleVC.detailedText addObject:@"Monday"];
        [ruleVC.detailedText addObject:@"09:00"];
        [ruleVC.detailedText addObject:@"17:00"];
        
        ruleVC.delegate=self;
        [self.navigationController pushViewController:ruleVC animated:YES];
    
    }
    
    
}
@end
