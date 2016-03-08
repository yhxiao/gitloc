//
//  MyPermissions.m
//  LocLok
//
//  Created by yxiao on 3/5/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import "MyPermissions.h"


@interface MyPermissions ()
//@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) UIFont * cellFont;
@property (nonatomic, retain) UIFont * cellFont2;
@end



@implementation MyPermissions



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.cellFont=[ UIFont fontWithName: @"Arial" size: 14 ];
    self.cellFont2=[ UIFont fontWithName: @"Arial" size: 10 ];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    
    appDelegate.fList=[appDelegate.fList loadWithID:[[KCSUser activeUser] userId ]];
    
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //if(section==0){
        return appDelegate.fList.friends.count;
    //}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //if(section==0){
        return @"";
    //}
    
    
}
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
//        
//        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
//        tableViewHeaderFooterView.textLabel.textAlignment = NSTextAlignmentCenter;
//    }
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyPmnTableViewCell";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    //cell.detailTextLabel.numberOfLines=2;
    //cell.preservesSuperviewLayoutMargins=NO;
    //cell.layoutMargins =UIEdgeInsetsMake(0, 0, 0, -20);
    //cell.separatorInset = UIEdgeInsetsZero;//if you also want to adjust separatorInset
    
    //if(indexPath.section==1){//toCollection;
        
        Friendship *aFriend=[appDelegate.fList.friends objectAtIndex:indexPath.row];
        //cell.textLabel.text =[(NSDictionary*)aFriend.to_user objectForKey:@"_id"];
        cell.textLabel.text = [[[[aFriend.to_user givenName]
                                 stringByAppendingString:@" "]
                                stringByAppendingString:[aFriend.to_user surname]]
                               stringByAppendingString:@""
                               ];
        cell.textLabel.font=self.cellFont;
        cell.detailTextLabel.font=self.cellFont2;
    
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor=[UIColor blackColor];
            cell.detailTextLabel.text=[aFriend.permission integerValue]==PermissionForFamily?@"true location":@"cloaked location";
            
            //The icon on the right side of a row;
            //cell.accessoryType = UITableViewCellAccessoryNone;
            UIImage *image =  [UIImage imageNamed:@"icon_cell_add60.png"] ;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(0.0, 0.0, 24, 24);
            button.frame = frame;
            [button setBackgroundImage:image forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            cell.accessoryView = button;
            
    
        UIImage* profileImg=[CommonFunctions loadImageFromLocal:[aFriend.to_user userId]];
        [cell.imageView  setImage:profileImg==nil?[UIImage imageNamed:@"profile_default.png"]:profileImg];
        //[cell.imageView  setImage:uPhoto.photo];
        [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
        
        //use rounded corner for the image;
        cell.imageView.layer.cornerRadius =4;
        cell.imageView.layer.masksToBounds = YES;
        //cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
        //cell.imageView.layer.borderWidth = 3.0;
    //}//section==1
    
    
    
    return cell;
}
- (void)checkButtonTapped:(id)sender event:(id)event//clicked accessory button;
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: sender] anyObject] locationInView: self.tableView]];
    if ( indexPath == nil ){
        return;
    }
    //trigger the delegate method accessoryButtonTappedForRowWithIndexPath;
    //[self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Friendship *aFriend=[appDelegate.fList.friends objectAtIndex:indexPath.row];
    
    NSString* friendName=[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString* title=[@"Request Permission from " stringByAppendingString:friendName];
    
    NSString* message=[[@"Do you want to send a permission request to " stringByAppendingString:friendName] stringByAppendingString:@"?"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* left = [UIAlertAction
                           actionWithTitle:@"Cancel"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    UIAlertAction* middle = [UIAlertAction
                            actionWithTitle:@"True Loc"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                //
                                
                                
                                [FriendList AddOneFriend:aFriend.to_user
                                              Permission:[NSNumber numberWithInteger:PermissionForFamily]
                                              Controller:self
                                            Initial:[NSNumber numberWithInteger:AddFriendModifyPermission]
                                 ];
                                
                                
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    UIAlertAction* right = [UIAlertAction
                            actionWithTitle:@"Cloaked Loc"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                //
                                
                                
                                [FriendList AddOneFriend:aFriend.to_user
                                              Permission:[NSNumber numberWithInteger:PermissionForFriends]
                                              Controller:self
                                                 Initial:[NSNumber numberWithInteger:AddFriendModifyPermission]
                                 ];
                                
                                
                                [alert dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
    
    [alert addAction:left];
    if([[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text isEqualToString:@"true location"]){
        [alert addAction:right];
    }
    else{
        [alert addAction:middle];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
            }
}


@end
