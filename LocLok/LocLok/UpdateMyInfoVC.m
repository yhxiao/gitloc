//
//  UpdateMyInfoVC.m
//  LocShare
//
//  Created by yxiao on 12/25/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "UpdateMyInfoVC.h"
extern NSString *const LocalImagePlist;

@interface UpdateMyInfoVC ()

@end

@implementation UpdateMyInfoVC
@synthesize  FirstNameTextField;
@synthesize LastNameTextField;
@synthesize AccountName;
@synthesize welcomeLabel,myAccountLabel,myFirstNameLabel,myLastNameLabel,FBDetailedLabel;
@synthesize actionAlert;
@synthesize doneButton;

//@synthesize Profileimage;
//@synthesize myImageView;
UIImage * Profileimage;
UIImageView *myImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(BOOL)writeToPlist: (NSString *)fileName
//                   : (NSArray*) objInfo
//                   :(NSString *)objName
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    // get documents path
//    NSString *documentsPath = [paths objectAtIndex:0];
//    // get the path to our Data/plist file
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:fileName];
//    
//    
//    // create dictionary with values in UITextFields
//    NSDictionary *plistDict = [NSDictionary
//                               dictionaryWithObject:objInfo
//                               forKey:objName
//                               ];
//    
//    NSError *error = [NSError alloc];
//    // create NSData from dictionary
//    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict
//                                                                   format:NSPropertyListXMLFormat_v1_0
//                                                                  options:0
//                                                                    error:&error
//                         ];
//    // check is plistData exists
//    if(plistData)
//    {
//        // write plistData to our Data.plist file
//        [plistData writeToFile:plistPath atomically:YES];
//    }
//    else
//    {
//        NSLog(@"Error in saveData: %@", error);
//        return NO;
//    }
//    return YES;
//}
//
//-(NSDictionary*)retrieveFromPlist: (NSString *)fileName{
//    /*retrieve userInfo from plist;*/
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//	// get documents path
//	NSString *documentsPath = [paths objectAtIndex:0];
//	// get the path to our Data/plist file
//	NSString *plistPath = [documentsPath stringByAppendingPathComponent:fileName];
//	
//	// check to see if Data.plist exists in documents
//	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
//	{
//		// if not in documents, get property list from main bundle
//		plistPath = [[NSBundle mainBundle] pathForResource:[fileName substringToIndex:[fileName length]-6]
//                                                    ofType:@"plist"];
//        //NSLog(@"BasicData does not exist");
//	}
//	
//	// read property list into memory as an NSData object
//	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
//	NSError *errorDesc =[NSError alloc];
//	NSPropertyListFormat format;
//	// convert static property list into dictionary object
//	NSDictionary* temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
//	if (!temp)
//	{
//		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
//	}
//    
//    return temp;
//    
//}
//- (void)FBStateReceiverSelector:(NSNotification *)notification {
//    
//    /*FBSDK 3.x below
//     
//    FBSession * fb_session=[notification object];
////    if(fb_session.state!=FBSessionStateOpen){
////        //alert
////        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
////                                                        message:@"Syncronization failed. Please try again."
////                                                       delegate:self
////                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
////                                              otherButtonTitles:nil];
////        [alert show];
////    }
//    NSLog(@"%u",fb_session.state);
//    if(fb_session.state==FBSessionStateOpen){
//        //alert
////        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
////                                                        message:@"Syncronization finished. Please reopen this page to check the update."
////                                                       delegate:self
////                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
////                                              otherButtonTitles:nil];
////        [alert show];
//        [self updatePicture];
//       
//     
//        
//    }*/
//    
//}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}
-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSString* fileLoc=[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension];
    //NSLog(@"%@",fileLoc);
    UIImage * result = [UIImage imageWithContentsOfFile:fileLoc];
    
    return result;
}
- (void) hideKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - TextField Stuff

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    
    return YES;
}

//whether it should resign first responder
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 1) {//First name
        [self.LastNameTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self save];
    }
    return YES;
}







- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.navigationController setNavigationBarHidden:NO];
    
	// Do any additional setup after loading the view.
    self.FirstNameTextField.delegate=self;
    self.LastNameTextField.delegate=self;
    
    //make the keyboard go away when tap anywhere instead of the textfiled;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)] ;
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:1];
    UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    //self.view.backgroundColor=bgColor;
    int width,height;
    int initialHeight=60;
    int boxHeight=40;
    width=self.view.bounds.size.width;
    height=self.view.bounds.size.height;
//    CGRect newFrame = self.view.frame;
//    newFrame.size.width = 200;
//    newFrame.size.height = 200;
//    [self.view setFrame:newFrame];
    
    
    
    //labels;
    
    //UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    welcomeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight, width, boxHeight) ];
    welcomeLabel.textAlignment =  UITextAlignmentCenter;
    welcomeLabel.textColor = bgColor;
    //welcomeLabel.backgroundColor = bgColor;
    welcomeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    [self.view addSubview:welcomeLabel];
    welcomeLabel.text = @"My Account Information";
    
    myAccountLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(20, initialHeight+140, 120, boxHeight) ];
    myAccountLabel.textAlignment =  UITextAlignmentLeft;
    myAccountLabel.textColor = [UIColor blackColor];
    //welcomeLabel.backgroundColor = bgColor;
    myAccountLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    [self.view addSubview:myAccountLabel];
    myAccountLabel.text = @"Account Name: ";
    
    
    AccountName= [ [UILabel alloc ] initWithFrame:CGRectMake(130, initialHeight+140, 190, boxHeight) ];
    AccountName.textAlignment =  UITextAlignmentLeft;
    AccountName.textColor = [UIColor blackColor];
    //welcomeLabel.backgroundColor = bgColor;
    AccountName.font = [UIFont fontWithName:@"ArialMT" size:14];
    [self.view addSubview:AccountName];
    //AccountName.text = @"email";
    
    myFirstNameLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(20, initialHeight+170, 120, boxHeight) ];
    myFirstNameLabel.textAlignment =  UITextAlignmentLeft;
    myFirstNameLabel.textColor = [UIColor blackColor];
    //welcomeLabel.backgroundColor = bgColor;
    myFirstNameLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    [self.view addSubview:myFirstNameLabel];
    myFirstNameLabel.text = @"First Name: ";
    
    myAccountLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(20, initialHeight+200, 120, boxHeight) ];
    myAccountLabel.textAlignment =  UITextAlignmentLeft;
    myAccountLabel.textColor = [UIColor blackColor];
    //welcomeLabel.backgroundColor = bgColor;
    myAccountLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    [self.view addSubview:myAccountLabel];
    myAccountLabel.text = @"Last Name: ";
    
    FBDetailedLabel = [ [UITextView alloc ] initWithFrame:CGRectMake(20, initialHeight+340, width-40, boxHeight*2) ];
    FBDetailedLabel.textAlignment =  UITextAlignmentLeft;
    FBDetailedLabel.textColor = [UIColor blackColor];
    //welcomeLabel.backgroundColor = bgColor;
    FBDetailedLabel.font = [UIFont fontWithName:@"ArialMT" size:9];
    [self.view addSubview:FBDetailedLabel];
    FBDetailedLabel.userInteractionEnabled=NO;
    FBDetailedLabel.text = @"If you logged in with Facebook, clicking 'Reset Password' will create a password for the account name. Then you can either log in with Facebook or with the account name to log in. ";
    
    
    
    //text fields;
    
    FirstNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(130, initialHeight+175, 170, boxHeight-10)];
    FirstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    FirstNameTextField.font = [UIFont fontWithName:@"ArialMT" size:12];
    FirstNameTextField.placeholder = @"First Name";
    FirstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    FirstNameTextField.keyboardType = UIKeyboardTypeDefault;
    FirstNameTextField.returnKeyType = UIReturnKeyNext;
    FirstNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    FirstNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    FirstNameTextField.delegate = self;
    [FirstNameTextField setTag:1];
    [self.view addSubview:FirstNameTextField];//setTag
    
    LastNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(130, initialHeight+205, 170, boxHeight-10)];
    LastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    LastNameTextField.font = [UIFont fontWithName:@"ArialMT" size:12];
    LastNameTextField.placeholder = @"Last Name";
    LastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    LastNameTextField.keyboardType = UIKeyboardTypeDefault;
    LastNameTextField.returnKeyType = UIReturnKeyDone;
    LastNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    LastNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    LastNameTextField.delegate = self;
    [LastNameTextField setTag:2];
    [self.view addSubview:LastNameTextField];
    
    
    
    
    //buttons
    
    self.SaveChangesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.SaveChangesButton.frame = CGRectMake(self.view.center.x-80, initialHeight+250, 160, boxHeight-10);
    [self.SaveChangesButton setTitle:@"Save Changes" forState:UIControlStateNormal];
    self.SaveChangesButton.backgroundColor = [UIColor whiteColor];
    [self.SaveChangesButton setTitleColor:bgColor forState:UIControlStateNormal ];
    self.SaveChangesButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    self.SaveChangesButton.clipsToBounds = YES;
    self.SaveChangesButton.layer.cornerRadius = 6;//half of the width
    self.SaveChangesButton.layer.borderColor=bgColor.CGColor;
    self.SaveChangesButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.SaveChangesButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SaveChangesButton];
    
    
    self.ResetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ResetPasswordButton.frame = CGRectMake(self.view.center.x-80, initialHeight+290, 160, boxHeight-10);
    [self.ResetPasswordButton setTitle:@"Reset Password" forState:UIControlStateNormal];
    self.ResetPasswordButton.backgroundColor = [UIColor whiteColor];
    [self.ResetPasswordButton setTitleColor:bgColor forState:UIControlStateNormal ];
    self.ResetPasswordButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    self.ResetPasswordButton.clipsToBounds = YES;
    self.ResetPasswordButton.layer.cornerRadius = 6;//half of the width
    self.ResetPasswordButton.layer.borderColor=bgColor.CGColor;
    self.ResetPasswordButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.ResetPasswordButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.ResetPasswordButton];
    
    
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(width-70, 30, 60, boxHeight-10);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    self.doneButton.backgroundColor = [UIColor whiteColor];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    self.doneButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:14];
    self.doneButton.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = 6;//half of the width
    self.doneButton.layer.borderColor=[UIColor blackColor].CGColor;
    self.doneButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.doneButton addTarget:self action:@selector(dismissThis) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];
    
    
    
    
    
}

