//
//  QuerySettingVC.h
//  LocShare
//
//  Created by yxiao on 6/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSettingVC.h"
#import "QueryAnswerViewController.h"
@interface QuerySettingVC : UITableViewController<TimeSettingVCDelegate>

@property NSMutableArray *timeArray;
- (IBAction)sendQuery;
@end
