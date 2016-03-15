//
//  FindFriendVC.m
//  LocShare
//
//  Created by yxiao on 12/29/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "FindFriendVC.h"

@interface FindFriendVC ()
@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) id<KCSStore> friendshipStore;
@property (nonatomic, retain) id<KCSStore> PhotoStore;
@end

extern NSString* LocalImagePlist;

@implementation FindFriendVC

@synthesize welcomeLabel;
@synthesize userNameTextField,firstNameTextField,lastNameTextField;
@synthesize searchButton;
@synthesize resultTable;
@synthesize initialHeight,boxHeight;
@synthesize searchResult,spinner;
@synthesize updateStore,friendshipStore,PhotoStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



//textFields delegates;

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    if(self.resultTable.hidden==NO)[self hideTable];
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
//test if a string is an email address;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)validate{
    if( [self.firstNameTextField.text length]!=0 || [self.lastNameTextField.text length]!=0 || [self  NSStringIsValidEmail:self.userNameTextField.text]){//isEqualToString:@""
        self.searchButton.enabled=YES;
        return YES;
    }
    self.searchButton.enabled=NO;
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self validate];
    //return NO;
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    [self validate];
    return YES;
}

//whether it should resign first responder
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self validate];
    if(textField == self.userNameTextField && ![self  NSStringIsValidEmail:self.userNameTextField.text])return NO;
    
    if (textField == self.userNameTextField && [self  NSStringIsValidEmail:self.userNameTextField.text]) {
        [self.firstNameTextField becomeFirstResponder];
    }
    else if(textField == self.firstNameTextField){
        [self.lastNameTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
            if (self.searchButton.enabled) {
            [self search];
        }
    }
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Disallow recognition of gestures in unwanted elements
    if ([touch.view isMemberOfClass:[UIButton class]] && self.resultTable.hidden==YES) { // The "clear text" icon is a UIButton
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    
    
    if(self.resultTable.hidden==YES)[self.view endEditing:YES];
    if(self.resultTable.hidden==NO){
       [self hideTable];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:1];
    UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    [super viewDidLoad];
    self.view.backgroundColor=bgColor;
    int width,height;
    initialHeight=60;
    boxHeight=40;
    width=self.view.bounds.size.width;
    height=self.view.bounds.size.height;
    self.updateStore=[KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"AddFriend",KCSStoreKeyCollectionTemplateClass : [AddFriends class],
        KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)}
                      ];
    self.friendshipStore=[KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"Friendship",KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                                KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)}
                      ];
    PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
            KCSStoreKeyCollectionName : @"UserPhotos",
            KCSStoreKeyCollectionTemplateClass : [User_Photo class]
            ,KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
    }];
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]; 
    spinner.frame=CGRectMake(width/2-20, initialHeight+200, 40, boxHeight);
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    
    
    //labels;
    
    //UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    welcomeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+40, width, boxHeight) ];
    welcomeLabel.textAlignment =  UITextAlignmentCenter;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.backgroundColor = bgColor;
    welcomeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    [self.view addSubview:welcomeLabel];
    welcomeLabel.text = @"Find a Friend";
    
    
    
    
    //textFields;
    
    userNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+70, width-40, boxHeight)];
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    userNameTextField.font = [UIFont systemFontOfSize:16];
    userNameTextField.placeholder = @"by Email";
    userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameTextField.keyboardType = UIKeyboardTypeDefault;
    userNameTextField.returnKeyType = UIReturnKeyNext;
    userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameTextField.delegate = self;
    [self.view addSubview:userNameTextField];
    
    
    firstNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+110, width-40, boxHeight)];
    firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    firstNameTextField.font = [UIFont systemFontOfSize:16];
    firstNameTextField.placeholder = @"by First Name";
    firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameTextField.keyboardType = UIKeyboardTypeDefault;
    firstNameTextField.returnKeyType = UIReturnKeyNext;
    firstNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    firstNameTextField.delegate = self;
    [self.view addSubview:firstNameTextField];
    
    
    lastNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+150, width-40, boxHeight)];
    lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    lastNameTextField.font = [UIFont systemFontOfSize:16];
    lastNameTextField.placeholder = @"by Last Name";
    lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    lastNameTextField.keyboardType = UIKeyboardTypeDefault;
    lastNameTextField.returnKeyType = UIReturnKeyGo;
    lastNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lastNameTextField.delegate = self;
    [self.view addSubview:lastNameTextField];
    
    
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchButton.frame = CGRectMake(20, initialHeight+200, width-40, boxHeight);
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.searchButton.backgroundColor = bgColor3;
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    self.searchButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    self.searchButton.clipsToBounds = YES;
    self.searchButton.layer.cornerRadius = 6;//half of the width
    self.searchButton.layer.borderColor=bgColor4.CGColor;
    self.searchButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    
    
    self.resultTable=[[UITableView alloc] init];
    self.resultTable.hidden=YES;
    self.resultTable.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-120-self.navigationController.navigationBar.frame.size.height);
    //self.resultTable.style=UITableViewStylePlain;
    [self.view addSubview:self.resultTable ];
    self.resultTable.delegate=self;
    //self.resultTable.=bgColor;
    
    
}




