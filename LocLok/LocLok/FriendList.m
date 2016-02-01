//
//  FriendList.m
//  LocShare
//
//  Created by yxiao on 1/5/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import "FriendList.h"

@implementation FriendList
@synthesize friends,frdLocations;
@synthesize frdStore,PhotoStore,LocStore,LokStore;

NSString *const fListLoadingCompleteNotification =
@"com.yxiao.friendlistloadingfinished";

NSString* const realtimelocationUpdateNotification=@"com.yxiao.realtimeLocationUpdateNotification";
NSString *const LocalImagePlist=@"LocalImagePlist.plist";

-(FriendList*)loadWithID:(NSString*) user_id{
    if(user_id==nil)return nil;
    
    PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
            KCSStoreKeyCollectionName : @"UserPhotos",
            KCSStoreKeyCollectionTemplateClass : [User_Photo class],
            KCSStoreKeyCachePolicy : @(KCSCachePolicyNone)
    }];
    
    frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
        KCSStoreKeyCollectionName : @"Friendship",
        KCSStoreKeyCollectionTemplateClass : [Friendship class],
        KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
    }];

    //NSLog(@"In friendlist query, the userId is %@",[[KCSUser activeUser] userId]);
    KCSQuery* query1 = [KCSQuery queryOnField:@"from_user._id"
                       withExactMatchForValue:user_id
    ];
    
    
    //the sequence of friend list;
    [query1 addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"to_user.surname" inDirection:kKCSAscending]];
    
    
    [frdStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil==nil){
            friends=objectsOrNil;
            
            for(int i=0;i<friends.count;i++){
                Friendship *aFriend=[friends objectAtIndex:i];
                
                /*Cannot get from KCSFile Store because one cannot access other's files even if it is public
                 08-09-2015 YXiao
                 
                 KCSQuery* query = [KCSQuery queryOnField:KCSFileFileName
                                  withExactMatchForValue:[[aFriend.to_user username] stringByAppendingString:@".png"]
                                   ];
                //KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"_metadata._creationTime" inDirection:kKCSDescending];
                //KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"_kmd.ect" inDirection:kKCSDescending];
                //[query addSortModifier:sortByDate]; //sort the return by the date field
                //[query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
                //[KCSFileStore downloadFileByQuery:query completionBlock:^(NSArray *downloadedResources, NSError *error) {
                [KCSFileStore downloadFileByName:[[aFriend.to_user username] stringByAppendingString:@".png"] completionBlock:^(NSArray *downloadedResources, NSError *error) {
                    if (error == nil) {
                        NSLog(@"Downloaded %i images for %@.", downloadedResources.count,[[aFriend.to_user username] stringByAppendingString:@".png"]);
                    } else {
                        NSLog(@"Got an error: %@", error);
                    }
                } progressBlock:nil];
                 */
                
                
                KCSQuery* query = [KCSQuery queryOnField:@"user_id._id"
                                  withExactMatchForValue:[aFriend.to_user userId]
                ];
                KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
                [query addSortModifier:sortByDate]; //sort the return by the date field
                [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
                
                
                [PhotoStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    //NSLog(@"%@",[aFriend.to_user username]);
                    if (objectsOrNil != nil && [objectsOrNil count]>0) {
                        User_Photo * uPhoto=objectsOrNil[0];
                        
                        //get existing image's URL;
                        NSDictionary *temp = [CommonFunctions retrieveFromPlist:LocalImagePlist];
                        NSString *frdImageURL =[[temp objectForKey:[uPhoto.user_id userId]] objectAtIndex:0];
                        
                        if(frdImageURL==nil || ![frdImageURL isEqualToString:uPhoto.photoURL]){//new or has update
                            //write new photo's URL to UserInfo.plist;
                            [CommonFunctions writeToPlist:LocalImagePlist
                                                         :[NSArray arrayWithObject:uPhoto.photoURL]
                                                         :[uPhoto.user_id userId]
                             ];
                            //write new photo as a file in local directory;
                            [CommonFunctions saveImageFromURLToLocal:uPhoto.photoURL :[uPhoto.user_id userId]];
                            
                            //test
                            //UIImage* img=[CommonFunctions loadImageFromLocal:[uPhoto.user_id userId]];
                            //NSLog(@"%@",[CommonFunctions retrieveFromPlist:LocalImagePlist]);
                        }
                        
                    }
                    
                    if(i==friends.count-1){
                        //should release a message here to notify that friends loading is finished.
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:fListLoadingCompleteNotification
                         object:nil
                         ];
                    }
                    
                    
                 }withProgressBlock:nil
                 ];//PhotoStore;
                
                
                
                
                
                
                
            }//for loop
            
            
            
            if(frdLocations==nil || frdLocations.count!=friends.count){
                frdLocations=[NSMutableArray arrayWithCapacity: friends.count] ;
                for(int i=0;i<friends.count;i++){
                    [frdLocations addObject:[NSNull null]];
                }
            }
            
            
            
            
            
        }else{
            NSLog(@"when loading friendlist, error occurred: %@",errorOrNil);
            
        }//if error=nil block
        
        
    } withProgressBlock:nil
    ];
    
    
    
    
    
    return self;
    
}


