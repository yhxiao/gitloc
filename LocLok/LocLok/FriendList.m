//
//  FriendList.m
//  LocShare
//
//  Created by yxiao on 1/5/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import "FriendList.h"

@implementation FriendList
@synthesize friends,inFriends,frdLocations,NotifsFromMe,NotifsToMe,NotifsMeeting;
@synthesize frdStore,PhotoStore,LocStore,LokStore,addFriendStore,meetStore;//,myMeetingFriendIndex;

NSString *const fListLoadingCompleteNotification =
@"com.yxiao.friendlistloadingfinished";
NSString* const fListFrdLocationsLoadingCompletetion=
@"com.yxiao.fListFrdLocationsLoadingFinished";

NSString* const realtimelocationUpdateNotification=@"com.yxiao.realtimeLocationUpdateNotification";
NSString *const LocalImagePlist=@"LocalImagePlist.plist";
NSString*  const fromCollection_finished_Notification=@"Notification_query_fromCollection_finished";
NSString* const toCollection_finished_Notification=@"Notification_query_toCollection_finished";
NSString* const meetCollection_finished_Notification=@"Notification_query_meetingCollection_finished";
NSString* const inFriends_finished_Notification=@"Notification_query_frdCollection_inFriends_finished";

-(FriendList*)loadWithID:(NSString*) user_id{
    if(user_id==nil)return nil;
    
    if(PhotoStore==nil){
    PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
            KCSStoreKeyCollectionName : @"UserPhotos",
            KCSStoreKeyCollectionTemplateClass : [User_Photo class],
            KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
    }];
    }
    
    if(frdStore==nil){
    frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
        KCSStoreKeyCollectionName : @"Friendship",
        KCSStoreKeyCollectionTemplateClass : [Friendship class],
        KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
    }];

    }
    //NSLog(@"In friendlist query, the userId is %@",[[KCSUser activeUser] userId]);
    KCSQuery* query1 = [KCSQuery queryOnField:@"from_user._id"
                       withExactMatchForValue:user_id
    ];
    
    
    //the sequence of friend list;
    [query1 addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"to_surname" inDirection:kKCSAscending]];
    [query1 addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"to_givenName" inDirection:kKCSAscending]];
