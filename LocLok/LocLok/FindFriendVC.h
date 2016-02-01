//
//  FindFriendVC.h
//  LocShare
//
//  Created by yxiao on 12/29/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import "AddFriends.h"
#import "Friendship.h"
#import "User_Photo.h"
#import "CommonFunctions.h"

@interface FindFriendVC : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong ,nonatomic) IBOutlet UITableView* resultTable;
@property (strong ,nonatomic) IBOutlet UILabel* welcomeLabel;
@property  UIActivityIndicatorView *spinner;
@property int initialHeight;
@property int boxHeight;
@property NSArray* searchResult;
-(void)search;
-(void) showTable:(NSArray*)resultArray;
-(void)hideTable;
@end