//search friends;
-(void)search{
    [self.view endEditing:YES];
    
    NSMutableDictionary *lookupFields;
    lookupFields=[[NSMutableDictionary alloc] init];
    if([self.lastNameTextField.text length]!=0){
        [lookupFields setObject:self.lastNameTextField.text
                         forKey:KCSUserAttributeSurname
         ];
    }
    if([self.firstNameTextField.text length]!=0){
        [lookupFields setObject:self.firstNameTextField.text
                         forKey:KCSUserAttributeGivenname
         ];
    }
    if([self.userNameTextField.text length]!=0){
        [lookupFields setObject:[self.userNameTextField.text lowercaseString]
                         forKey:KCSUserAttributeUsername
         ];
    }
    
    if(lookupFields.count==0){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please fill in one of the fields."
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
    else{
    
    
        //If the lookup is sucessful the value for objectsOrNil be a NSArray where each element is a NSDictionary providing all the public fields of the matching user(s).
        [KCSUserDiscovery lookupUsersForFieldsAndValues:lookupFields
                                    completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                        if (errorOrNil == nil) {
                                            //array of matching KCSUser objects
                                            //NSLog(@"Found %@", objectsOrNil);
                                            [self showTable:objectsOrNil];
                                        } else {
                                            NSLog(@"Got An error: %@", errorOrNil);
                                        }
                                    }
                                      progressBlock:^(NSArray *objects, double percentComplete) {
                                          
                                          [spinner startAnimating];
                                          
                                          /*
                                          UIProgressView *progView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
                                          [self.view addSubview:progView];
                                          progView.progress=percentComplete;
                                           */

                                      }
         ];
    }
}



-(void)showTable:(NSArray*)resultArray{
    
//    //push TextFields to the top;
//    const int movementDistance = 130-self.navigationController.navigationBar.frame.size.height; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement =-movementDistance;
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
    
    [spinner stopAnimating];
    
    int initialHeight1=self.navigationController.navigationBar.frame.size.height;
    initialHeight1=0;
    int width=self.view.bounds.size.width;
    //hide search button;
    
    self.resultTable.hidden=NO;
    [UIView animateWithDuration:0.6f animations:^{
        self.welcomeLabel.frame=CGRectMake(0, initialHeight1-70, width, boxHeight);
        self.userNameTextField.frame=CGRectMake(20, initialHeight1, width-40, 40);
        self.firstNameTextField.frame=CGRectMake(20, initialHeight1+40, width-40, 40);
        self.lastNameTextField.frame=CGRectMake(20, initialHeight1+80, width-40, 40);
        self.resultTable.frame=CGRectMake(0, initialHeight1+120, self.view.bounds.size.width, self.view.bounds.size.height-120-initialHeight1);
        self.searchButton.hidden=YES;
    }
     ];
    
    //self.welcomeLabel.hidden=YES;
    
    self.searchResult=resultArray;
    self.resultTable.delegate=self;
    self.resultTable.dataSource=self;
    [self.resultTable reloadData];
    
    
    
}
-(void)hideTable{
    
//    //pull TextFields to the original position;
//    const int movementDistance = 130-self.navigationController.navigationBar.frame.size.height; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement =movementDistance;
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//    
    
    int initialHeight1=self.navigationController.navigationBar.frame.size.height;
    int width=self.view.bounds.size.width;
    
    
    //self.welcomeLabel.hidden=NO;
    [UIView animateWithDuration:0.6f animations:^{
        self.welcomeLabel.frame=CGRectMake(0, initialHeight1+40, width, boxHeight);
    self.resultTable.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-120-self.navigationController.navigationBar.frame.size.height);
    self.userNameTextField.frame=CGRectMake(20, initialHeight+70, width-40, boxHeight);
    self.firstNameTextField.frame=CGRectMake(20, initialHeight+110, width-40, boxHeight);
    self.lastNameTextField.frame=CGRectMake(20, initialHeight+150, width-40, boxHeight);
    self.searchButton.hidden=NO;
    

    }
     ];
    self.resultTable.hidden=YES;
    
    [self validate];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    
    
    
    
    
    
    
    /*Initialize navigation bar;*/
    
    
    /*Initialize the position of self.view   at  y axis */
    
    
    
    
    
    
    
    
    
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.lastNameTextField.text=nil;
    self.firstNameTextField.text=nil;
    self.userNameTextField.text=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	return self.searchResult.count;
}