//    NSSortDescriptor *sortName1 = [NSSortDescriptor sortDescriptorWithKey:@"to_surname"
//                                                               ascending:YES
//                                                                //selector:@selector(caseInsensitiveCompare:)
//                                  ];
//    NSSortDescriptor *sortName2 = [NSSortDescriptor sortDescriptorWithKey:@"to_givenName"
//                                                                ascending:YES
//                                                                 //selector:@selector(caseInsensitiveCompare:)
//                                   ];
    
    
    [frdStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil==nil){
            friends=objectsOrNil;
            //friends=[friends sortedArrayUsingSelector:[NSArray arrayWithObjects:sortName1,sortName2,nil]];
            /*friends=[objectsOrNil sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                Friendship *first = (Friendship  *)a;
                Friendship *second = (Friendship  *)b;
                
                return [first.to_user.surname caseInsensitiveCompare:second.to_user.surname]==NSOrderedSame?
                [first.to_user.givenName caseInsensitiveCompare:second.to_user.givenName]
                :[first.to_user.surname caseInsensitiveCompare:second.to_user.surname]
                ;
                
            }
            ];
            */
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
                
                
                [PhotoStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil5) {
                    //NSLog(@"%@",[aFriend.to_user username]);
                    if(errorOrNil5){
                        NSLog(@"PhotoStore: %@",errorOrNil5);
                    }
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
    
    
    
    
    //load self photo;
    KCSQuery* query = [KCSQuery queryOnField:@"user_id._id"
                      withExactMatchForValue:[[KCSUser activeUser] userId]
                       ];
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
    [query addSortModifier:sortByDate]; //sort the return by the date field
    [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    
    
    [PhotoStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil5) {
        //NSLog(@"%@",[aFriend.to_user username]);
        if(errorOrNil5){
            NSLog(@"PhotoStore :   %@",errorOrNil5);
        }
        if (objectsOrNil != nil && [objectsOrNil count]>0) {
            User_Photo * uPhoto=objectsOrNil[0];
            
            //get existing image's URL;
            NSDictionary *temp = [CommonFunctions retrieveFromPlist:LocalImagePlist];
            NSString *frdImageURL =[[temp objectForKey:[[KCSUser activeUser] userId]] objectAtIndex:0];
            
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
        
        
    }withProgressBlock:nil
     ];//PhotoStore;
    
    
    return self;
    
}


-(void)updateLocations{
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
    
    
    for(NSInteger i=0;i<self.friends.count;i++){
        //NSLog(@"Friend Loc: %ld\n",(long)i+1);
            locQuery=[KCSQuery queryOnField:@"owner"
                               withExactMatchForValue:[[[self.friends objectAtIndex:i] to_user] userId]
                                ];
            [locQuery  addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"userDate" inDirection:kKCSDescending]];
            [locQuery  setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
        
        //test
//        KCSQuery* query2 = [KCSQuery queryOnField:@"userDate" usingConditionalsForValues:kKCSGreaterThan, [NSDate dateWithTimeIntervalSinceNow:-2592000], kKCSLessThan, [NSDate date], nil];
//        
//        [query2 addQueryOnField:@"owner" withExactMatchForValue:[[KCSUser activeUser] userId]];
//        
//        [query2 addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"userDate" inDirection:kKCSDescending]];
//        
        MeetEvent* meet1=[[self.friends objectAtIndex:i] meetinglink];
        NSLog(@"%ld",(long)[meet1.MeetEventStatus integerValue]);
        
        //no loc permission;
        if([[[self.friends objectAtIndex:i] permission] integerValue]==PermissionForNoLoc){
            //NSLog(@"i=%ld: %@\n",i,frdLocations);
            [frdLocations replaceObjectAtIndex:i withObject:[NSNull null]];
            //if(i==friends.count-1){
                //should release a message here to notify that friends loading is finished.
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:fListFrdLocationsLoadingCompletetion
                 object:nil
                 ];
            //}
        }
        else{
            if([[[self.friends objectAtIndex:i] permission] integerValue]==PermissionForFamily  || (meet1!=nil && [meet1.MeetEventStatus integerValue]<=MeetEventAgreed && [meet1.MeetEventStatus integerValue]>MeetEventFinished)){//exact precision;
                [LocStore  queryWithQuery:locQuery withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                //[LocStore  queryWithQuery:query2 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    //NSLog(@"%@, i=%d",objectsOrNil,i);
                    if(objectsOrNil!=nil && [objectsOrNil count]>0){
                        //NSLog(@"i=%ld: %@\n",i,frdLocations);
                        [frdLocations replaceObjectAtIndex:i withObject:objectsOrNil[0]];
                    }
                    
                    //if(i==friends.count-1){
                        //should release a message here to notify that friends loading is finished.
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:fListFrdLocationsLoadingCompletetion
                         object:nil
                         ];
                    //}
                    
                }withProgressBlock:nil
                ];
            }
            
            //if(([[[self.friends objectAtIndex:i] permission ] integerValue]==PermissionForFriends && [meet1.MeetEventStatus integerValue]>MeetEventAgreed) || meet1==nil)
            else{//protected precision;
                [LokStore queryWithQuery:locQuery withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    //NSLog(@"%@, i=%d",objectsOrNil,i);
                    if(objectsOrNil!=nil && [objectsOrNil count]>0){
                        //NSLog(@"i=%ld: %@\n",i,frdLocations);
                        [frdLocations replaceObjectAtIndex:i withObject:objectsOrNil[0] ];
                    }
                    
                    //if(i==friends.count-1){
                        //should release a message here to notify that friends loading is finished.
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:fListFrdLocationsLoadingCompletetion
                         object:nil
                         ];
                    //}
                } withProgressBlock:nil
                ];
            }
        }//not no loc;
        
        
        
    }//for loop;
    
    
}



