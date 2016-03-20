//
//  CreateNewAccountVC.m
//  LocShare
//
//  Created by yxiao on 12/21/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "CreateNewAccountVC.h"
#import <KinveyKit/KinveyKit.h>
#import <KinveyKit/KinveyUser.h>

#define kMinPasswordLength 6

@interface CreateNewAccountVC ()

@end

@implementation CreateNewAccountVC
@synthesize userName;
@synthesize password;
@synthesize passwordRepeat;
@synthesize createButton,cancelButton;
@synthesize givenname;
@synthesize surname;



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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:1];
    UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    
    self.view.backgroundColor=bgColor;
    int width,height;
    int initialHeight=60;
    int boxHeight=40;
    width=self.view.bounds.size.width;
    height=self.view.bounds.size.height;
    
    
    //labels;
    
    UILabel *welcomeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight, width, boxHeight) ];
    welcomeLabel.textAlignment =  UITextAlignmentCenter;
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.backgroundColor = bgColor;
    welcomeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:24];
    [self.view addSubview:welcomeLabel];
    welcomeLabel.text = @"Create a New Account";
    
    
    //textFields;
    
    userName= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+60, width-40, boxHeight)];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.font = [UIFont systemFontOfSize:16];
    userName.placeholder = @"* Email";
    userName.autocorrectionType = UITextAutocorrectionTypeNo;
    userName.keyboardType = UIKeyboardTypeDefault;
    userName.returnKeyType = UIReturnKeyNext;
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userName.delegate = self;
    [userName setTag:1];
    [self.view addSubview:userName];
    
    
    password= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+100, width-40, boxHeight)];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.font = [UIFont systemFontOfSize:16];
    password.placeholder = @"* Password (longer than 6 digits)";
    password.autocorrectionType = UITextAutocorrectionTypeNo;
    password.keyboardType = UIKeyboardTypeDefault;
    password.returnKeyType = UIReturnKeyNext;
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    password.delegate = self;
    password.secureTextEntry=YES;
    [password setTag:2];
    [self.view addSubview:password];
    
    
    passwordRepeat= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+140, width-40, boxHeight)];
    passwordRepeat.borderStyle = UITextBorderStyleRoundedRect;
    passwordRepeat.font = [UIFont systemFontOfSize:16];
    passwordRepeat.placeholder = @"* Repeat password";
    passwordRepeat.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordRepeat.keyboardType = UIKeyboardTypeDefault;
    passwordRepeat.returnKeyType = UIReturnKeyNext;
    passwordRepeat.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordRepeat.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordRepeat.delegate = self;
    passwordRepeat.secureTextEntry=YES;
    [passwordRepeat setTag:3];
    [self.view addSubview:passwordRepeat];
    
    
    givenname= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+180, width-40, boxHeight)];
    givenname.borderStyle = UITextBorderStyleRoundedRect;
    givenname.font = [UIFont systemFontOfSize:16];
    givenname.placeholder = @"* First name (help friends find you)";
    givenname.autocorrectionType = UITextAutocorrectionTypeNo;
    givenname.keyboardType = UIKeyboardTypeDefault;
    givenname.returnKeyType = UIReturnKeyNext;
    givenname.clearButtonMode = UITextFieldViewModeWhileEditing;
    givenname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    givenname.delegate = self;
    [givenname setTag:4];
    [self.view addSubview:givenname];
    
    
    surname= [[UITextField alloc] initWithFrame:CGRectMake(20, initialHeight+220, width-40, boxHeight)];
    surname.borderStyle = UITextBorderStyleRoundedRect;
    surname.font = [UIFont systemFontOfSize:16];
    surname.placeholder = @"* Last name (help friends find you)";
    surname.autocorrectionType = UITextAutocorrectionTypeNo;
    surname.keyboardType = UIKeyboardTypeDefault;
    surname.returnKeyType = UIReturnKeyDone;
    surname.clearButtonMode = UITextFieldViewModeWhileEditing;
    surname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    surname.delegate = self;
    [surname setTag:5];
    [self.view addSubview:surname];
    
    
    
    //Buttons;
    
    self.createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.createButton.frame = CGRectMake(20, initialHeight+300, width/2-25, boxHeight);
    [self.createButton setTitle:@"Create" forState:UIControlStateNormal];
    self.createButton.backgroundColor = bgColor3;
    [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    self.createButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    self.createButton.clipsToBounds = YES;
    self.createButton.layer.cornerRadius = 6;//half of the width
    self.createButton.layer.borderColor=bgColor4.CGColor;
    self.createButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.createButton addTarget:self action:@selector(createNewAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createButton];
    
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(width/2+5, initialHeight+300, width/2-25, boxHeight);
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = bgColor3;
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    self.cancelButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.layer.cornerRadius = 6;//half of the width
    self.cancelButton.layer.borderColor=bgColor4.CGColor;
    self.cancelButton.layer.borderWidth=0.7f;
    //self.loginButton.contentEdgeInsets=
    /*UIImage *buttonImageNormal = [UIImage imageNamed:@"blueButton.png"];
     UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
     UIImage *buttonImagePressed = [UIImage imageNamed:@"whiteButton.png"];
     UIImage *strechableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
     [loginButton setBackgroundImage:strechableButtonImagePressed forState:UIControlStateHighlighted];*/
    [self.cancelButton addTarget:self action:@selector(cancelCreate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    
    
    [self validate];
    
    /*//make the keyboard go away when tap anywhere instead of the textfiled;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)] ;
    gestureRecognizer.cancelsTouchesInView = NO; //so that action such as clear text field button can be pressed
    [self.view addGestureRecognizer:gestureRecognizer];
    */
}
- (void)viewDidUnload {
    [self setUserName:nil];
    [self setPassword:nil];
    [self setPasswordRepeat:nil];
    [self setCreateButton:nil];
    [super viewDidUnload];
}

-(void)cancelCreate{
    userName.text=@"";
    password.text=@"";
    passwordRepeat.text=@"";
    givenname.text=@"";
    surname.text=@"";
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (CGRectContainsPoint([self.createButton frame], [touch locationInView:self.view]) )
    {
        
//        if(![self NSStringIsValidEmail:userName.text ]){
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Please input a valid email"
//                                                           delegate:self
//                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
        [self validate];
        if( [self NSStringIsValidEmail:userName.text ]){//username
            
            
            //check if the username has already existed;
            [KCSUser checkUsername:[userName.text lowercaseString] withCompletionBlock:^(NSString *username_1, BOOL usernameAlreadyTaken, NSError *error) {
                /*<#Handle error#>*/
                if (usernameAlreadyTaken == YES) {
                    [[[UIAlertView alloc] initWithTitle:@"Username Already Taken"
                                                message:[NSString stringWithFormat:@"'%@' already in use, choose another username", username_1]
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show
                     ];
                }
            }
             ];
            return;
            
        }
        
//        if(password.text.length<kMinPasswordLength){
//            [[[UIAlertView alloc] initWithTitle:@"Password Error"
//                                        message:@"Password must be longer than 6 digits."
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil] show
//             ];
//            
//        }
//        
//        if(![passwordRepeat.text isEqualToString:password.text]){//password repeat
//            [[[UIAlertView alloc] initWithTitle:@"Password Error"
//                                        message:@"Passwords must be the same."
//                                       delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil] show
//             ];
//        }
        if([self.givenname isEqual:@""] || [self.surname isEqual:@""]){//given name;
            
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Given name and Surname cannot be empty."
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
        
            
            UIColor *alertColor=[UIColor colorWithRed:1 green:0.8 blue:1 alpha:1];
            UIColor *normalColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
            if(![self  NSStringIsValidEmail:self.userName.text]){
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Please input a valid email"
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
                
                [self.userName setBackgroundColor:alertColor];
                self.userName.clearButtonMode=UITextFieldViewModeAlways;
            }
            else{
                [self.userName setBackgroundColor:normalColor];
                self.userName.clearButtonMode=UITextFieldViewModeWhileEditing;
            }
            if(![passwordRepeat.text isEqualToString:password.text]){
                
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Please input the same passwords"
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
                [self.password setBackgroundColor:alertColor];
                self.password.clearButtonMode=UITextFieldViewModeAlways;
                [self.passwordRepeat setBackgroundColor:alertColor];
                self.passwordRepeat.clearButtonMode=UITextFieldViewModeAlways;
            }
            else{
                [self.password setBackgroundColor:normalColor];
                self.password.clearButtonMode=UITextFieldViewModeWhileEditing;
                [self.passwordRepeat setBackgroundColor:normalColor];
                self.passwordRepeat.clearButtonMode=UITextFieldViewModeWhileEditing;
            }
            if (self.createButton.enabled) {
                [self createNewAccount];
            }
            
        
        
        
    }
    
    //reset password;
    if (CGRectContainsPoint([self.cancelButton frame], [touch locationInView:self.view]))
    {
        [self cancelCreate];
    }
    
    
    [self.view endEditing:YES];
    
}


- (void)createNewAccount
{
    NSString* username = [userName.text lowercaseString];
    
    //Kinvey-Use code: create a new user
    [KCSUser userWithUsername:[userName.text lowercaseString]
        password:password.text
        fieldsAndValues:nil
        withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if ( errorOrNil == nil) {
//            //In addition to creating the user that is used for login-purposes, this app also creates a public "user" entity that is for display in the table
//            [self.navigationController popViewControllerAnimated:YES];
            user.email = [self.userName.text lowercaseString];
            user.givenName = self.givenname.text;
            user.surname = self.surname.text;
            
            NSMutableArray *userInfo1;
            userInfo1=[NSMutableArray arrayWithObjects:[[NSString alloc] initWithString:user.email],[[NSString alloc] initWithString:user.givenName],[[NSString alloc] initWithString:user.surname],nil];
            [CommonFunctions writeToPlist:@"UserInfo.plist" :userInfo1 :@"userInfo"];
            
            //wait for the credential to be written;
            dispatch_after(1, dispatch_get_main_queue(), ^{
                //resave the user's email, givenname and surname;
                [user saveWithCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil1) {
                    if (errorOrNil1 == nil) {
                        //was successful!
                        [self dismissViewControllerAnimated:YES completion:nil];
                        UIResponder* nextResponder = [self.view.superview nextResponder];
                        if ([nextResponder isKindOfClass:[UIViewController class]])
                        {
                            [(UIViewController*)nextResponder viewWillAppear:YES];
                        }
                        
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"Account Creation Successful"
                                                      message:@"User created. Welcome!"
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
                        //return to the login page;
                    } else {
                        //there was an error with the update save
                        //return to the login page;
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                        NSString* message = [errorOrNil1 localizedDescription];
                        
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"Create account failed"
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
                }];
            });
            
            
            
            
            
//            
//            /*save user info to plist;*/
//            NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//            // get documents path
//            NSString *documentsPath = [paths objectAtIndex:0];
//            // get the path to our Data/plist file
//            NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"BasicData.plist"];
//            
//            
//            NSMutableArray *userInfo;
//            userInfo=[NSMutableArray arrayWithObjects:[[NSString alloc] initWithString:[KCSUser activeUser].email],[[NSString alloc] initWithString:[KCSUser activeUser].givenName],[[NSString alloc] initWithString:[KCSUser activeUser].surname],nil];
//            
//            
//            // create dictionary with values in UITextFields
//            NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:  userInfo, nil] forKeys:[NSArray arrayWithObjects: @"userInfo", nil]];
//            
//            NSError *error = [NSError alloc];
//            // create NSData from dictionary
//            NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict
//                                                                           format:NSPropertyListXMLFormat_v1_0
//                                                                          options:0
//                                                                            error:&error
//                                 ];
//            // check is plistData exists
//            if(plistData)
//            {
//                // write plistData to our Data.plist file
//                [plistData writeToFile:plistPath atomically:YES];
//            }
//            else
//            {
//                NSLog(@"Error in saveData: %@", error);
//            }
            
            
            
            
        } else {
            BOOL wasUserError = [[errorOrNil domain] isEqual: KCSUserErrorDomain];
            NSString* title = wasUserError ? [NSString stringWithFormat:NSLocalizedString(@"Could not create new user with username %@", @"create username error title"), username]: NSLocalizedString(@"An error occurred.", @"Generic error message");
            NSString* message = wasUserError ? NSLocalizedString(@"Please choose a different username.", @"create username error message") : [errorOrNil localizedDescription];
            
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
            
        }
    }];
    
}



#pragma mark - Text Field Stuff
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (void) validate
{
    if (password.text.length >= kMinPasswordLength && [password.text isEqualToString:passwordRepeat.text] && [self NSStringIsValidEmail:userName.text ] && ![self.givenname.text isEqual:@""] && ![self.surname.text isEqual:@""]) {
        createButton.enabled = YES;
    } else {
        createButton.enabled = NO;
    }
    if(self.createButton.enabled){
        [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    }
    else{
        [self.createButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self validate];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self validate];
    [self animateTextField: textField up: NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self validate];
    if(textField==self.userName && ![self NSStringIsValidEmail:userName.text ]){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Please input a valid email"
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
        return NO;
    }
    if(textField==self.userName && [self NSStringIsValidEmail:userName.text ]){//username
        
        //to assign an outside variable in the block;
        __block BOOL shouldReturnOfEmail;
        //check if the username has already existed;
        [KCSUser checkUsername:[userName.text lowercaseString] withCompletionBlock:^(NSString *username_1, BOOL usernameAlreadyTaken, NSError *error) {
            /*<#Handle error#>*/
            if (usernameAlreadyTaken == YES) {
                
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Username Already Taken"
                                              message:[NSString stringWithFormat:@"'%@' already in use, choose another username", username_1]
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
                shouldReturnOfEmail=NO;
            } else {
                shouldReturnOfEmail=YES;
                
            }
        }
         ];
        //NSLog(@"tag=1");
        if(shouldReturnOfEmail)
            [self.password  becomeFirstResponder];
        return shouldReturnOfEmail;
        
        
    }
    else if(textField==self.password && textField.text.length>=kMinPasswordLength){//password
        [self.passwordRepeat becomeFirstResponder];
    }
    else if(textField==self.password && textField.text.length<kMinPasswordLength){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Password Error"
                                      message:@"Password must be longer than 6 digits."
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
        
        return NO;
        
    }
    
    else if(textField==self.passwordRepeat && [textField.text isEqualToString:password.text]){//password repeat
        [self.givenname becomeFirstResponder];
    }
    else if(textField==self.givenname){//given name;
        [self.surname becomeFirstResponder];
    }
    else if(textField==self.surname ){//surname;
        [textField resignFirstResponder];
        UIColor *alertColor=[UIColor colorWithRed:1 green:0.8 blue:1 alpha:1];
        UIColor *normalColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        if(![self  NSStringIsValidEmail:self.userName.text]){
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please input a valid email"
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
            [self.userName setBackgroundColor:alertColor];
            self.userName.clearButtonMode=UITextFieldViewModeAlways;
        }
        else{
            [self.userName setBackgroundColor:normalColor];
            self.userName.clearButtonMode=UITextFieldViewModeWhileEditing;
        }
        if(![passwordRepeat.text isEqualToString:password.text]){
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Please input the same passwords"
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
            [self.password setBackgroundColor:alertColor];
            self.password.clearButtonMode=UITextFieldViewModeAlways;
            [self.passwordRepeat setBackgroundColor:alertColor];
            self.passwordRepeat.clearButtonMode=UITextFieldViewModeAlways;
        }
        else{
            [self.password setBackgroundColor:normalColor];
            self.password.clearButtonMode=UITextFieldViewModeWhileEditing;
            [self.passwordRepeat setBackgroundColor:normalColor];
            self.passwordRepeat.clearButtonMode=UITextFieldViewModeWhileEditing;
        }
        if (self.createButton.enabled) {
            [self createNewAccount];
        }

    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