-(void)dismissThis{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)updatePicture{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //show the new image;
    //Load Image From Directory
    Profileimage = [self loadImage:[[KCSUser activeUser] userId] ofType:@"png" inDirectory:documentsDirectoryPath];
    if(Profileimage==nil){//MyProfilePicture.jpg does not exist, then load the default profile;
        Profileimage=[UIImage imageNamed:@"profile_default"];
    }
    //self.myImageView = [[UIImageView alloc] init];
    myImageView.image=Profileimage;
    myImageView.frame = CGRectMake(self.view.center.x-40, 110.0, 80.0, 80.0);
    [myImageView setImage:Profileimage];
    
    
    /*retrieve userInfo from plist;*/
    
    NSDictionary *temp = [CommonFunctions retrieveFromPlist:@"UserInfo.plist"];
    
    self.AccountName.text =[[temp objectForKey:@"userInfo"] objectAtIndex:0];
    self.FirstNameTextField.text=[[temp objectForKey:@"userInfo"] objectAtIndex:1];
    self.FirstNameTextField.clearButtonMode=UITextFieldViewModeAlways;
    self.LastNameTextField.text=[[temp objectForKey:@"userInfo"] objectAtIndex:2];
    self.LastNameTextField.clearButtonMode=UITextFieldViewModeAlways;
    

    

}