-(void)checkMeetingFriends:(CLLocation*)myLocation{
    if(LocStore==nil){
        LocStore=[KCSAppdataStore storeWithOptions:@{
                                                     KCSStoreKeyCollectionName:@"LocSeries",
                                                     KCSStoreKeyCollectionTemplateClass:[LocSeries class],
                                                     KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)
                                                     }];
    }
    if(meetStore==nil){
    meetStore=
    [KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName:@"MeetEvent",
                                              KCSStoreKeyCollectionTemplateClass:[MeetEvent class],
                                              KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)
                                              }];
    }
    KCSQuery *locQuery;
    
    for(NSInteger i=0;i<self.friends.count;i++){
        Friendship* thisFriend=[self.friends objectAtIndex:i];
        MeetEvent* meet1=thisFriend.meetinglink;
        //for all the meeting friends;
        if(meet1!=nil && [meet1.MeetEventStatus integerValue]<=MeetEventAgreed && [meet1.MeetEventStatus integerValue]>MeetEventFinished){
            locQuery=[KCSQuery queryOnField:@"owner"
                     withExactMatchForValue:[[[self.friends objectAtIndex:i] to_user] userId]
                      ];
            [locQuery  addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"userDate" inDirection:kKCSDescending]];
            [locQuery  setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
            
            [LocStore  queryWithQuery:locQuery withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                
                if(objectsOrNil!=nil && [objectsOrNil count]>0){
                    [frdLocations replaceObjectAtIndex:i withObject:objectsOrNil[0]];
                    LocSeries* meetingfrdLoc=objectsOrNil[0];
                    CLLocationDistance dist=[myLocation distanceFromLocation:[CLLocation locationFromKinveyValue:meetingfrdLoc.location]];
                    //already met; < Meet_meters;
                    if(dist<Meet_meters && [meet1.MeetEventStatus integerValue]>MeetEventFinished && [meet1.MeetEventStatus integerValue]<=MeetEventAgreed){
                        meet1.MeetEventStatus=[NSNumber numberWithInteger:MeetEventFinished];//finished;
                        
                        
                        [meetStore saveObject:meet1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if(errorOrNil!=nil){
                                NSLog(@"check meetings: %@",errorOrNil);
                            }
                        } withProgressBlock:nil];
                        
                    }
                    //nearby;
                    else{ if(dist<Nearby_meters && [meet1.MeetEventStatus integerValue]>MeetEventNearby && [meet1.MeetEventStatus integerValue]<=MeetEventAgreed){
                        meet1.MeetEventStatus=[NSNumber numberWithInteger:MeetEventNearby];
                        
                        [meetStore saveObject:meet1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if(errorOrNil!=nil){
                                NSLog(@"check meetings: %@",errorOrNil);
                            }
                        } withProgressBlock:nil];
                    }
                    //halfway;
                    else{if(dist<[[CLLocation locationFromKinveyValue:meet1.from_location] distanceFromLocation:[CLLocation locationFromKinveyValue:meet1.from_location]]/2 && [meet1.MeetEventStatus integerValue]>MeetEventHalfway && [meet1.MeetEventStatus integerValue]<=MeetEventAgreed){
                        meet1.MeetEventStatus=[NSNumber numberWithInteger:MeetEventHalfway];
                        
                        [meetStore saveObject:meet1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if(errorOrNil!=nil){
                                NSLog(@"check meetings: %@",errorOrNil);
                            }
                        } withProgressBlock:nil];
                        
                    }}}
                }
                else{
                    NSLog(@"check meetings: %@",errorOrNil);
                }
            }withProgressBlock:nil];
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
                        
//                        UIAlertController * alert=   [UIAlertController
//                                                      alertControllerWithTitle:@"Save failed"
//                                                      message:[errorOrNil localizedFailureReason] //not actually localized
//                                                      preferredStyle:UIAlertControllerStyleAlert];
//                        
//                        UIAlertAction* ok = [UIAlertAction
//                                             actionWithTitle:@"OK"
//                                             style:UIAlertActionStyleDefault
//                                             handler:^(UIAlertAction * action)
//                                             {
//                                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                                 
//                                             }];
//                        
//                        [alert addAction:ok];
//                        
//                        [self presentViewController:alert animated:YES completion:nil];
                        NSLog(@"FriendList: save failed.");
                    } else {
                        //save was successful
                        NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                    }
                } withProgressBlock:nil
                ];
                
                
                
                //delete these records because they are done;
                [loadStore removeObject:aFriend withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
                    if(errorOrNil){
                        NSLog(@"check new friends: %@",errorOrNil);
                    }
                    
                }
                      withProgressBlock:nil
                 ];
                
            }
            
            
            
            
            
            
        } else {
            NSLog(@"check new friends: %@",errorOrNil);
        }
        
    } withProgressBlock:nil
     ];
    
    
    
    
}



