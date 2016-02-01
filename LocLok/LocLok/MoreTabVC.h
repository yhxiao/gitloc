//
//  MoreTabVC.h
//  LocShare
//
//  Created by yxiao on 12/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "UpdateMyInfoVC.h"
#import "WriteUpdateViewController.h"

@interface MoreTabVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView	*MoreTableView;
    NSMutableDictionary *words;
	NSArray *sections;
}
@property (retain) NSMutableDictionary *words;
@property (retain) NSArray *sections;
@property (retain) NSMutableArray *orderedSequence;
@property (nonatomic, retain) IBOutlet UITableView *MoreTableView;
//-(BOOL)writeToPlist: (NSString *)fileName
//           objArray:(NSArray*) objInfo
//            objName:(NSArray *)objName;
@end