- (void) viewWillAppear:(BOOL)animated
{
    //[self.navigationController setNavigationBarHidden:NO];
    
    //Definitions
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //Load Image From Directory
    Profileimage = [self loadImage:[[KCSUser activeUser] userId] ofType:@"png" inDirectory:documentsDirectoryPath];
    if(Profileimage==nil){//MyProfilePicture.jpg does not exist, then load the default profile;
        Profileimage=[UIImage imageNamed:@"profile_default"];
    }
    
    
    
    KCSQuery* query = [KCSQuery queryOnField:@"user_id._id"
                      withExactMatchForValue:[[KCSUser activeUser] userId]
                       ];
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
    [query addSortModifier:sortByDate]; //sort the return by the date field
    [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    
    id<KCSStore> PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                         KCSStoreKeyCollectionName : @"UserPhotos",
                                                         KCSStoreKeyCollectionTemplateClass : [User_Photo class],
                                                         KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
                                                         }];
    [PhotoStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //NSLog(@"%@",[aFriend.to_user username]);
        if (objectsOrNil != nil && [objectsOrNil count]>0) {
            User_Photo * uPhoto=objectsOrNil[0];
            
            //get existing image's URL;
            NSDictionary *temp = [CommonFunctions retrieveFromPlist:LocalImagePlist];
            NSString *frdImageURL =[[temp objectForKey:[uPhoto.user_id userId]] objectAtIndex:0];
            
            if(frdImageURL==nil || ![frdImageURL isEqualToString:uPhoto.photoURL]){//new or has update
                //write new photo's URL to UserInfo.plist;
                [CommonFunctions writeToPlist:LocalImagePlist
                                             :[NSArray arrayWithObject:uPhoto.photoURL]
                                             :[uPhoto.user_id userId]
                 ];
                //write new photo as a file in local directory;
                [CommonFunctions saveImageFromURLToLocal:uPhoto.photoURL :[uPhoto.user_id userId]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                                            [myImageView  setImage:[self loadImage:[[KCSUser activeUser] userId] ofType:@"png" inDirectory:documentsDirectoryPath]];
                    
                });
            }
            
        }
        
        
        
    }withProgressBlock:nil
     ];//PhotoStore;
    
    
    
    
    
    
    
    myImageView = [[UIImageView alloc] init];
    myImageView.image=Profileimage;
    myImageView.frame = CGRectMake(self.view.center.x-40, 110.0, 80.0, 80.0);
    [self.view addSubview:myImageView];
    
    //add tap gestrue on the profile image;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(tapDetected_ProfilePicture)
    ];
    //singleTap.numberOfTapsRequired = 1;
    //singleTap.cancelsTouchesInView = YES;
    myImageView.userInteractionEnabled = YES;
    [myImageView addGestureRecognizer:singleTap];
    //[self.view addGestureRecognizer:singleTap];
    
    
    
    /*retrieve userInfo from plist;*/
    NSDictionary* temp=[CommonFunctions retrieveFromPlist:@"UserInfo.plist"];
    self.AccountName.text =[[temp objectForKey:@"userInfo"] objectAtIndex:0];
    self.FirstNameTextField.text=[[temp objectForKey:@"userInfo"] objectAtIndex:1];
    self.FirstNameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.LastNameTextField.text=[[temp objectForKey:@"userInfo"] objectAtIndex:2];
    self.LastNameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
}

