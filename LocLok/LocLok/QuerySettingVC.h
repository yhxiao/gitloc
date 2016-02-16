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
#import "AppDelegate.h"
@interface QuerySettingVC : UITableViewController<TimeSettingVCDelegate>

@property (nonatomic,strong)NSMutableArray *timeArray;
@property (nonatomic,strong)NSArray *timeArrayConst;
@property (nonatomic,strong)NSDate* today00;//00:00:00 time of today;
@property (nonatomic,strong)NSDate* yesterday00;//00:00:00 time of yesterday;
@property (nonatomic,strong)NSDate* last3day00;//00:00:00 time of today-3;
@property (nonatomic,strong)NSDate* thisWeek00;//00:00:00 suday of this week;
@property (nonatomic,strong)NSDate* lastWeek00;//00:00:00 suday of last week;
@property (nonatomic,strong)NSDate* thisMonth00;//00:00:00 suday of this month;
@property (nonatomic,strong)NSDate* lastMonth00;//00:00:00 suday of last month;
@property (nonatomic)BOOL isCustomized;
- (IBAction)sendQuery;
@end
