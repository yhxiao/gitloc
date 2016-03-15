//
//  FriendsPermissions.h
//  LocLok
//
//  Created by yxiao on 3/5/16.
//  Copyright © 2016 Yonghui Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FriendsPermissions : UITableViewController

//@property (nonatomic,strong) NSArray* Frdshp2me;//friendship to me;

@property (nonatomic,strong) id<KCSStore> PhotoStore;
@property (nonatomic,strong) id<KCSStore> friendshipStore;


-(void)saveModifiedFriendship:(Friendship *)aFriend
                             withIndexPath:(NSIndexPath *)indexPath;
-(void)deleteFriendship:(Friendship *)aFriend
          withIndexPath:(NSIndexPath *)indexPath;
- (void)queriesFinished:(NSNotification *)notification;
@end
