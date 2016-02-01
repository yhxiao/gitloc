//
//  PrivacyRuleSettingVC.h
//  LocShare
//
//  Created by yxiao on 8/23/15.
//  Copyright (c) 2015 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TableViewCell01.h"
#import "PrivSetting.h"

@protocol PrivRuleSettingVCDelegate <NSObject>
-(void) getRuleData:(NSMutableArray*)timeRule;
@end

@interface PrivacyRuleSettingVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>


@property (nonatomic, retain) IBOutlet UITableView * configTable;
@property (nonatomic, retain) NSMutableArray* labelText;
@property (nonatomic, retain) NSMutableArray* detailedText;
@property (nonatomic, weak) id <PrivRuleSettingVCDelegate> delegate;

- (IBAction)doneAction:(id)sender;
- (IBAction)timeAction:(id)sender;


@end
