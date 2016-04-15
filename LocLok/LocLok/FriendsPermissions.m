//
//  FriendsPermissions.m
//  LocLok
//
//  Created by yxiao on 3/5/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import "FriendsPermissions.h"

@interface FriendsPermissions ()
//@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) UIFont * cellFont;
@property (nonatomic, retain) UIFont * cellFont2;
@end

extern NSString* inFriends_finished_Notification;
extern NSString* LocalImagePlist;
NSString* const strPermissionTrueLocation=@"true location";
NSString* const strPermissionCloakedLocation=@"cloaked location";
NSString* const strPermissionNoLocation=@"no location";

@implementation FriendsPermissions


@synthesize PhotoStore,friendshipStore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"Friends' Permissions of Me";
    
    self.cellFont=[ UIFont fontWithName: @"Arial" size: 14 ];
    self.cellFont2=[ UIFont fontWithName: @"Arial" size: 10 ];
    
    
    PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                         KCSStoreKeyCollectionName : @"UserPhotos",
                                                         KCSStoreKeyCollectionTemplateClass : [User_Photo class],
                                                         KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
                                                         }];
    
    friendshipStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                       KCSStoreKeyCollectionName : @"Friendship",
                                                       KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                       KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
                                                       }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queriesFinished:)
                                                 name:inFriends_finished_Notification
                                               object:nil
     ];
//    self.tableView.dataSource=self;
//    self.tableView.delegate=self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication  sharedApplication] delegate];
    [appDelegate.fList searchFriendsHavingMyPermissions];
}


- (void)queriesFinished:(NSNotification *)notification {
    [self.tableView reloadData];
}
-(void)saveModifiedFriendship:(Friendship *)aFriend
                withIndexPath:(NSIndexPath *)indexPath{
    [friendshipStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if(errorOrNil==nil){
                //dispatch_async(dispatch_get_main_queue(), ^{
                if([aFriend.permission integerValue]==PermissionForFamily){
                    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text=strPermissionTrueLocation;
                }
                if([aFriend.permission integerValue]==PermissionForFriends){
                    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text=strPermissionCloakedLocation;
                }
                if([aFriend.permission integerValue]==PermissionForNoLoc){
                    [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text=strPermissionNoLocation;
                }
                
                //});
            }
            else{
                NSLog(@"saveModifiedFriendship, %@",errorOrNil);
            }
    } withProgressBlock:nil
     ];
}
-(void)deleteFriendship:(Friendship *)aFriend
                withIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [friendshipStore removeObject:aFriend withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
        if(errorOrNil==nil){
            //dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate.fList.inFriends removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            //});
        }
        else{
            NSLog(@"deleteFriendship: %@",errorOrNil);
        }
    } withProgressBlock:nil
     ];
    
    
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
    return appDelegate.fList.inFriends.count;
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
    static NSString *CellIdentifier = @"MyInFriendsTableViewCell";
    
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
    
    Friendship *aFriend=[appDelegate.fList.inFriends objectAtIndex:indexPath.row];
    //cell.textLabel.text =[(NSDictionary*)aFriend.to_user objectForKey:@"_id"];
    cell.textLabel.text = [[[[aFriend.from_user givenName]
                             stringByAppendingString:@" "]
                            stringByAppendingString:[aFriend.from_user surname]]
                           stringByAppendingString:@""
                           ];
    cell.textLabel.font=self.cellFont;
    cell.detailTextLabel.font=self.cellFont2;
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor blackColor];
    if([aFriend.permission integerValue]==PermissionForFamily){
        cell.detailTextLabel.text=strPermissionTrueLocation;
    }
    if([aFriend.permission integerValue]==PermissionForFriends){
        cell.detailTextLabel.text=strPermissionCloakedLocation;
    }
    if([aFriend.permission integerValue]==PermissionForNoLoc){
        cell.detailTextLabel.text=strPermissionNoLocation;
    }
    //cell.detailTextLabel.text=[aFriend.permission integerValue]==PermissionForFamily?@"true location":@"cloaked location";
    
    //The icon on the right side of a row;