+(void)AddOneFriend:(KCSUser *)addUser
         Permission:(NSNumber*)perm
         Controller:(id)controller
            Initial:(NSNumber*)initial{
    AddFriends *aFriend=[[AddFriends alloc] init];
    aFriend.to_user=addUser;
    aFriend.from_user=[KCSUser activeUser];
    aFriend.agreed=initial;
    aFriend.finished=[[NSNumber alloc] initWithInt:0];
    aFriend.permission=perm;
    aFriend.date=[NSDate date];
    aFriend.from_givenName=[KCSUser activeUser].givenName;
    aFriend.from_surname=[KCSUser activeUser].surname;
    aFriend.to_givenName=addUser.givenName;
    aFriend.to_surname=addUser.surname;
    
    id<KCSStore> updateStore=[KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"AddFriend",KCSStoreKeyCollectionTemplateClass : [AddFriends class],
                                                                        KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)}
                              ];
    id<KCSStore> friendshipStore=[KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"Friendship",KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                                            KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)}
                                  ];
    
    
    
    
    KCSQuery *query_exist1=[KCSQuery queryOnField:@"from_user._id"
                           withExactMatchForValue:[[KCSUser activeUser] userId]
                            ];
    KCSQuery *query_exist2=[KCSQuery queryOnField:@"to_user._id"
                           withExactMatchForValue:addUser.userId
                            ];
    KCSQuery *query_exist=[KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query_exist1,query_exist2, nil];
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
    [query_exist addSortModifier:sortByDate]; //sort the return by the date field
    [query_exist setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    
    
    NSString *str_Name=  [[addUser.givenName
                           stringByAppendingString:@" "]
                          stringByAppendingString:addUser.surname
                          ];
    
    
    //check if friend request is already in AddFriend;
    [updateStore queryWithQuery:query_exist withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil!=nil){
            NSLog(@"Get an error when checking if a friend request is already in AddFriend: %@",errorOrNil);
        }
        AddFriends* aRequest;
        if(objectsOrNil.count!=0){
            aRequest=objectsOrNil[0];
            
            if([aRequest.permission integerValue]==[perm integerValue]){//request already sent;
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:[[@"Request already sent to "
                                                        stringByAppendingString:str_Name]
                                                       stringByAppendingString:@", Please wait for acceptance."
                                                       ]
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                
                [alert addAction:ok];
                
                [controller presentViewController:alert animated:YES completion:nil];
                return;
                
            }//equal permission
            else{//different permission;
                [updateStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //save failed, show an error alert
                        
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"Save failed"
                                                      message:[errorOrNil localizedFailureReason] //not actually localized
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                        
                        
                        [alert addAction:ok];
                        
                        [controller presentViewController:alert animated:YES completion:nil];
                    } else {
                        //save was successful
                        
                        
                        UIAlertController * alert=   [UIAlertController
                                                      alertControllerWithTitle:@"Request sent"
                                                      message:[[@"Friend request has been sent to "
                                                                stringByAppendingString:str_Name]
                                                               stringByAppendingString:@" . Please wait for acceptance."
                                                               ]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                        
                        [alert addAction:ok];
                        
                        [controller presentViewController:alert animated:YES completion:nil];
                    }
                    return;
                    
                } withProgressBlock:nil
                 ];//save to AddFriend
            }
        }//if count!=0;
        if(objectsOrNil.count==0){// not in AddFriend;
            //check if they are already friends.
            [friendshipStore queryWithQuery:query_exist
                        withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                            if(errorOrNil!=nil){
                                NSLog(@"Got an error AddOneFriend : %@", errorOrNil);
                                
                            }
                            Friendship* aFriendship;
                            if(objectsOrNil.count!=0){
                                aFriendship=objectsOrNil[0];
                            }
                            if(aFriendship!=nil && [aFriendship.permission integerValue]==[perm integerValue]){//request already exists;
                                
                                UIAlertController * alert=   [UIAlertController
                                                              alertControllerWithTitle:@""
                                                              message:[[[[@"You and "
                                                                          stringByAppendingString:str_Name]
                                                                         stringByAppendingString:@" are already friends with "]
                                                                        stringByAppendingString:[perm integerValue]==PermissionForFamily?@"\"True Loc\"":@"\"Cloaked Loc\"" ]
                                                                       stringByAppendingString:@" permission."
                                                                       ]
                                                              preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction* ok = [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                                                     {
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                         
                                                     }];
                                
                                [alert addAction:ok];
                                
                                [controller presentViewController:alert animated:YES completion:nil];
                                
                                
                                return;
                            }
                            else{//send the request;
                                
                                
                                
                                
                                
                                [updateStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                    if (errorOrNil != nil) {
                                        //save failed, show an error alert
                                        
                                        UIAlertController * alert=   [UIAlertController
                                                                      alertControllerWithTitle:@"Save failed"
                                                                      message:[errorOrNil localizedFailureReason] //not actually localized
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction* ok = [UIAlertAction
                                                             actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                                             {
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 
                                                             }];
                                        
                                        
                                        [alert addAction:ok];
                                        
                                        [controller presentViewController:alert animated:YES completion:nil];
                                    } else {
                                        //save was successful
                                        
                                        
                                        UIAlertController * alert=   [UIAlertController
                                                                      alertControllerWithTitle:@"Request sent"
                                                                      message:[[@"Friend request has been sent to "
                                                                                stringByAppendingString:str_Name]
                                                                               stringByAppendingString:@" . Please wait for acceptance."
                                                                               ]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction* ok = [UIAlertAction
                                                             actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                                             {
                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                                 
                                                             }];
                                        
                                        [alert addAction:ok];
                                        
                                        [controller presentViewController:alert animated:YES completion:nil];
                                    }
                                    return;
                                    
                                } withProgressBlock:nil
                                 ];//save to AddFriend
                                
                            }
                            
                            
                        } withProgressBlock:nil
             ];//is in Friendship
            
            
        }//if count==0;
        
    } withProgressBlock:nil
     ];//is in AddFriend;
    
    
}




