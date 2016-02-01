//
//  PrivacySettingViewController.h
//  LocShare
//
//  Created by yxiao on 6/26/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<KinveyKit/KinveyKit.h>
#import "PrivSetting.h"
#import "AppDelegate.h"
#import "TimePeriodPrivacy.h"
#import "PrivacyRuleSettingVC.h"
@interface PrivacySettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PrivRuleSettingVCDelegate>


@property (nonatomic, retain) IBOutlet UISwitch * sharing_switch;
@property (nonatomic, retain) IBOutlet UISwitch * sharing_switch0;
@property (nonatomic, retain) IBOutlet UISwitch * stranger_switch;
//@property (nonatomic, retain) IBOutlet UITextField * radius_text_mile,*radius_text_km;
@property (nonatomic,retain)  IBOutlet UISlider *radius_slider_mile,*radius_slider_km;
@property (nonatomic, retain) IBOutlet UITableView * rulesTableView;
@property (strong, nonatomic) IBOutlet UILabel * labelShare;
@property (strong, nonatomic) IBOutlet UILabel * labelShare0;
@property (strong, nonatomic) IBOutlet UILabel* labelRadius;
@property (strong, nonatomic) IBOutlet UILabel * labelEdit1,*labelAdd1;
@property (strong, nonatomic) IBOutlet UIView* seperatorView;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *info1,*info2,*info3;//info1 explains true location; info2 explains protected location;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
//@property (strong, nonatomic) id<KCSStore> privStore;
- (IBAction)flipSwitch:(id)sender;
-(void)hideKeyboard;
-(void)touchRecognizer_info1;
-(void)touchRecognizer_info2;
-(void)touchRecognizer_info3;
//- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture;
-(void)sliderAction:(id)sender;
-(void) getPrivRulesFromBackend;
-(void) savePrivRulesToBackend1;
-(void) rulesTableEdit;
-(void) rulesTableAdd;
-(void) AdjustPageLength;
-(void) initPrivSettingWithDefault;


@end