//    //cell.accessoryType = UITableViewCellAccessoryNone;
//    UIImage *image =  [UIImage imageNamed:@"icon_cell_add60.png"] ;
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    CGRect frame = CGRectMake(0.0, 0.0, 24, 24);
//    button.frame = frame;
//    [button setBackgroundImage:image forState:UIControlStateNormal];
//    
//    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor clearColor];
//    cell.accessoryView = button;
    cell.accessoryType=UITableViewCellAccessoryDetailButton;
    
    
    
    UIImage* profileImg=[CommonFunctions loadImageFromLocal:[aFriend.from_user userId]];
    [cell.imageView  setImage:profileImg==nil?[UIImage imageNamed:@"profile_default.png"]:profileImg];
    //[cell.imageView  setImage:uPhoto.photo];
    [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
    
    //use rounded corner for the image;
    cell.imageView.layer.cornerRadius =4;
    cell.imageView.layer.masksToBounds = YES;
    //cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    //cell.imageView.layer.borderWidth = 3.0;
    //}//section==1
    
    
    
    
    KCSQuery* query4 = [KCSQuery queryOnField:@"user_id._id"
                       withExactMatchForValue:[[aFriend from_user] userId]
                        ];
    
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
    [query4 addSortModifier:sortByDate]; //sort the return by the date field
    [query4 setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    
    
    [PhotoStore  queryWithQuery:query4 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (objectsOrNil != nil && [objectsOrNil count]>0) {
            User_Photo * uPhoto=objectsOrNil[0];
            
            //get existing image's URL;
            //NSDictionary *temp = [CommonFunctions retrieveFromPlist:LocalImagePlist];
            NSString *frdImageURL =[CommonFunctions retrieveImageInfoFromPlist:LocalImagePlist withUserId:[uPhoto.user_id userId]];
            //[[temp objectForKey:[uPhoto.user_id userId]] objectAtIndex:0];
            //NSLog(@"%@",frdImageURL);
            //NSLog(@"%@",uPhoto.photoURL);
            
            if(frdImageURL==nil || ![frdImageURL isEqualToString:uPhoto.photoURL]){//new or has update
                //write new photo's URL to UserInfo.plist;
                [CommonFunctions writeToPlist:LocalImagePlist
                                             :[NSArray arrayWithObject:uPhoto.photoURL]
                                             :[uPhoto.user_id userId]
                 ];
                //write new photo as a file in local directory;
                [CommonFunctions saveImageFromURLToLocal:uPhoto.photoURL :[uPhoto.user_id userId]];
                
                
                //Get the main thread to update the UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.imageView  setImage:[CommonFunctions loadImageFromLocal:[uPhoto.user_id userId]]];
                    
                });
            }
            
            
            
        } else {
            NSLog(@"no photo when downloading photo: %@", errorOrNil);
        }
        
    } withProgressBlock:nil
     ];
    
    
    
    return cell;
}
- (void)checkButtonTapped:(id)sender event:(id)event//clicked accessory button;
{
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: sender] anyObject] locationInView: self.tableView]];
    if ( indexPath == nil ){
        return;
    }
    //trigger the delegate method accessoryButtonTappedForRowWithIndexPath;
    [self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Friendship *aFriend=[appDelegate.fList.inFriends objectAtIndex:indexPath.row];
    
    NSString* friendName=[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSString* title=[@"Reset Permission for " stringByAppendingString:friendName];
    
    NSString* message=[[@"Do you want to reset your permission for " stringByAppendingString:friendName] stringByAppendingString:@"?"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* true_loc = [UIAlertAction
                               actionWithTitle:@"True Loc"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //run after this block is finished;
                                   //                                 dispatch_async(dispatch_get_main_queue(), ^{
                                   //                                     aFriend.permission=[NSNumber numberWithInteger:PermissionForFamily];
                                   //                                 //save permission;
                                   //                                 [friendshipStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                   //                                     if(errorOrNil==nil){
                                   //
                                   //                                         [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text=@"true location";
                                   //
                                   //                                     }
                                   //                                 } withProgressBlock:nil];
                                   //                                 });
                                   
                                   //http://stackoverflow.com/questions/32341851/bsmacherror-xcode-7-beta
                                   aFriend.permission=[NSNumber numberWithInteger:PermissionForFamily];
                                   dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                       [self saveModifiedFriendship:aFriend withIndexPath:indexPath];
                                   });
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    UIAlertAction* cloaked_loc = [UIAlertAction
                                  actionWithTitle:@"Cloaked Loc"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      //run after this block is finished;
                                      //                                dispatch_async(dispatch_get_main_queue(), ^{
                                      //
                                      //                                aFriend.permission=[NSNumber numberWithInteger:PermissionForFriends];
                                      //                                //save permission;
                                      //                                [friendshipStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                      //                                    if(errorOrNil==nil){
                                      //                                        [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text=@"cloaked location";
                                      //
                                      //                                    }
                                      //                                } withProgressBlock:nil];
                                      //                                });
                                      
                                      aFriend.permission=[NSNumber numberWithInteger:PermissionForFriends ];
                                      dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                          [self saveModifiedFriendship:aFriend withIndexPath:indexPath];
                                      });
                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
    
    UIAlertAction* no_loc = [UIAlertAction
                             actionWithTitle:@"No Loc"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //run after this block is finished;
                                 //                                dispatch_async(dispatch_get_main_queue(), ^{
                                 //
                                 //                                aFriend.permission=[NSNumber numberWithInteger:PermissionForFriends];
                                 //                                //save permission;
                                 //                                [friendshipStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                 //                                    if(errorOrNil==nil){
                                 //                                        [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text=@"cloaked location";
                                 //
                                 //                                    }
                                 //                                } withProgressBlock:nil];
                                 //                                });
                                 
                                 aFriend.permission=[NSNumber numberWithInteger:PermissionForNoLoc ];
                                 dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                     [self saveModifiedFriendship:aFriend withIndexPath:indexPath];
                                 });
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    UIAlertAction* unFriend = [UIAlertAction
                               actionWithTitle:@"Remove this friend"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   aFriend.permission=[NSNumber numberWithInteger:PermissionForFriends ];
                                   dispatch_after(0.2, dispatch_get_main_queue(), ^{
                                       [self deleteFriendship:aFriend withIndexPath:indexPath];
                                   });
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:cancel];
    if([[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text isEqualToString:strPermissionTrueLocation]){
        [alert addAction:cloaked_loc];
        [alert addAction:no_loc];
    }
    if([[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text isEqualToString:strPermissionCloakedLocation]){
        [alert addAction:true_loc];
        [alert addAction:no_loc];
    }
    if([[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text isEqualToString:strPermissionNoLocation]){
        [alert addAction:true_loc];
        [alert addAction:cloaked_loc];
    }
    [alert addAction:unFriend];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}


@end