/*-(void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage* image_original = [info objectForKey: UIImagePickerControllerOriginalImage];*/
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    UIImage* image_original=image;
    
    
    //scale to thumbnail size;
    CGSize destinationSize = CGSizeMake(160,160);//same size as facebook's profile image;
    UIGraphicsBeginImageContext(destinationSize);
    [image_original drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *image_thumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString* filename = [[[KCSUser activeUser] userId] stringByAppendingString:@".png"];
    //save the image to local
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //Save Image to Directory
    [self saveImage:image_thumb withFileName:[[KCSUser activeUser] userId] ofType:@"png" inDirectory:documentsDirectoryPath
     ];
    
    
    
    
//    
//    /*retrieve userInfo from plist;*/
//    NSDictionary* temp=[CommonFunctions retrieveFromPlist:@"UserInfo"];
//    //delete existing image;[[temp objectForKey:@"userInfo"] objectAtIndex:0]
//    NSString *strName=[[NSString alloc ] initWithString:[temp objectForKey:@"imageIDonKinvey"]
//                      
//                      ];
//    //delete existing image;
//    if(![strName isEqualToString:@"111"]){//KCSCountBlock
//        [KCSFileStore deleteFile:strName completionBlock:^(unsigned long count, NSError *errorOrNil){
//            if(errorOrNil!=nil){
//                NSLog(@"%@",errorOrNil);
//            }
//        }];
//    }
//    
    
    
    
    //save image to SERVER
    
    NSURL* documentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL* sourceURL = [NSURL URLWithString:filename relativeToURL:documentsDir];
    //NSLog(@"%@",sourceURL);
    
    //__block NSString * imageURL;
    [KCSFileStore
     uploadFile:sourceURL
     options:@{KCSFilePublic:@(YES)} completionBlock:^(KCSFile *uploadInfo, NSError *error) {
         //NSLog(@"Upload finished. File id='%@', error='%@'.", [uploadInfo remoteURL], error);
         NSArray* myArray = [[[uploadInfo remoteURL] absoluteString]  componentsSeparatedByString:@"?"];
         NSString * imageURL=[myArray objectAtIndex:0];
         
         //save URL to local;
         [CommonFunctions writeToPlist:LocalImagePlist
                                      :[NSArray arrayWithObject:imageURL]
                                      :[[KCSUser activeUser] userId]
          ];
         
         //save URL to server;
         id<KCSStore> PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName : @"UserPhotos", KCSStoreKeyCollectionTemplateClass : [User_Photo class]}];
         //upload new photo;
         //if no KCSUser found, save to a new record;
         User_Photo * uPhoto=[[User_Photo alloc] init];
         uPhoto.user_id=[KCSUser activeUser];
         //UIImage* image1=[[UIImage alloc] init];image1=image;
         uPhoto.photo=image;
         if (!uPhoto.meta) {
             uPhoto.meta = [[KCSMetadata alloc] init];
         }
         [uPhoto.meta setGloballyReadable:YES];
         uPhoto.photoURL=imageURL;
         uPhoto.date=[NSDate date];
         
         [PhotoStore saveObject:uPhoto withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
             if (errorOrNil != nil) {
                 //save failed, show an error alert
                 
                 UIAlertController * alert=   [UIAlertController
                                               alertControllerWithTitle:@"Save failed"
                                               message:[errorOrNil localizedFailureReason]
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
             } else {
                 //save was successful
                 NSLog(@"Successfully saved photo.");
             }
         } withProgressBlock:nil
          ];
         
         
         
         
         
     } progressBlock:nil];
    
    /*[KCSFileStore uploadData:UIImagePNGRepresentation(image)
                     options:@{KCSFilePublic:@(YES)}
             completionBlock:^(KCSFile *uploadInfo, NSError *error) {
                 NSLog(@"Upload finished. File id='%@', error='%@'.", [uploadInfo fileId], error);
                 imageID=[uploadInfo fileId];
                 NSLog(@"%@",imageID);
    } progressBlock:nil]
    ;*/
    
    
    /*KCSCollection* collection1 = [KCSCollection collectionFromString:@"UserPhotos" ofClass:[User_Photo class]];
    id<KCSStore> PhotoStore = [KCSLinkedAppdataStore storeWithOptions:@{
            KCSStoreKeyResource : collection1,
            KCSStoreKeyCachePolicy : @(KCSCachePolicyNone),
            //KCSStoreKeyUniqueOfflineSaveIdentifier : @"UpdateMyInfoVC" ,
            //KCSStoreKeyOfflineSaveDelegate : self
    }];
    */
    
    
    
    
    
    
    
    /* wait for Kinvey to implement KCSLinkedAppdataStore to store image, otherwise, only use KCSFile to store images;
    //08-08-2015 YXiao;
     
    //try to save image to User_Photo:
    id<KCSStore> PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName : @"UserPhotos", KCSStoreKeyCollectionTemplateClass : [User_Photo class]}];
    
    //should first query if KCSUser exists; if yes, then store the image to it; otherwise, create a new record and store;
    KCSQuery* query = [KCSQuery queryOnField:@"user_id._id"
                      withExactMatchForValue:[[KCSUser activeUser] userId]
                       ];
    
    
    [PhotoStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (objectsOrNil != nil) {
            //load is successful!
            
            //NSLog(@"have found your photo");
            //show in table (Notifications from me);
            
            //delete all this user's photos
            if([objectsOrNil count]!=0){
                [PhotoStore removeObject:objectsOrNil
                     withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
                         NSLog(@"%@",errorOrNil);
                         
                         
                         //upload new photo;
                         //if no KCSUser found, save to a new record;
                         User_Photo * uPhoto=[[User_Photo alloc] init];
                         uPhoto.user_id=[KCSUser activeUser];
                         //UIImage* image1=[[UIImage alloc] init];image1=image;
                         uPhoto.photo=image;
                         if (!uPhoto.meta) {
                             uPhoto.meta = [[KCSMetadata alloc] init];
                         }
                         [uPhoto.meta setGloballyReadable:YES];
                         uPhoto.photoURL=@"null";
                         
                         [PhotoStore saveObject:uPhoto withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                             if (errorOrNil != nil) {
                                 //save failed, show an error alert
                                 UIAlertView* alertView = [[UIAlertView alloc]
                                                           initWithTitle:NSLocalizedString(@"Save failed", @"Save failed")
                                                           message:[errorOrNil localizedFailureReason]
                                                           delegate:nil
                                                           cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                           otherButtonTitles:nil
                                                           ];
                                 [alertView show];
                             } else {
                                 //save was successful
                                 NSLog(@"Successfully saved photo.");
                             }
                         } withProgressBlock:nil
                          ];
                         
                         
                         
                         
                     }
                       withProgressBlock:nil
                 ];
            }
            else{//objectsOrNil==0
                //upload new photo;
                //if no KCSUser found, save to a new record;
                User_Photo * uPhoto=[[User_Photo alloc] init];
                uPhoto.user_id=[KCSUser activeUser];
                //UIImage* image1=[[UIImage alloc] init];image1=image;
                uPhoto.photo=image;
                if (!uPhoto.meta) {
                    uPhoto.meta = [[KCSMetadata alloc] init];
                }
                [uPhoto.meta setGloballyReadable:YES];
                uPhoto.photoURL=@"null";
                
                [PhotoStore saveObject:uPhoto withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //save failed, show an error alert
                        UIAlertView* alertView = [[UIAlertView alloc]
                                                  initWithTitle:NSLocalizedString(@"Save failed", @"Save failed")
                                                  message:[errorOrNil localizedFailureReason]
                                                  delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil
                                                  ];
                        [alertView show];
                    } else {
                        //save was successful
                        NSLog(@"Successfully saved photo.");
                    }
                } withProgressBlock:nil
                 ];
            }
            
            
            
        } else {
            NSLog(@"%s",objectsOrNil);
        }
        
    } withProgressBlock:nil];
    
    */
    
    
    
    
    
