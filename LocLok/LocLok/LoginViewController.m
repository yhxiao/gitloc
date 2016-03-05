//
//  LoginViewController.m
//  LocShare
//
//  Created by yxiao on 6/10/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <KinveyKit/KinveyKit.h>
#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import "MBProgressHUD.h"
#import "CreateNewAccountVC.h"

@interface LoginViewController ()
//NSMutableData* imageData;
@end

@implementation LoginViewController
//@synthesize sessionFacebook;

//@synthesize profilePictureView;
@synthesize loginButton;
@synthesize userNameTextField;
@synthesize passwordTextField;
//@synthesize createAccountButton;
//@synthesize resetPasswordButton;
@synthesize signupLabel,resetLabel;

//@synthesize defaultEmail;
//NSMutableData* imageData;
//UIImage* headerImageView;

extern NSString *const FBSuccessfulLoginNotification;
extern NSString *const FBFailedLoginNotification;

- (void)FBStateReceiverSelector:(NSNotification *)notification {
    
    //test;
    NSLog(@"FBLogin notif received");
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.facebookLoginButton.enabled=YES;
    [self.facebookLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    /* FBSDK 3.x below
    FBSession * fb_session=[notification object];
    if(fb_session.state==FBSessionStateOpen){
        [self dismissViewControllerAnimated:NO completion:^{
            NSLog(@"dismiss login page");
        }
         ];
    }
     */
    [self dismissViewControllerAnimated:NO completion:^{
        
        NSLog(@"dismiss login page");
    }];
}
- (void)FBLoginFailedSelector:(NSNotification *)notification {
    
    //test;
    NSLog(@"FBFailure notif received");
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.facebookLoginButton.enabled=YES;
    [self.facebookLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];

}


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

- (void) validate
{
    //NSLog(@"%@",self.userNameTextField.text);
    //NSLog(@"%@",self.passwordTextField.text);
    
    if([self NSStringIsValidEmail:self.userNameTextField.text]  && self.passwordTextField.text.length > 0){
        [self.userNameTextField setBackgroundColor:[UIColor whiteColor]];
        self.loginButton.enabled =YES;
         }
    else
        self.loginButton.enabled =NO;
    
    if(self.loginButton.enabled){
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    }
    else{
        [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self validate];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
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
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if(![self  NSStringIsValidEmail:self.userNameTextField.text]){
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Please input a valid email"
                                          message:@""
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
                [self.userNameTextField setBackgroundColor:[UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.2]];
                self.userNameTextField.clearButtonMode=UITextFieldViewModeAlways;
        }
        if (self.loginButton.enabled) {
            [self login];
        }
    }
    return YES;
}


#pragma mark - Actions
//- (void) disableButtons:(NSString*) message;
//{
//    self.loginButton.enabled = NO;
//    self.createAccountButton.enabled = NO;
//    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = message;
//}

//- (void) reenableButtons
//{
//    [self validate];
//    self.createAccountButton.enabled = YES;
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//}

- (void) handeLogin:(NSError*)errorOrNil
{
    //[self reenableButtons];
    if (errorOrNil != nil) {
        //self.view.frame =CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height+80);
        
        BOOL wasUserError = [[errorOrNil domain] isEqual:KCSUserErrorDomain];
        NSString* title = wasUserError ? NSLocalizedString(@"Invalid Credentials", @"credentials error title") : NSLocalizedString(@"An error occurred.", @"Generic error message");
        NSString* message = wasUserError ? NSLocalizedString(@"Wrong username or password. Please check and try again.", @"credentials error message") : [errorOrNil localizedDescription];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
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
    } else {
        //clear fields on success
        self.userNameTextField.text = @"";
        self.passwordTextField.text = @"";
        
        
        
        
        
        /*save user info to plist;*/
        NSMutableArray *userInfo;
        userInfo=[NSMutableArray arrayWithObjects:[[NSString alloc] initWithString:[KCSUser activeUser].email],[[NSString alloc] initWithString:[KCSUser activeUser].givenName],[[NSString alloc] initWithString:[KCSUser activeUser].surname],nil];
        [CommonFunctions writeToPlist:@"UserInfo.plist" :userInfo :@"userInfo"];
        
        
        
        
        //logged in went okay - go to the table
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}







- (void)updateView {

    /*retrieve userInfo from plist;*/
    
	NSDictionary *temp = [CommonFunctions retrieveFromPlist:@"UserInfo.plist"];
    self.userNameTextField.text=[[temp objectForKey:@"userInfo"] objectAtIndex:0];
    self.userNameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.passwordTextField.text=@"";
    
    if ([KCSUser hasSavedCredentials] == YES) {
        //[self performSegueWithIdentifier:@"toMain" sender:self];
    }
    
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
    UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    //UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:1];
    UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    [super viewDidLoad];
    
    self.userNameTextField.delegate=self;
    self.passwordTextField.delegate=self;
    [self validate];
    self.view.backgroundColor=bgColor;
    int width,height;
    int initialHeight=60;
    int boxHeight=40;
    width=self.view.bounds.size.width;
    height=self.view.bounds.size.height;
    
    //self.view.frame=CGRectMake(0, 0, width, height+80);
    
    //labels;
    
    //UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UILabel *welcomeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight, width, boxHeight) ];
    welcomeLabel.textAlignment =  NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.backgroundColor = bgColor;
    welcomeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:36];
    [self.view addSubview:welcomeLabel];
    welcomeLabel.text = @"LocLok";
    
    UILabel *orLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight+200, width, 40) ];
    orLabel.textAlignment =  NSTextAlignmentCenter;
    orLabel.textColor = [UIColor whiteColor];
    orLabel.backgroundColor = bgColor;
    orLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    [self.view addSubview:orLabel];
    orLabel.text = @"or";
    
    signupLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(20, initialHeight+310, width/2-110, boxHeight-10)];
    signupLabel.textAlignment =  NSTextAlignmentLeft;
    //signupLabel.textColor = [UIColor whiteColor];
    signupLabel.backgroundColor = bgColor;
    signupLabel.userInteractionEnabled=YES;
    //signupLabel.font = [UIFont fontWithName:@"ArialMT" size:(10)];
    [self.view addSubview:signupLabel];
    //signupLabel.text = @"Sign Up";
    NSAttributedString * signupString = [[NSAttributedString alloc] initWithString:@"Sign Up" attributes:@ {
        NSFontAttributeName : [UIFont fontWithName:@"ArialMT" size:10],
        NSForegroundColorAttributeName : [UIColor whiteColor],
    NSBackgroundColorAttributeName:bgColor,
        NSShadowAttributeName : [[NSShadow alloc] init],
    NSUnderlineStyleAttributeName:[NSNumber numberWithInt: NSUnderlineStyleDouble]
    }
                                        ];
    signupLabel.attributedText=signupString;
    
    
    
    resetLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(width/2+55, initialHeight+310, width/2-75, boxHeight-10)];
    resetLabel.textAlignment =  NSTextAlignmentRight;
    //resetLabel.textColor = [UIColor whiteColor];
    resetLabel.backgroundColor = bgColor;
    //resetLabel.font = [UIFont fontWithName:@"ArialMT" size:10];
    resetLabel.userInteractionEnabled = YES;
    [self.view addSubview:resetLabel];
    //resetLabel.text = @"Forgot Password";
    
    NSAttributedString * resetString = [[NSAttributedString alloc] initWithString:@"Forgot Password" attributes:@ {
        NSFontAttributeName : [UIFont fontWithName:@"ArialMT" size:10],
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSBackgroundColorAttributeName:bgColor,
        NSShadowAttributeName : [[NSShadow alloc] init],
        NSUnderlineStyleAttributeName:[NSNumber numberWithInt: NSUnderlineStyleDouble]
    }
                                        ];
    resetLabel.attributedText=resetString;
    //resetLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Test string" attributes:underline];
    
    
    
    
    
    //textFields;
    
    self.userNameTextField= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+70, width-40, boxHeight)];
    self.userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.userNameTextField.font = [UIFont systemFontOfSize:16];
    self.userNameTextField.placeholder = @"Email";
    self.userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userNameTextField.keyboardType = UIKeyboardTypeDefault;
    self.userNameTextField.returnKeyType = UIReturnKeyNext;
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userNameTextField.delegate = self;
    [self.view addSubview:self.userNameTextField];
    
    
    self.passwordTextField= [[UITextField alloc] initWithFrame:CGRectMake(20,initialHeight+110, width-40, boxHeight)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.font = [UIFont systemFontOfSize:16];
    self.passwordTextField.placeholder = @"Password";
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
    self.passwordTextField.returnKeyType = UIReturnKeyGo;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry=YES;
    [self.view addSubview:self.passwordTextField];
    
    
    
    //Buttons;
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(20, initialHeight+160, width-40, boxHeight);
    [self.loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    self.loginButton.backgroundColor = bgColor3;
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    self.loginButton.clipsToBounds = YES;
    self.loginButton.layer.cornerRadius = 6;//half of the width
    self.loginButton.layer.borderColor=bgColor4.CGColor;
    self.loginButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    
    self.facebookLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.facebookLoginButton.frame = CGRectMake(20, initialHeight+240, width-40, boxHeight);
    [self.facebookLoginButton setTitle:@"Log In with Facebook" forState:UIControlStateNormal];
    self.facebookLoginButton.backgroundColor = bgColor3;
    [self.facebookLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    self.facebookLoginButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    self.facebookLoginButton.clipsToBounds = YES;
    self.facebookLoginButton.layer.cornerRadius = 6;//half of the width
    self.facebookLoginButton.layer.borderColor=bgColor4.CGColor;
    self.facebookLoginButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.facebookLoginButton addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.facebookLoginButton];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinner.center=CGPointMake(width-50, initialHeight+240+boxHeight/2);
    
    
    //make the keyboard go away when tap anywhere instead of the textfiled;
    /*
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)] ;
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    */
    
    
    
//automatic login view works as follows:
    
//    // Create Login View so that the app will be granted "status_update" permission.
//    FBLoginView *loginview = [[FBLoginView alloc] init];
//    
//    //loginview.frame = CGRectOffset(loginview.frame, 5, 5);
//    loginview.frame = CGRectOffset(loginview.frame, (self.view.center.x - (loginview.frame.size.width / 2)), 5);
//    loginview.readPermissions = @[@"basic_info", @"email", @"user_likes"];
//#ifdef __IPHONE_7_0
//#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        loginview.frame = CGRectOffset(loginview.frame, 5, 25);
//    }
//#endif
//#endif
//#endif
//    loginview.delegate = self;
//    
//    [self.view addSubview:loginview];
//    
//    [loginview sizeToFit];
    
    //[self updateView];
    
    /* FBSDK 3.x below
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.sessionFacebook.isOpen) {
        // create a fresh session object
        appDelegate.sessionFacebook = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.sessionFacebook.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.sessionFacebook openWithCompletionHandler:^(FBSession *session,
                                                                     FBSessionState status,
                                                                     NSError *error) {
                // we recurse here, in order to update buttons and labels
                //[self updateView];
                //[self performSegueWithIdentifier:@"toMain" sender:self];
            }];
        }
    }
    //NSLog(@"%@",FBSessionStateChangedNotification);
    */
    
    //receive the notification of facebook login;
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(FBStateReceiverSelector:)
     name:FBSuccessfulLoginNotification
     object:nil
     ];
    //name:FBSDKAccessTokenDidChangeNotification
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(FBLoginFailedSelector:)
     name:FBFailedLoginNotification
     object:nil
     ];
    
    [self validate];
}





