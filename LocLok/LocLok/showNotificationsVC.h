//
//  showNotificationsVC.h
//  LocShare
//
//  Created by yxiao on 1/4/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import "AddFriends.h"
#import "Friendship.h"
#import "User_Photo.h"
#import "CommonFunctions.h"
@interface showNotificationsVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>

//@property (strong, nonatomic) IBOutlet UITextField *FirstNameTextField;
@property  UIActivityIndicatorView *spinner;
@property (strong ,nonatomic) IBOutlet UITableView* notifTable;

@end