-(void)updateLocations{
    if(LocStore==nil)
    LocStore=[KCSAppdataStore storeWithOptions:@{
                                                 KCSStoreKeyCollectionName:@"LocSeries",
                                                 KCSStoreKeyCollectionTemplateClass:[LocSeries class],
                                                 KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
                                                 }];
    if(LokStore==nil)
    LokStore=[KCSAppdataStore storeWithOptions:@{
                                                 KCSStoreKeyCollectionName:@"LokSeries",
                                                 KCSStoreKeyCollectionTemplateClass:[LocSeries class],
                                                 KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
                                                 }];
    
    //NSLog(@"%d",PermissionForFriends);
    //NSLog(@"%d",PermissionForFamily);
    KCSQuery *locQuery;
    //if(frdLocations!=nil)[frdLocations removeAllObjects];
    
    for(int i=0;i<self.friends.count;i++){
            locQuery=[KCSQuery queryOnField:@"owner"
                               withExactMatchForValue:[[[self.friends objectAtIndex:i] to_user] userId]
                                ];
            [locQuery  addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"userDate" inDirection:kKCSDescending]];
            [locQuery  setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
            
            if([[[self.friends objectAtIndex:i] permission] integerValue]==PermissionForFamily){//exact precision;
                [LocStore  queryWithQuery:locQuery withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    //NSLog(@"%@, i=%d",objectsOrNil,i);
                    if(objectsOrNil!=nil && [objectsOrNil count]>0){
                        [frdLocations replaceObjectAtIndex:i withObject:objectsOrNil[0]];
                    }
                    
                    if(i==friends.count-1){
                        //should release a message here to notify that friends loading is finished.
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:realtimelocationUpdateNotification
                         object:nil
                         ];
                    }
                    
                }withProgressBlock:nil
                ];
            }
            
            if([[[self.friends objectAtIndex:i] permission ] integerValue]==PermissionForFriends){//protected precision;
                [LokStore queryWithQuery:locQuery withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    //NSLog(@"%@, i=%d",objectsOrNil,i);
                    if(objectsOrNil!=nil && [objectsOrNil count]>0){
                        [frdLocations replaceObjectAtIndex:i withObject:objectsOrNil[0] ];
                    }
                    
                    if(i==friends.count-1){
                        //should release a message here to notify that friends loading is finished.
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:realtimelocationUpdateNotification
                         object:nil
                         ];
                    }
                } withProgressBlock:nil
                ];
            }
    }
    
    
}



+(void)checkNewFriend{
    id<KCSStore> loadStore;
    KCSCollection* collection = [KCSCollection collectionFromString:@"AddFriend"
                                                            ofClass:[AddFriends class]
                                 ];
    loadStore = [KCSAppdataStore storeWithCollection:collection
                                             options:@{KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)}
                 ];
    
    KCSQuery* query1 = [KCSQuery queryOnField:@"from_user._id"
                      withExactMatchForValue:[[KCSUser activeUser] userId]
                       ];
    KCSQuery *query2=[KCSQuery queryOnField:@"agreed"
                    withExactMatchForValue:[NSNumber numberWithInt:1]
                     ];
    KCSQuery *query=[KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query1,query2,nil ];
    
    [query addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    __block NSArray* newFriends=[NSArray alloc];
    
    KCSCollection *collection_friendship=[KCSCollection collectionFromString:@"Friendship"
                                                                     ofClass:[Friendship class]
                                          ];
    __block id<KCSStore> friendship_store=[KCSAppdataStore storeWithCollection:collection_friendship
                                                                       options:@{KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)}
                                           ];
    
    [loadStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (errorOrNil == nil && objectsOrNil != nil) {
            //load is successful!
            newFriends=objectsOrNil;
            NSLog(@"%@",newFriends);
            
            //add new friends to Friendship here;
            AddFriends *aFriend;
            for(aFriend in newFriends){
                Friendship *newFriendship=[Friendship alloc];
                newFriendship.from_user=aFriend.from_user;
                newFriendship.to_user=aFriend.to_user;
                newFriendship.permission=[NSNumber numberWithInt:10];/////////10 means public permission;
                newFriendship.shownColor=[NSNumber numberWithInt:0];//default color;
                
                [friendship_store saveObject:newFriendship withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //save failed, show an error alert
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Save failed", @"Save Failed")
                                                                            message:[errorOrNil localizedFailureReason] //not actually localized
                                                                           delegate:nil
                                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    } else {
                        //save was successful
                        NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                    }
                } withProgressBlock:nil
                ];
                
                
                
                //delete these records because they are done;
                [loadStore removeObject:aFriend withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
                    
                    
                }
                      withProgressBlock:nil
                 ];
                
            }
            
            
            
            
            
            
        } else {
        }
        
    } withProgressBlock:nil
     ];
    
    
    
    
}


@end