// remove by query does not work; Kinvey sucks;
//    [PhotoStore removeObject:query
//         withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
//             NSLog(@"%@",errorOrNil);
//
//
//             //upload new photo;
//             //if no KCSUser found, save to a new record;
//             User_Photo * uPhoto=[[User_Photo alloc] init];
//             uPhoto.user_id=[KCSUser activeUser];
//             //UIImage* image1=[[UIImage alloc] init];image1=image;
//             uPhoto.photo=image;
//             if (!uPhoto.meta) {
//                 uPhoto.meta = [[KCSMetadata alloc] init];
//             }
//             [uPhoto.meta setGloballyReadable:YES];
//             uPhoto.photoURL=@"null";
//             
//             [PhotoStore saveObject:uPhoto withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                 if (errorOrNil != nil) {
//                     //save failed, show an error alert
//                     UIAlertView* alertView = [[UIAlertView alloc]
//                                               initWithTitle:NSLocalizedString(@"Save failed", @"Save failed")
//                                               message:[errorOrNil localizedFailureReason]
//                                               delegate:nil
//                                               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                               otherButtonTitles:nil
//                                               ];
//                     [alertView show];
//                 } else {
//                     //save was successful
//                     NSLog(@"Successfully saved photo.");
//                 }
//             } withProgressBlock:nil
//              ];
//             
//             
//             
//             
//         }
//           withProgressBlock:nil
//     ];
    
    
    
    
    
    /*
     response.body in the User_Photo backend;
     {
         "photo": {
            "_id": "UserPhotos-B7A7FDBF-AD93-4BB6-B2F9-392AF4038855-photo",
            "_type": "KinveyFile"
         },
         "user_id": {
            "_collection": "user",
            "_id": "52b7c5a4dbec78f429bc273a",
            "_type": "KinveyRef"
         },
         "_id": "B7A7FDBF-AD93-4BB6-B2F9-392AF4038855",
         "_acl": {
            "creator": "52b7c5a4dbec78f429bc273a"
         },
         "_kmd": {
            "lmt": "2014-06-03T05:57:50.938Z",
            "ect": "2014-06-03T05:57:50.938Z"
         }
     }
     
     -------------------------------------------------------------------------------
     response in Files backend (private file):
     
     {
     "_filename": "11F8CC81-E858-40E9-99A6-8B0187DDBE14.png",
     "_id": "UserPhotos-27046B9A-C83F-47B2-AE75-FCECC87096CA-photo",
     "mimeType": "image/png",
     "size": 95049,
     "_acl": {
     "creator": "52b7c5a4dbec78f429bc273a"
     },
     "_kmd": {
     "lmt": "2014-06-03T06:33:07.443Z",
     "ect": "2014-06-03T06:33:07.443Z"
     },
     "_uploadURL": "http://storage.googleapis.com/kinvey_production_2afdfe67078c4c7b94c8dd0adadb6093/UserPhotos-27046B9A-C83F-47B2-AE75-FCECC87096CA-photo/11F8CC81-E858-40E9-99A6-8B0187DDBE14.png?GoogleAccessId=558440376631@developer.gserviceaccount.com&Expires=1401777217&Signature=FtHc2oEuCXKQSxyOQFfKSn%2B438Answek85iYhx7RLdlJgaKkAYNQL6BPCaLoaZx2UWwq9uY3Z7DsaTppWADNHU4Oek%2B%2BJbBRFoWHBsecOluqir6RFSSmwggRILqCLCpzR05yF1Xg0mI%2FpYQO1HPtWkSp7XtKdkaMwwP4oDpjusw%3D",
     "_expiresAt": "2014-06-03T06:33:37.457Z",
     "_requiredHeaders": {}
     }
     
     
     -------------------------------------------------------------------------------
     response in Files backend (public file):
     
     
     {
     "_public": true,
     "_filename": "yhandxiao@gmail.com.png",
     "size": 95049,
     "mimeType": "image/png",
     "_id": "2e0d86a8-8467-4b3c-99e0-526b5acdd7cc",
     "_acl": {
     "creator": "52b7c5a4dbec78f429bc273a"
     },
     "_kmd": {
     "lmt": "2014-06-03T06:45:38.203Z",
     "ect": "2014-06-03T06:45:38.203Z"
     },
     "_uploadURL": "http://storage.googleapis.com/kinvey_production_2afdfe67078c4c7b94c8dd0adadb6093/2e0d86a8-8467-4b3c-99e0-526b5acdd7cc/yhandxiao%40gmail.com.png?GoogleAccessId=558440376631@developer.gserviceaccount.com&Expires=1401777968&Signature=GRAVG970IjF8MyJde1evDeNPwU0pQAwJROxtEaiaII%2FFha4t7M1cqIbn8vNyxe9T3vQFm%2B89fjLTNNPBymcuFO%2FUIDbDqkXR%2FJdH7rV%2BrlEU%2BsS1eHi0enzHjB5q8z7eA9Nch%2FH9G74jEGjo%2BWMzjyjdA1quBxJn8%2FDfba1Abao%3D",
     "_expiresAt": "2014-06-03T06:46:08.335Z",
     "_requiredHeaders": {
     "x-goog-acl": "public-read",
     "Cache-Control": "private, max-age=0, no-transform"
     }
     }
     */
    
    
    
    
   
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        //NSLog(@"dismissed");
    }];
    
    
    
    
    