//// Called every time a chunk of the data is received
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [imageData appendData:data]; // Build the image
//}
//
//// Called when the entire image is finished downloading
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    // Set the image in the header imageView
//    headerImageView = [UIImage imageWithData:imageData];
//}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    [self updateView];
    [self validate];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    //Definitions
//    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
////    //Get Image From URL
////    UIImage * imageFromURL = [self getImageFromURL:@"https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash1/203254_1519359_1161572570_n.jpg"];
////    
////    //Save Image to Directory
////    [self saveImage:imageFromURL withFileName:@"MyProfilePicture" ofType:@"jpg" inDirectory:documentsDirectoryPath];
//    
//    //Load Image From Directory
//    UIImage * imageFromWeb = [self loadImage:@"MyProfilePicture" ofType:@"jpg" inDirectory:documentsDirectoryPath];
//    UIImageView *myImageView = [[UIImageView alloc] init];
//    myImageView.image=imageFromWeb;
//    myImageView.frame = CGRectMake(0.0, 70.0, 25.0, 25.0);
//    [self.view addSubview:myImageView];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.passwordTextField.text=@"";
    
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) hideKeyboard {
    //[self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Disallow recognition of gestures in unwanted elements
    if ([touch.view isMemberOfClass:[UIButton class]]) { // The "clear text" icon is a UIButton
        return NO;
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    //sign up;
    if (CGRectContainsPoint([self.signupLabel frame], [touch locationInView:self.view]))
    {
        [self createAccount];
    }
    
    //reset password;
    if (CGRectContainsPoint([self.resetLabel frame], [touch locationInView:self.view]))
    {
        [self resetPassword];
    }
    
    
        [self.view endEditing:YES];
    
}

- (void)login
{
    //[self disableButtons:NSLocalizedString(@"Logging in", @"Logging In Message")];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    ///Kinvey-Use code: login with the typed credentials
    [KCSUser loginWithUsername:[self.userNameTextField.text lowercaseString] password:self.passwordTextField.text withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        
        
        [self handeLogin:errorOrNil];
        if(!errorOrNil){
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            //[FriendList checkNewFriend ];
            NSLog(@"%@",[[KCSUser activeUser] userId ]);
            if(appDelegate.fList==nil){
                appDelegate.fList=[FriendList alloc];
            }
            appDelegate.fList=[appDelegate.fList loadWithID:[[KCSUser activeUser] userId ]];
            [appDelegate getPrivRulesFromBackend];
            
        
        }
        
    }];
    //NSLog(@"Log in finished.");
    //[self performSegueWithIdentifier:@"toSignUp" sender:self];
    
    
    
}

