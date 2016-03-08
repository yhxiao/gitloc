//
//  showNotificationsVC.h
//  LocShare
//
//  Created by yxiao on 1/4/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
#import "AddFriends.h"
#import "Friendship.h"
#import "User_Photo.h"
#import "CommonFunctions.h"
#import "AppDelegate.h"
#import "FriendList.h"
@interface showNotificationsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>//,UIGestureRecognizerDelegate,UIAlertViewDelegate>

//@property (strong, nonatomic) IBOutlet UITextField *FirstNameTextField;
@property  UIActivityIndicatorView *spinner;
@property (strong ,nonatomic) IBOutlet UITableView* notifTable;
@property (nonatomic, retain) id<KCSStore> loadStore;
@property (nonatomic, retain) id<KCSStore> PhotoStore;
@property (nonatomic, retain) id<KCSStore> friendshipStore;
//@property (nonatomic, retain) id<KCSStore> sendStore;
//@property (nonatomic, retain) id<KCSStore> userStore;

@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;//not sure how to use
@property (nonatomic, strong) UIRefreshControl *notifRefresh;

@property (nonatomic,strong) NSNumber* finishedQueries;
@property (nonatomic,strong) AddFriends *oneFriend;
//@property (nonatomic,strong) dispatch_queue_t serialQueue;//make sure tasks are executed one by one in sequence;


- (void)checkButtonTapped:(id)sender event:(id)event;
@end
