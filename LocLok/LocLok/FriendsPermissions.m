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

@implementation FriendsPermissions


@synthesize Frdshp2me;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.cellFont=[ UIFont fontWithName: @"Arial" size: 14 ];
    self.cellFont2=[ UIFont fontWithName: @"Arial" size: 10 ];
    
    
    id<KCSStore> PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                         KCSStoreKeyCollectionName : @"UserPhotos",
                                                         KCSStoreKeyCollectionTemplateClass : [User_Photo class],
                                                         KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
                                                         }];
    
    id<KCSStore> frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                       KCSStoreKeyCollectionName : @"Friendship",
                                                       KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                       KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
                                                       }];
    
    //NSLog(@"In friendlist query, the userId is %@",[[KCSUser activeUser] userId]);
    KCSQuery* query1 = [KCSQuery queryOnField:@"to_user._id"
                       withExactMatchForValue:[[KCSUser activeUser] userId]
                        ];
    
    
    
    
}



@end