-(void)searchNotifInAddFriends{
    
    if(addFriendStore==nil){
        addFriendStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                            KCSStoreKeyCollectionName : @"AddFriend",
                                                            KCSStoreKeyCollectionTemplateClass : [AddFriends class],
                                                            KCSStoreKeyCachePolicy : @(KCSCachePolicyNone)
                                                            }];
    }
//    if(frdStore==nil){
//        frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
//                                                           KCSStoreKeyCollectionName : @"Friendship",
//                                                           KCSStoreKeyCollectionTemplateClass : [Friendship class],
//                                                           KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
//                                                           }];
//    }
    
    
    NSString* myId = [KCSUser activeUser].userId;
    

    KCSQuery* queryfrom = [KCSQuery queryOnField:@"from_user._id"
                      withExactMatchForValue:myId
                       ];
    
    //[queryfrom addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    [queryfrom addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending]];
    [addFriendStore  queryWithQuery:queryfrom withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        
        
        if (errorOrNil == nil) {
            
            //load is successful!
            NotifsFromMe=objectsOrNil;
            
            void (^block_after_assign)(NSArray *assigned_array)=^(NSArray *assigned_array){
                NSLog(@"%@",NotifsFromMe);
                [[NSNotificationCenter defaultCenter] postNotificationName:fromCollection_finished_Notification
                                                                    object:nil
                 ];
                //return;
            };
            //dispatch_async(dispatch_queue_create("com.kinvey.lotsofwork", NULL), ^{
                block_after_assign(NotifsFromMe);
            //});
            
            
            
        }
        else{
            NSLog(@"when searchNotifInAddFriends: %@",errorOrNil);
        }
        NSLog(@"finished notif query 1");
    } withProgressBlock:nil
     //^(NSArray *objects, double percentComplete){
     //   [spinner startAnimating];}
     ];
 
    
    
    KCSQuery* queryto = [KCSQuery queryOnField:@"to_user._id"
            withExactMatchForValue:myId
             ];
    
    //[queryto addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    [queryto addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending]];
    [addFriendStore queryWithQuery:queryto withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        
        if (errorOrNil == nil) {
            //load is successful!
            
            NotifsToMe=objectsOrNil;
            
            
            void (^block_after_assign)(NSArray *assigned_array)=^(NSArray *assigned_array){
                NSLog(@"%@",NotifsToMe);
                [[NSNotificationCenter defaultCenter] postNotificationName:toCollection_finished_Notification
                                                                    object:nil
                 ];
                //    return;
            };
            //dispatch_async(dispatch_queue_create("com.kinvey.lotsofwork", NULL), ^{
                block_after_assign(NotifsToMe);
            //});
            //block_after_assign(NotifsToMe);
            
        }
        else{
            NSLog(@"when searchNotifInAddFriends: %@",errorOrNil);
        }
        NSLog(@"finished notif query 2");

    } withProgressBlock:nil];
    
    
}


