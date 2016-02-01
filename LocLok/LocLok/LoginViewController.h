//
//  LoginViewController.h
//  LocShare
//
//  Created by yxiao on 6/10/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "ViewController.h"
#import "CommonFunctions.h"
#import<FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;
//@property (retain, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
//@property (strong, nonatomic) IBOutlet UIButton *createAccountButton;
//@property (strong, nonatomic) IBOutlet UIButton *resetPasswordButton;
//@property (weak, nonatomic) IBOutlet UILabel *defaultEmail;
@property (strong, nonatomic) IBOutlet UILabel *signupLabel;
@property (strong, nonatomic) IBOutlet UILabel *resetLabel;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
//NSMutableData* imageData;

- (void)loginWithFacebook;

//- (IBAction)login:(id)sender;
-(void)login;
- (void)updateView;
//-(IBAction)logout:(id)sender;
- (void)createAccount;
-(void)resetPassword;
@end