//    
//    
//    //save the imageID to plist : userInfo:3;
//    
//    [CommonFunctions writeToPlist:@"BasicData"
//                      :[NSArray arrayWithObject:imageID]
//                      :[NSArray arrayWithObject:@"imageIDonKinvey"]
//     ];
    
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex)
	{
		case 0://take a picture
		{
			//NSLog(@"0");
            UIImagePickerController* ProfilePicturePickerController = [[UIImagePickerController alloc] init];
            ProfilePicturePickerController.delegate = self;
            ProfilePicturePickerController.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:ProfilePicturePickerController animated:YES completion:^{
                NSLog(@"taking picture");
            }
             ];
            
			break;
		}
            
		case 1://choose from albums
		{
            //NSLog(@"1");
            UIImagePickerController* ProfilePicturePickerController = [[UIImagePickerController alloc] init];
            ProfilePicturePickerController.delegate = self;
            ProfilePicturePickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:ProfilePicturePickerController animated:YES completion:^{
                NSLog(@"choosing from library");
            }
             ];
			break;
		}
           
            /*
		case 2://synchronize with facebook
		{
			//NSLog(@"2");
            AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
            if (!appDelegate.sessionFacebook.isOpen) {
                if (appDelegate.sessionFacebook.state != FBSessionStateCreated) {
                    
                    appDelegate.sessionFacebook = [[FBSession alloc] init];
                }
            }
                [appDelegate openFacebookSession];
                
                
                
                
                
//            }
//            else{//session open;
//                // create a fresh session object
//                appDelegate.sessionFacebook = [[FBSession alloc] init];
//                
//                //NSLog(@"%@",appDelegate.sessionFacebook.state);
//                if (appDelegate.sessionFacebook.state == FBSessionStateCreatedTokenLoaded) {
//                    // even though we had a cached token, we need to login to make the session usable
//                    [appDelegate.sessionFacebook openWithCompletionHandler:^(FBSession *session,
//                                                                             FBSessionState status,
//                                                                             NSError *error) {
//                        
//                    }];
//                }
//            }
            
            //[self updatePicture];
            
            
            //addObserver
//            [[NSNotificationCenter defaultCenter]
//             addObserver:self selector:@selector(FBStateReceiverSelector:)
//             name:FBSessionStateChangedNotification
//             object:nil
//             ];
            //addObserver
            [[NSNotificationCenter defaultCenter]
             addObserver:self selector:@selector(updatePicture)
             name:@"imageSaved"
             object:nil
             ];
            
            [self.actionAlert dismissWithClickedButtonIndex:2 animated:YES];
			break;
		}
            
            */
	}
}