//- (NSString *)wordAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *wordsInSection;
//    switch (indexPath.section) {
//        case 0:
//            wordsInSection =[self.words objectForKey:@"Settings"];
//            break;
//        case 1:
//            wordsInSection =[self.words objectForKey:@"Friends Management"];
//            break;
//            
//        case 2:
//            wordsInSection =[self.words objectForKey:@"Advanced"];
//            break;
//        case 3:
//            wordsInSection =[self.words objectForKey:@"About LocShare"];
//            break;
//            
//        default:
//            break;
//    }
//	//NSLog(@"%d,%d,%@",indexPath.section,indexPath.row,[wordsInSection objectAtIndex:indexPath.row]);
//    return [wordsInSection objectAtIndex:indexPath.row];
//    
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.searchResult.count==0 || self.searchResult.count==1){
        return [NSString stringWithFormat: @"%d results has been found",self.searchResult.count];

    }
    return [NSString stringWithFormat: @"%d results have been found",self.searchResult.count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FindFriendTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //the text
	cell.textLabel.text = [[[[self.searchResult objectAtIndex:indexPath.row] givenName]
                           stringByAppendingString:@" "]
                           stringByAppendingString:[[self.searchResult objectAtIndex:indexPath.row] surname]
                           ];
    cell.detailTextLabel.text = [[self.searchResult objectAtIndex:indexPath.row] username];
    
    
    
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
    
    //The profile image on the left;
    UIImage* pImage=[CommonFunctions loadImageFromLocal:[[self.searchResult objectAtIndex:indexPath.row] userId]];
    [cell.imageView  setImage:pImage==nil?[UIImage imageNamed:@"profile_default.png"]:pImage];
    [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
    
    cell.imageView.layer.cornerRadius=4;
    cell.imageView.layer.masksToBounds = YES;
    
    /* tried to get image file from KCSFileStore, but does not work; Kinvey's fault;
     YXiao-08-10-2015
    KCSQuery* pngQuery = [KCSQuery queryOnField:KCSFileFileName withExactMatchForValue:
                          [[[[self.searchResult objectAtIndex:indexPath.row] username] lowercaseString] stringByAppendingString:@".png"]
                          //@"icon_cell_add60.png"
                          ];
    [KCSFileStore downloadFileByQuery:pngQuery completionBlock:^(NSArray *downloadedResources, NSError *error) {
        if (error == nil && downloadedResources.count>0) {
            //if(downloadedResources.count>0){
                //profileImage=[UIImage imageWithData:[downloadedResources objectAtIndex:0].data];
                //profileURL=[[downloadedResources objectAtIndex:0] remoteURL];
                KCSFile* file = [downloadedResources objectAtIndex:0];
                NSURL* fileURL = file.localURL;
                UIImage* image1 = [UIImage imageWithContentsOfFile:[fileURL path]]; //note this blocks for awhile
                
                //placeholder image while loading;
                [cell.imageView  setImage:[UIImage imageNamed:@"profile_default.png"]];
                
                //Get the main thread to update the UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.imageView  setImage:image1];
                    
                });
                
                //cell.imageView.image=image1;
            //}
            
            //else{
                
            //    [cell.imageView  setImage:[UIImage imageNamed:@"profile_default.png"]];
            //}
            
        } else {
            NSLog(@"Got an error: %@", error);
        }
    } progressBlock:nil];
    */
    
    KCSQuery *query4 = [KCSQuery queryOnField:@"user_id._id"
             withExactMatchForValue:[[self.searchResult objectAtIndex:indexPath.row] userId]
              ];
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
    [query4 addSortModifier:sortByDate]; //sort the return by the date field
    [query4 setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    
    
    [PhotoStore  queryWithQuery:query4 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (objectsOrNil != nil && [objectsOrNil count]>0) {
            
            //NSLog(@"%@",[(NSDictionary*)[[objectsOrNil objectAtIndex:0] photo] objectForKey:@"_downloadURL"]);
            /*UIImage* image1 = [UIImage imageWithContentsOfFile:[
             (NSDictionary*)[[objectsOrNil objectAtIndex:0] photo ]objectForKey:@"_downloadURL"]
             ];
             */
            
            /*
             Dictionary of Photo:
             photo:
             {
             "_acl" =     {
             creator = 52b4e557dbec78f429ba821a;
             };
             "_downloadURL" = "http://storage.googleapis.com/kinvey_production_2afdfe67078c4c7b94c8dd0adadb6093/UserPhotos-2716ED17-EE80-4973-A130-AE6D6D3FB65A-photo/2497E9FD-252C-43B8-BBA0-7F10BADBE34E.png?GoogleAccessId=558440376631@developer.gserviceaccount.com&Expires=1401859272&Signature=P3thqG263tHiZyVd5wKdBoJJM96pEhJ7YjaBT%2B%2BOt4VJwGQEO6eRyOPZz7f%2FSe9VBgVkL8N0pZ7414xSh71DdA28BfVmMF4gQTkHcaLt873IVCsclc6lLUr51lqJ%2FiaP78%2FARPbgnVmhJx1uUt2sWbAC24wAvE%2B%2FA7rVoH%2B8YcA%3D";
             "_expiresAt" = "2014-06-04T05:21:12.601Z";
             "_filename" = "2497E9FD-252C-43B8-BBA0-7F10BADBE34E.png";
             "_id" = "UserPhotos-2716ED17-EE80-4973-A130-AE6D6D3FB65A-photo";
             "_kmd" =     {
             ect = "2014-05-31T06:36:34.527Z";
             lmt = "2014-05-31T06:36:34.527Z";
             };
             "_type" = KinveyFile;
             mimeType = "image/png";
             size = 265709;
             }
             */
            
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
                
                
                //Get the main thread to update the UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.imageView  setImage:[CommonFunctions loadImageFromLocal:[uPhoto.user_id userId]]];
                
                });
            }
            
            
        } else {
            NSLog(@"error when downloading photo: %@", errorOrNil);
        }
        
    } withProgressBlock:nil
     ];
    

    
    
    
    return cell;
}
- (void)checkButtonTapped:(id)sender event:(id)event
{
//    NSSet *touches = [event allTouches];
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
//    
//    if (indexPath != nil)
//    {
//        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
//    }
    NSLog(@"tapped");
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
    
    
    
    //a user cannot add himself as a friend;
    //NSLog([[self.searchResult objectAtIndex:indexPath.row] userId]);
    //NSLog([[KCSUser activeUser] userId]);
    if([
       [[self.searchResult objectAtIndex:indexPath.row] userId]
        isEqualToString:
       [[KCSUser activeUser] userId]
        ]){
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Can not add yourself as a friend"
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
        return;
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    __block NSNumber *perm;
    
    
    
    NSString *str_Name=  [[[[self.searchResult objectAtIndex:indexPath.row] givenName]
                           stringByAppendingString:@" "]
                          stringByAppendingString:[[self.searchResult objectAtIndex:indexPath.row] surname]
                          ];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Friendship Request"
                                  message:[[@"Do you want to add "
                                            stringByAppendingString:str_Name]
                                           stringByAppendingString:@" as your friend? If so, please select your permission. E.g., \"True Loc\" means you can view his/her true location."
                                           ]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* trueloc = [UIAlertAction
                              actionWithTitle:@"True Loc"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  perm=[NSNumber numberWithInteger:PermissionForFamily];
                                  dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                  [FriendList AddOneFriend:(KCSUser *)[self.searchResult objectAtIndex:indexPath.row]
                                                Permission:perm Controller:self
                                                   Initial:[NSNumber numberWithInteger:AddFriendFirstTime]
                                   ];
                                  });
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    UIAlertAction* cloakedloc = [UIAlertAction
                                 actionWithTitle:@"Cloaked Loc"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     perm=[NSNumber numberWithInteger:PermissionForFriends];
                                     dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                     [FriendList AddOneFriend:(KCSUser *)[self.searchResult objectAtIndex:indexPath.row]
                                                   Permission:perm Controller:self
                                                      Initial:[NSNumber numberWithInteger:AddFriendFirstTime]
                                      ];
                                     });
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
    
    [alert addAction:cancel];
    [alert addAction:trueloc];
    [alert addAction:cloakedloc];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    
    

}



@end
