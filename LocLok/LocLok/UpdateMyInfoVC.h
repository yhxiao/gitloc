//
//  UpdateMyInfoVC.h
//  LocShare
//
//  Created by yxiao on 12/25/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User_Photo.h"
#import<KinveyKit/KinveyKit.h>
#import "CommonFunctions.h"
@interface UpdateMyInfoVC : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,KCSOfflineUpdateDelegate >

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *myAccountLabel;
@property (strong, nonatomic) IBOutlet UILabel *myFirstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myLastNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *FBDetailedLabel;

@property (strong, nonatomic) IBOutlet UITextField *FirstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *LastNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *ResetPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *SaveChangesButton;
@property (strong, nonatomic) IBOutlet UILabel *AccountName;
@property (strong, nonatomic) IBOutlet UIActionSheet *actionAlert;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

//@property (weak, nonatomic) IBOutlet UIImage * Profileimage;
//@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
- (void)reset;
- (void)save;
//- (void)FBStateReceiverSelector:(NSNotification *)notification;
-(void)dismissThis;
@end