-(void)tapDetected_ProfilePicture{
    actionAlert = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Take a Picture",
                                 @"Choose from Library",
                                 //@"Synchronize with Facebook",
                                 @"Cancel",
                                 nil,
                                 nil];
	
	// use the same style as the nav bar
	//styleAlert.actionSheetStyle = (UIActionSheetStyle)self.navigationController.navigationBar.barStyle;
	//[styleAlert dismissWithClickedButtonIndex:0 animated:YES];
	[actionAlert showInView:self.view];
    //[styleAlert showFromTabBar:[[self tabBarController] tabBar]];
	//[styleAlert release];
}


- (void)reset{
    [KCSUser sendPasswordResetForUser:[KCSUser activeUser].email withCompletionBlock:^(BOOL emailSent, NSError *errorOrNil) {
        if(errorOrNil==nil){
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Password Reset Successful", @"account success note title")
                                          message:[NSString stringWithFormat:NSLocalizedString(@"An email has been sent to %@, please follow the instructions in the email to reset your password. Note that the email is only valid for 60 minutes. Thanks.",@"account success message body"), self.AccountName.text
                                                   ]
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
    }];
}
- (void)save{
    KCSUser *user=[KCSUser activeUser];
    user.givenName=self.FirstNameTextField.text;
    user.surname=self.LastNameTextField.text;
    [user saveWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil1) {
        
            if (errorOrNil1 == nil) {
                //was successful!
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:NSLocalizedString(@"Account change saved", @"account success note title")

                                              message:[NSString stringWithFormat:NSLocalizedString(@"%@ %@ will be your name.",@"account success message body"), self.FirstNameTextField.text,self.LastNameTextField.text
                                                       ]
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
            } else {
                //there was an error with the update save
                NSString* message = [errorOrNil1 localizedDescription];
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:NSLocalizedString(@"Account change not saved, please try later", @"Log in account failed")
                                              message:message
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
        }
    
     ];
    
    
    /*save user info to plist;*/
    NSMutableArray *userInfo=[NSMutableArray arrayWithObjects:[
                                               [NSString alloc] initWithString:user.email],
              [[NSString alloc] initWithString:user.givenName],
              [[NSString alloc] initWithString:user.surname],
              nil
              ];
    
    
    [CommonFunctions writeToPlist:@"UserInfo.plist" :userInfo :@"userInfo"];


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