/*-(IBAction)logout:(id)sender{
    [[KCSUser activeUser] logout];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.sessionFacebook.isOpen) {
        [appDelegate.sessionFacebook closeAndClearTokenInformation];
        
    }
    [KCSUser clearSavedCredentials];
    NSLog(@"Logged out.");
}
 */
- (void)loginWithFacebook
{
    
    /*self.sessionFacebook = [[FBSession alloc] initWithAppID:@"117215641821273"
                                                permissions:permissions
                                            urlSchemeSuffix:nil
                                         tokenCacheStrategy:nil];*/
    //[self openFacebookSession];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // this button's job is to flip-flop the session from open to closed
    
    //[appDelegate.sessionFacebook closeAndClearTokenInformation];
    /* FBSDK 3.x below
    if (appDelegate.sessionFacebook.isOpen) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:FBSuccessfulLoginNotification
         object:appDelegate.sessionFacebook
         ];
        
    } else {
        if (appDelegate.sessionFacebook.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.sessionFacebook = [[FBSession alloc] init];
        }
        
        [appDelegate openFacebookSession];
        
        
        //[self performSegueWithIdentifier:@"toMain" sender:self];
    }
     */
    
    if([FBSDKAccessToken currentAccessToken]){
        [self dismissViewControllerAnimated:NO completion:^{
            NSLog(@"has facebook token, dismiss login page");
        }
         ];
    }
    else{
        
        [self.view addSubview:self.spinner];
        [self.spinner startAnimating];
        self.facebookLoginButton.enabled=NO;
        [self.facebookLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        
        [appDelegate openFacebookSession];
    }
    
    
    
}

- (void)createAccount
{
    
    //CreateNewAccountVC *createNewAccount=[]
    CreateNewAccountVC *newAccountVC = [[CreateNewAccountVC alloc] initWithNibName:@"CreateNewAccountVC" bundle:nil];
    newAccountVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:newAccountVC animated:YES completion:nil];
}


-(void)resetPassword{
    if(![self  NSStringIsValidEmail:self.userNameTextField.text]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please input a valid email."
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
        [self.userNameTextField setBackgroundColor:[UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.2]];
        self.userNameTextField.clearButtonMode=UITextFieldViewModeAlways;
    }
    else{
        [KCSUser sendPasswordResetForUser:self.userNameTextField.text withCompletionBlock:^(BOOL emailSent, NSError *errorOrNil) {
            if(errorOrNil==nil){
                
            }
        }];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Password Reset"
                                      message:[[@"An email has been sent to " stringByAppendingString:self.userNameTextField.text] stringByAppendingString:@". Please follow the instructions in the email to change your password. Note that the email is only valid in twenty minutes from now."]
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




@end
