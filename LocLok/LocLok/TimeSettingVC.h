//
//  TimeSettingVC.h
//  LocShare
//
//  Created by yxiao on 6/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimeSettingVCDelegate;

@interface TimeSettingVC : UITableViewController{

//id<TimeSettingVCDelegate> timedelegate;
    //__unsafe_unretained id<TimeSettingVCDelegate> timedelegate;
}

@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic,weak) id<TimeSettingVCDelegate> timedelegate;

- (IBAction)doneAction:(id)sender;
- (IBAction)dateAction:(id)sender;
@end

@protocol TimeSettingVCDelegate
- (void)TimeSettingVCDidFinish:(NSMutableArray*)theTime;
@end
