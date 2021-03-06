//
//  AboutVC.m
//  LocLok
//
//  Created by yxiao on 3/15/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import "AboutVC.h"
extern NSString * LocLok_Version;
@implementation AboutVC




- (void)viewDidLoad
{
    UIColor *bgColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //UIColor *bgColor2=[UIColor colorWithRed:0.6 green:0 blue:0.6 alpha:1];
    //UIColor *bgColor3=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    //UIColor *bgColor4=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    [super viewDidLoad];

    
    
    self.view.backgroundColor=bgColor;
    int width,height;
    int initialHeight=60;
    int boxHeight=40;
    width=self.view.bounds.size.width;
    //height=self.view.bounds.size.height;
    

//    UILabel *TMLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight+34, width, boxHeight) ];
//    TMLabel.textAlignment =  NSTextAlignmentCenter;
//    TMLabel.textColor = [UIColor purpleColor];
//    TMLabel.backgroundColor = bgColor;
//    TMLabel.font = [UIFont fontWithName:@"Verdana" size:10];
//    [self.view addSubview:TMLabel];
//    TMLabel.text = @"                          TM";
    //UIColor *bgColor=[UIColor colorWithRed:0.4 green:0 blue:0.4 alpha:1];
    UILabel *welcomeLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight+34, width, boxHeight) ];
    welcomeLabel.textAlignment =  NSTextAlignmentCenter;
    welcomeLabel.textColor = [UIColor purpleColor];
    welcomeLabel.backgroundColor = bgColor;
    welcomeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:36];
    [self.view addSubview:welcomeLabel];
    welcomeLabel.text = @"LocLok\u2122";
    
    
    
    UILabel *versionLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, initialHeight+70, width, boxHeight/2) ];
    versionLabel.textAlignment =  NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor purpleColor];
    versionLabel.backgroundColor = bgColor;
    versionLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    [self.view addSubview:versionLabel];
    versionLabel.text = [@"Version: " stringByAppendingString:LocLok_Version];
    
    UILabel *textLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, initialHeight+100, width-20, 300) ];
    textLabel.textAlignment =  NSTextAlignmentLeft;
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = bgColor;
    textLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
    [self.view addSubview:textLabel];
    textLabel.adjustsFontSizeToFitWidth=NO;
    textLabel.numberOfLines=0;
    textLabel.lineBreakMode=NSLineBreakByClipping;
    textLabel.text = @"Thanks for using LocLok. LocLok stands for \"location cloaking\", which is a term used in location privacy protection. We have been working on data security and privacy for many years, and LocLok is the first mobile app that enables \"differential privacy\" for location sharing. We are highly dedicated to making LocLok for everyone to use. Please feel free to contact us if you have any comments or suggestions. \n\n Author: Yonghui Xiao (http://yxiao.info) \n Contact: yhandxiao@gmail.com \n Website: http://forum.loclok.com \n Acknowledgement: Li Xiong";
    
    
}

@end
