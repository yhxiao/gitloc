//
//  CreateNewAccountVC.h
//  LocShare
//
//  Created by yxiao on 12/21/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewAccountVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *passwordRepeat;
@property (strong, nonatomic) IBOutlet UITextField *givenname;
@property (strong, nonatomic) IBOutlet UITextField *surname;

@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (void)createNewAccount;
-(void)cancelCreate;
@end