-(void)searchNotifAboutMeetings{
    if(meetStore==nil){
        meetStore=
        [KCSLinkedAppdataStore storeWithOptions:@{KCSStoreKeyCollectionName:@"MeetEvent",
                                                  KCSStoreKeyCollectionTemplateClass:[MeetEvent class],
                                                  KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)
                                                  }];
    }
    
    KCSQuery* query1 = [KCSQuery queryOnField:@"from_user._id"
                       withExactMatchForValue:[[KCSUser activeUser] userId]
                        ];
    KCSQuery *query2=[KCSQuery queryOnField:@"to_user._id"
                     withExactMatchForValue:[[KCSUser activeUser] userId]
                      ];
    KCSQuery *query3=[KCSQuery queryOnField:@"status"
                 usingConditionalsForValues:kKCSGreaterThan, [NSNumber numberWithInteger:MeetEventFinished], kKCSLessThan, [NSNumber numberWithInteger:MeetEventDeclined], nil];
    //KCSQuery *query3=[KCSQuery queryOnField:@"MeetEventStatus"
    //                  usingConditional:kKCSIn forValue:@[@"1",@"2",@"3",@"4",@"5"]
    //                  ];
    KCSQuery *query=[KCSQuery queryForJoiningOperator:kKCSOr onQueries:query1,query2,nil ];
    [query addQuery:query3 ];
    
    [query addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    [meetStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil==nil){
            NotifsMeeting=objectsOrNil;
            void (^block_after_assign)(NSArray *assigned_array)=^(NSArray *assigned_array){
                NSLog(@"%@",NotifsMeeting);
                [[NSNotificationCenter defaultCenter] postNotificationName:meetCollection_finished_Notification
                                                                    object:nil
                 ];
                //    return;
            };
            //dispatch_async(dispatch_queue_create("com.kinvey.lotsofwork", NULL), ^{
            block_after_assign(NotifsMeeting);
            
        }
        else{
            NSLog(@"when searching meeting events: %@",errorOrNil);
        }
    } withProgressBlock:nil];
    
}



-(void)searchFriendsHavingMyPermissions{
    if(frdStore==nil){
        frdStore=[KCSLinkedAppdataStore storeWithOptions:@{
                                                           KCSStoreKeyCollectionName : @"Friendship",
                                                           KCSStoreKeyCollectionTemplateClass : [Friendship class],
                                                           KCSStoreKeyCachePolicy:@(KCSCachePolicyLocalFirst)
                                                           }];
        
    }
    //NSLog(@"In friendlist query, the userId is %@",[[KCSUser activeUser] userId]);
    KCSQuery* query1 = [KCSQuery queryOnField:@"to_user._id"
                       withExactMatchForValue:[KCSUser activeUser].userId
                        ];
    
    [query1 addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"from_surname" inDirection:kKCSAscending]];
    [query1 addSortModifier:[[KCSQuerySortModifier alloc] initWithField:@"from_givenName" inDirection:kKCSAscending]];
    
    [frdStore queryWithQuery:query1 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if(errorOrNil==nil){
            inFriends=objectsOrNil;
            void (^block_after_assign)(NSArray *assigned_array)=^(NSArray *assigned_array){
                NSLog(@"%@",inFriends);
                [[NSNotificationCenter defaultCenter] postNotificationName:inFriends_finished_Notification
                                                                    object:nil
                 ];
                //    return;
            };
            //dispatch_async(dispatch_queue_create("com.kinvey.lotsofwork", NULL), ^{
            block_after_assign(inFriends);
        }
        else{
            NSLog(@"when loading friends having my permission: %@",errorOrNil);
        }
    }withProgressBlock:nil];
    
    
}

@end
