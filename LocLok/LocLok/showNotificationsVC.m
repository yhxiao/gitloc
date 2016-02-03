//
//  showNotificationsVC.m
//  LocShare
//
//  Created by yxiao on 1/4/14.
//  Copyright (c) 2014 Yonghui Xiao. All rights reserved.
//

#import "showNotificationsVC.h"

@interface showNotificationsVC ()
@property (nonatomic, retain) id<KCSStore> loadStore;
@property (nonatomic, retain) id<KCSStore> PhotoStore;
@property (nonatomic, retain) id<KCSStore> friendshipStore;
//@property (nonatomic, retain) id<KCSStore> sendStore;
//@property (nonatomic, retain) id<KCSStore> userStore;

@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;//not sure how to use
@property (nonatomic, strong) UIRefreshControl *notifRefresh;

@property (nonatomic, retain) NSMutableArray* fromCollection;//add friends requests from me;
@property (nonatomic, retain) NSMutableArray* toCollection;// add friends requests to me;
@property (nonatomic,strong) NSNumber* finishedQueries;
@property (nonatomic,strong) AddFriends *oneFriend;
//@property (nonatomic,strong) dispatch_queue_t serialQueue;//make sure tasks are executed one by one in sequence;

@end

NSString*  fromCollection_finished_Notification=@"Notification_query_fromCollection_finished";
NSString* toCollection_finished_Notification=@"Notification_query_toCollection_finished";
extern NSString* LocalImagePlist;

@implementation showNotificationsVC
@synthesize loadStore,PhotoStore,friendshipStore,fromCollection,toCollection;//,sendStore,userStore;
@synthesize notifTable,spinner;
@synthesize finishedQueries,oneFriend;
//@synthesize serialQueue;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)queriesFinished:(NSNotification *)notification {
    self.finishedQueries =[NSNumber numberWithInt:[self.finishedQueries intValue]+1];
    
    //NSLog(@"%@",self.finishedQueries);
    
    if([self.finishedQueries isEqual:[NSNumber numberWithInt:2]]){
        //NSLog(@"%d",fromCollection.count);
        [spinner stopAnimating];
        
        
        self.notifTable.hidden=NO;
        //self.resultTable.=bgColor;
        self.notifTable.delegate=self;
        self.notifTable.dataSource=self;
        
        self.finishedQueries=[NSNumber numberWithInt:0];
        [self.notifTable reloadData];
        [self.notifRefresh endRefreshing];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    
    UIScrollView* scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    
    int width=self.view.bounds.size.width;
    int height=self.view.bounds.size.height;
    scrollView.contentSize=CGSizeMake(width,height);
    scrollView.backgroundColor=[UIColor whiteColor];
    
    self.view=scrollView;
    
//    KCSCollection* collection = [KCSCollection collectionFromString:@"AddFriend"
//                                                            ofClass:[AddFriends class]
//                                 ];
//    loadStore = [KCSLinkedAppdataStore storeWithCollection:collection
//                                             options:@{KCSStoreKeyCachePolicy : @(KCSCachePolicyLocalFirst)}
//                 ];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    
    loadStore=[KCSLinkedAppdataStore storeWithOptions:@{
        KCSStoreKeyCollectionName : @"AddFriend",
        KCSStoreKeyCollectionTemplateClass : [AddFriends class],
        KCSStoreKeyCachePolicy : @(KCSCachePolicyNone)
        }];
    PhotoStore=[KCSLinkedAppdataStore storeWithOptions:@{
        KCSStoreKeyCollectionName : @"UserPhotos",
        KCSStoreKeyCollectionTemplateClass : [User_Photo class]
        ,KCSStoreKeyCachePolicy:@(KCSCachePolicyNone)
       }];
    friendshipStore=[KCSLinkedAppdataStore storeWithOptions:@{
        KCSStoreKeyCollectionName : @"Friendship",
        KCSStoreKeyCollectionTemplateClass : [Friendship class]
        ,KCSStoreKeyCachePolicy:@(KCSCachePolicyNone)
        }];
    
    
    
    /*
     KCSCollection* collection1 = [KCSCollection collectionFromString:@"Friendship"
                                                             ofClass:[Friendship class]
                                 ];
    sendStore = [KCSLinkedAppdataStore storeWithCollection:collection1
                                             options:@{KCSStoreKeyCachePolicy : @(KCSCachePolicyNone)
                                                       }
                 ];
    
    KCSCollection* collection2 = [KCSCollection collectionFromString:KCSUserCollectionName
                                                             ofClass:[KCSUser class]
                                  ];
    userStore = [KCSAppdataStore storeWithCollection:collection2
                                             options:@{KCSStoreKeyCachePolicy : @(KCSCachePolicyNone)}];
    */
    
//    loadStore=[KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyCollectionName : @"AddFriend",KCSStoreKeyCollectionTemplateClass : [AddFriends class]
//                                                              }
//               ];
    
    
    self.notifTable=[[UITableView alloc] init];
    self.notifTable.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    //self.notifTable.style=UITableViewStylePlain;
    
    //self.notifTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.notifTable ];
    
    
    self.notifRefresh = [[UIRefreshControl alloc] init];
    self.notifRefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [self.notifRefresh addTarget:self action:@selector(searchNotif)
                forControlEvents:UIControlEventValueChanged
     ];
    
    [self.view addSubview:self.notifRefresh];
    
    
    
    
}



-(void)searchNotif{
    NSString* myId = [KCSUser activeUser].userId;
    
    
    KCSQuery* query = [KCSQuery queryOnField:@"from_user._id"
                      withExactMatchForValue:[[KCSUser activeUser] userId]
                       ];
    
    [query addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    [loadStore  queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        
        if (errorOrNil == nil) {
            
            //load is successful!
                fromCollection=objectsOrNil;
            
            void (^block_after_assign)(NSArray *assigned_array)=^(NSArray *assigned_array){
                NSLog(@"%@",fromCollection);
            //show in table (Notifications from me);
                [[NSNotificationCenter defaultCenter] postNotificationName:fromCollection_finished_Notification
                                                                    object:fromCollection
                 ];
            };
            block_after_assign(fromCollection);
            
            
            
        } else {
        }
        
    } withProgressBlock:^(NSArray *objects, double percentComplete){
        [spinner startAnimating];
    }];
    
    
    
    query = [KCSQuery queryOnField:@"to_user._id"
            withExactMatchForValue:myId
             ];
    
    [query addSortModifier:[[KCSQuerySortModifier alloc] initWithField:KCSMetadataFieldLastModifiedTime inDirection:kKCSDescending]];
    
    [loadStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        
        if (errorOrNil == nil) {
            //load is successful!
            
                toCollection=objectsOrNil;
            
            
            void (^block_after_assign)(NSArray *assigned_array)=^(NSArray *assigned_array){
                NSLog(@"%@",toCollection);
            //show in table (Notifications to me);
                [[NSNotificationCenter defaultCenter] postNotificationName:toCollection_finished_Notification
                                                                object:toCollection
                 ];
            };
            
            block_after_assign(toCollection);
            
        } else {
        }
        
    } withProgressBlock:nil];
    
    
}


-(void) viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
    //serialQueue = dispatch_queue_create("com.yxiao.queue.serial", DISPATCH_QUEUE_SERIAL);
    
    self.oneFriend=[[AddFriends alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queriesFinished:)
                                                 name:fromCollection_finished_Notification
                                               object:nil
     ];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(queriesFinished:)
                                                 name:toCollection_finished_Notification
                                               object:nil
     ];
    
    [spinner startAnimating];
    finishedQueries=[NSNumber numberWithInt:0];
    [self searchNotif];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //dispatch_release(serialQueue);
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:fromCollection_finished_Notification
     object:nil
     ];
     
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:toCollection_finished_Notification
     object:nil
     ];
    
    self.oneFriend=nil;
    fromCollection=nil;
    toCollection=nil;
    //self.view=nil;
    finishedQueries=[NSNumber numberWithInt:0];
    //self.notifTable.hidden=YES;
}









#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//From me and to me;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section==0){
        return toCollection.count;
    }
    if(section==1){
        return fromCollection.count;
    }
    else{
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return [NSString stringWithFormat: @"%lu requests sent to me",(unsigned long)toCollection.count];
        
    }
    if(section==1){
        return [NSString stringWithFormat: @"%lu requests sent from me",(unsigned long)fromCollection.count];
        
    }
    else{return 0;}
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotifTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    KCSQuery* query4;
    UIImage* pImage;
    //__block NSString* userName1=[NSString alloc ];
    //the text
    if(indexPath.section==0){//toCollection;
        cell.textLabel.text = [[[[[[toCollection objectAtIndex:indexPath.row] from_user] givenName]
                                                             stringByAppendingString:@" "]
                                                            stringByAppendingString:[[[toCollection objectAtIndex:indexPath.row] from_user] surname]]
                                                                     stringByAppendingString:@" wants to add you as a friend."
                                                            ];
        cell.detailTextLabel.text = [[[toCollection objectAtIndex:indexPath.row] from_user] username];
        
        //for image;
        
        query4 = [KCSQuery queryOnField:@"user_id._id"
                          withExactMatchForValue:[[[toCollection objectAtIndex:indexPath.row] from_user] userId]
        ];
        pImage=[CommonFunctions loadImageFromLocal:[[[toCollection objectAtIndex:indexPath.row] from_user] userId]];
        //NSLog(@"%@",[[[toCollection objectAtIndex:indexPath.row] from_user] userId]);
        
    }
    
    if(indexPath.section==1){//fromCollection;
        NSString *str1=@"Request sent to ";
        /*cell.textLabel.text = [str1
                               stringByAppendingString:
                               [[[fromCollection objectAtIndex:indexPath.row] to_user] givenName]
                               ];
         */
        cell.textLabel.text = [str1
                               stringByAppendingString:
                               
                               [
                                 [
                                  [[[fromCollection objectAtIndex:indexPath.row] to_user] givenName]
                                  stringByAppendingString:@" "
                                 ]
                               
                                stringByAppendingString:
                                 [[[fromCollection objectAtIndex:indexPath.row] to_user ] surname]
                                ]
                               
                              ];
        
        cell.detailTextLabel.text = [[[fromCollection objectAtIndex:indexPath.row] to_user] username];
        
        
        query4 = [KCSQuery queryOnField:@"user_id._id"
                 withExactMatchForValue:[[[fromCollection objectAtIndex:indexPath.row] to_user] userId]
                  ];
        pImage=[CommonFunctions loadImageFromLocal:[[[fromCollection objectAtIndex:indexPath.row] to_user] userId]];
        //NSLog(@"%@",[[[fromCollection objectAtIndex:indexPath.row] to_user] userId]);
    }
    
    KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"date" inDirection:kKCSDescending];
    [query4 addSortModifier:sortByDate]; //sort the return by the date field
    [query4 setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]];
    
        
        //NSLog(@"%@",[(NSDictionary*)[[fromCollection objectAtIndex:indexPath.row] to_user] objectForKey: @"_id"]);
        
//        KCSQuery* query = [KCSQuery queryOnField:@"_id"
//                          withExactMatchForValue:[(NSDictionary*)[[fromCollection objectAtIndex:indexPath.row] to_user] objectForKey: @"_id"]
//                           ];
//        
//        [userStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//            cell.textLabel.text = [[[[[objectsOrNil objectAtIndex:0] givenName]
//                                     stringByAppendingString:@" "]
//                                    stringByAppendingString:[[objectsOrNil objectAtIndex:0] surname]]
//                                   stringByAppendingString:@" was notified to accept me as a friend."
//                                   ];
//            cell.detailTextLabel.text = [[objectsOrNil objectAtIndex:0] username];
//            
//            NSString* userName1=[[NSString alloc ]  initWithString:[[objectsOrNil objectAtIndex:0] username]];
//            
//            
//            //NSLog(@"%@",[[[self.searchResult objectAtIndex:indexPath.row] username] lowercaseString]);
//            KCSQuery* pngQuery = [KCSQuery queryOnField:KCSFileFileName withExactMatchForValue:
//                                  [userName1 stringByAppendingString:@".png"]
//                                  ];
//            NSLog(@"%@",userName1);
//            //[self.activityIndicator startAnimating];
//            [KCSFileStore downloadFileByQuery:pngQuery completionBlock:^(NSArray *downloadedResources, NSError *error) {
//                if (error == nil && downloadedResources.count>0) {
//                    //if(downloadedResources.count>0){
//                    //profileImage=[UIImage imageWithData:[downloadedResources objectAtIndex:0].data];
//                    //profileURL=[[downloadedResources objectAtIndex:0] remoteURL];
//                    KCSFile* file = [downloadedResources objectAtIndex:0];
//                    NSURL* fileURL = file.localURL;
//                    UIImage* image1 = [UIImage imageWithContentsOfFile:[fileURL path]]; //note this blocks for awhile
//                    
//                    //placeholder image while loading;
//                    [cell.imageView  setImage:[UIImage imageNamed:@"profile_default.png"]];
//                    
//                    //Get the main thread to update the UI
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [cell.imageView  setImage:image1];
//                        
//                    });
//                    
//                    
//                } else {
//                    NSLog(@"Got an error: %@", error);
//                }
//            } progressBlock:nil];
//            
//            
//        } withProgressBlock:nil
//         ];
        
    
    
    //placeholder image while loading;
    
    [cell.imageView  setImage:pImage==nil?[UIImage imageNamed:@"profile_default.png"]:pImage];
    cell.imageView.layer.cornerRadius=4;
    cell.imageView.layer.masksToBounds = YES;
    
	
    
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
    
    
    
    
    
    
    
    
    //        KCSQuery* query = [KCSQuery queryOnField:@"_id"
    //                          withExactMatchForValue:[(NSDictionary*)[[toCollection objectAtIndex:indexPath.row] from_user] objectForKey: @"_id"]
    //                           ];
    //
    //        [userStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
    //            cell.textLabel.text = [[[[[objectsOrNil objectAtIndex:0] givenName]
    //                            stringByAppendingString:@" "]
    //                           stringByAppendingString:[[objectsOrNil objectAtIndex:0] surname]]
    //                                    stringByAppendingString:@" wants to add you as a friend."
    //                           ];
    //            cell.detailTextLabel.text = [[objectsOrNil objectAtIndex:0] username];
    //
    //            NSString* userName1=[[NSString alloc ]  initWithString:[[objectsOrNil objectAtIndex:0] username]];
    //
    //
    //            //NSLog(@"%@",[[[self.searchResult objectAtIndex:indexPath.row] username] lowercaseString]);
    //            KCSQuery* pngQuery = [KCSQuery queryOnField:KCSFileFileName withExactMatchForValue:
    //                                  [userName1 stringByAppendingString:@".png"]
    //                                  ];
    //
    //            //[self.activityIndicator startAnimating];
    //            [KCSFileStore downloadFileByQuery:pngQuery completionBlock:^(NSArray *downloadedResources, NSError *error) {
    //                if (error == nil && downloadedResources.count>0) {
    //                    //if(downloadedResources.count>0){
    //                    //profileImage=[UIImage imageWithData:[downloadedResources objectAtIndex:0].data];
    //                    //profileURL=[[downloadedResources objectAtIndex:0] remoteURL];
    //                    KCSFile* file = [downloadedResources objectAtIndex:0];
    //                    NSURL* fileURL = file.localURL;
    //                    UIImage* image1 = [UIImage imageWithContentsOfFile:[fileURL path]]; //note this blocks for awhile
    //
    //                    //placeholder image while loading;
    //                    [cell.imageView  setImage:[UIImage imageNamed:@"profile_default.png"]];
    //
    //                    //Get the main thread to update the UI
    //                    dispatch_async(dispatch_get_main_queue(), ^{
    //                        [cell.imageView  setImage:image1];
    //
    //                    });
    //
    //
    //                } else {
    //                    NSLog(@"Got an error: %@", error);
    //                }
    //            } progressBlock:nil];
    //
    //        } withProgressBlock:nil
    //         ];
    
    
    
    //The icon on the right side of a row;
	//cell.accessoryType = UITableViewCellAccessoryNone;
    UIImage *image =  [UIImage imageNamed:@"icon_cell_add60.png"] ;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
    
    
    
    
    
    
    
    return cell;
}
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.notifTable];
    NSIndexPath *indexPath = [self.notifTable indexPathForRowAtPoint: currentTouchPosition];
    
    
    if (indexPath != nil)
    {
        //[self tableView: self.notifTable accessoryButtonTappedForRowWithIndexPath: indexPath];
        if(indexPath.section==0){//request;
            AddFriends *aFriend= [toCollection objectAtIndex:indexPath.row];
            NSString *senderName=[[aFriend.from_user givenName]
                stringByAppendingString:[@" "
                    stringByAppendingString:[aFriend.from_user surname]
                ]
            ];
            
            // 1. agreed, add a friendship to friendshipStore; delete current record in AddFriend; send push notification to the request sender;
            Friendship *aRelation=[[Friendship alloc] init];
            aRelation.from_user=aFriend.from_user;
            aRelation.to_user=aFriend.to_user;
            aRelation.permission=[NSNumber numberWithInt:PermissionForFriends];
            aRelation.shownColor=[NSNumber numberWithInt:0];
            aRelation.from_id=[aFriend.from_user userId];
            aRelation.to_id= [aFriend.to_user userId];
            
            //test
            //if([aFriend.agreed isEqualToNumber:[NSNumber numberWithInt:0]]){NSLog(@"agreed==0");}
            
            //frist check if this friendship already exists;
            KCSQuery *query_exist1=[KCSQuery queryOnField:@"from_user._id"
                                   withExactMatchForValue:[aFriend.from_user userId]
                                    ];
            KCSQuery *query_exist2=[KCSQuery queryOnField:@"to_user._id"
                                   withExactMatchForValue:[aFriend.to_user userId]
                                    
                                    ];
            KCSQuery *query_exist=[KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query_exist1,query_exist2, nil];
            
            
            [friendshipStore queryWithQuery:query_exist withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if(objectsOrNil.count==0){// do not exist current friendship;
                    [friendshipStore saveObject:aRelation withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                        if(errorOrNil!=nil){
                            NSLog(@"%@",errorOrNil);
                        }
                    } withProgressBlock:nil
                     ];
                }
                
                
                } withProgressBlock:nil
             ];
            
            
            
            if([aFriend.agreed isEqualToNumber:[NSNumber numberWithInt:0]]){//the initial request
                // 2. ask the user if he wants to add the request sender as a friend;
                // 3. If yes, add a new record in AddFriend;
                //self.oneFriend=aFriend;
                
                
                
                    self.oneFriend.to_user=aFriend.from_user;
                    self.oneFriend.from_user=[KCSUser activeUser];
                    self.oneFriend.agreed=[NSNumber numberWithInt:PermissionForFriends];
                
                void (^block_after_assign)(AddFriends *assigned_array)=^(AddFriends *assigned_array){
                    NSLog(@"%@",self.oneFriend);
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Request Back"
                                                  message:[[@"You have agreed the request. Would you like to add " stringByAppendingString:senderName] stringByAppendingString:@" as a friend too?"]
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"YES"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                             
                                                 //Code to add friend back;
                                                 
                                                 KCSQuery *query_exist11=[KCSQuery queryOnField:@"from_user._id"
                                                                         withExactMatchForValue:[[KCSUser activeUser] userId]
                                                                          ];
                                                 KCSQuery *query_exist22=[KCSQuery queryOnField:@"to_user._id"
                                                                         withExactMatchForValue:
                                                                          [self.oneFriend.to_user userId]
                                                                          ];
                                                 KCSQuery *query_exist=[KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query_exist11,query_exist22, nil];
                                                 
                                                 NSString *str_Name=  [[[self.oneFriend.to_user givenName]
                                                                        stringByAppendingString:@" "]
                                                                       stringByAppendingString:[self.oneFriend.to_user surname]
                                                                       ];
                                                 
                                                 
                                                 //check if friend request is already in AddFriend;
                                                 [loadStore queryWithQuery:query_exist withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                                     if(errorOrNil!=nil){
                                                         NSLog(@"Get an error when checking if a friend request is already in AddFriend: %@",errorOrNil);
                                                     }
                                                     if(objectsOrNil.count!=0){//request already sent;
                                                         
                                                         
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
                                                         
                                                         [self presentViewController:alert animated:YES completion:nil];
                                                         return;
                                                         
                                                     }
                                                     if(objectsOrNil.count==0){// not in AddFriend;
                                                         //check if they are already friends.
                                                         [self.friendshipStore queryWithQuery:query_exist
                                                                          withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                                                              if(errorOrNil!=nil){
                                                                                  NSLog(@"Got an error: %@", errorOrNil);
                                                                                  
                                                                              }
                                                                              
                                                                              if(objectsOrNil.count!=0){//request already exists;
                                                                                  
                                                                                  
                                                                                  UIAlertController * alert=   [UIAlertController
                                                                                                                alertControllerWithTitle:@""
                                                                                                                message:[[@"You and "
                                                                                                                          stringByAppendingString:str_Name]
                                                                                                                         stringByAppendingString:@" are already friends."
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
                                                                                  
                                                                                  [self presentViewController:alert animated:YES completion:nil];
                                                                                  return;
                                                                              }
                                                                              else{//send the request;
                                                                                  [loadStore saveObject:self.oneFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
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
                                                                                          
                                                                                          [self presentViewController:alert animated:YES completion:nil];
                                                                                          
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
                                                                                          
                                                                                          [self presentViewController:alert animated:YES completion:nil];
                                                                                      }
                                                                                      return;
                                                                                      
                                                                                  } withProgressBlock:nil
                                                                                   ];//save to AddFriend
                                                                                  
                                                                              }
                                                                              
                                                                              
                                                                          } withProgressBlock:nil
                                                          ];//is in Friendship
                                                         
                                                         
                                                     }
                                                     
                                                 } withProgressBlock:nil
                                                  ];//is in AddFriend;
                                                 
                                                 
                                             
                                             
                                         }];
                    UIAlertAction* cancel = [UIAlertAction
                                             actionWithTitle:@"NO"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                    
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                };
                //assure the sequence that block will only be executed after self.oneFriend is assigned;
                block_after_assign(self.oneFriend);
                
            }
            
            [loadStore removeObject:aFriend withCompletionBlock:^(unsigned long count, NSError *errorOrNil) {
                if(errorOrNil!=nil){
                    NSLog(@"%@",errorOrNil);
                }
                } withProgressBlock:nil
             ];
            
            /*aFriend.agreed=[NSNumber numberWithInt:1];
            
            [self.loadStore saveObject:aFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                NSLog(@"accepted request");
            } withProgressBlock:nil
             ];
             */
            
            [toCollection removeObjectAtIndex:indexPath.row];
        }
        
    }
    
    [self.notifTable reloadData];
    NSLog(@"tapped");
}

////UIAlertView delegate:
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if([alertView.title isEqual:@"Request Back"]){//friendship request back to sender;
//        if (buttonIndex == 0)
//        {
//            //Code to add friend back;
//            
//            KCSQuery *query_exist11=[KCSQuery queryOnField:@"from_user._id"
//                                   withExactMatchForValue:[[KCSUser activeUser] userId]
//                                    ];
//            KCSQuery *query_exist22=[KCSQuery queryOnField:@"to_user._id"
//                                   withExactMatchForValue:
//                                    [self.oneFriend.to_user userId]
//                                    ];
//            KCSQuery *query_exist=[KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query_exist11,query_exist22, nil];
//            
//            NSString *str_Name=  [[[self.oneFriend.to_user givenName]
//                                   stringByAppendingString:@" "]
//                                  stringByAppendingString:[self.oneFriend.to_user surname]
//                                  ];
//            
//            
//            //check if friend request is already in AddFriend;
//            [loadStore queryWithQuery:query_exist withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                if(errorOrNil!=nil){
//                    NSLog(@"Get an error when checking if a friend request is already in AddFriend: %@",errorOrNil);
//                }
//                if(objectsOrNil.count!=0){//request already sent;
//                    UIAlertView* alert = [[UIAlertView alloc]
//                                          initWithTitle:@""
//                                          message:[[@"Request already sent to "
//                                                    stringByAppendingString:str_Name]
//                                                   stringByAppendingString:@", Please wait for acceptance."
//                                                   ]
//                                          delegate:self
//                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                          otherButtonTitles:nil
//                                          ];
//                    [alert show];
//                    return;
//                    
//                }
//                if(objectsOrNil.count==0){// not in AddFriend;
//                    //check if they are already friends.
//                    [self.friendshipStore queryWithQuery:query_exist
//                                     withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                                         if(errorOrNil!=nil){
//                                             NSLog(@"Got an error: %@", errorOrNil);
//                                             
//                                         }
//                                         
//                                         if(objectsOrNil.count!=0){//request already exists;
//                                             UIAlertView* alert = [[UIAlertView alloc]
//                                                                   initWithTitle:@""
//                                                                   message:[[@"You and "
//                                                                             stringByAppendingString:str_Name]
//                                                                            stringByAppendingString:@" are already friends."
//                                                                            ]
//                                                                   delegate:self
//                                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                                                   otherButtonTitles:nil
//                                                                   ];
//                                             [alert show];
//                                             return;
//                                         }
//                                         else{//send the request;
//                                             [loadStore saveObject:self.oneFriend withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                                                 if (errorOrNil != nil) {
//                                                     //save failed, show an error alert
//                                                     UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Save failed", @"Save Failed")
//                                                                                                         message:[errorOrNil localizedFailureReason] //not actually localized
//                                                                                                        delegate:nil
//                                                                                               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                                                                               otherButtonTitles:nil];
//                                                     [alertView show];
//                                                 } else {
//                                                     //save was successful
//                                                     
//                                                     
//                                                     UIAlertView* alert = [[UIAlertView alloc]
//                                                                           initWithTitle:@"Request sent"
//                                                                           message:[[@"Friend request has been sent to "
//                                                                                     stringByAppendingString:str_Name]
//                                                                                    stringByAppendingString:@" . Please wait for acceptance."
//                                                                                    ]
//                                                                           delegate:self
//                                                                           cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
//                                                                           otherButtonTitles:nil
//                                                                           ];
//                                                     [alert show];
//                                                 }
//                                                 return;
//                                                 
//                                             } withProgressBlock:nil
//                                              ];//save to AddFriend
//                                             
//                                         }
//                                         
//                                         
//                                     } withProgressBlock:nil
//                     ];//is in Friendship
//                    
//                    
//                }
//                
//            } withProgressBlock:nil
//             ];//is in AddFriend;
//            
//
//        }
//        
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //		NSString *section = [self.sections objectAtIndex:indexPath.section];
        //		NSMutableArray *wordsInSection = [[self.words objectForKey:section] mutableCopy];
        //		[wordsInSection removeObjectAtIndex:indexPath.row];
        //		[self.words setObject:wordsInSection forKey:section];
        //
        //		// Delete the row from the table view
        //        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



/*Decide if the index like "A-Z" appears on the right*/
/*- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
 {
 return self.sections;
 }*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
    
}


//- (IBAction)showGestureForPanGesture:(UIPanGestureRecognizer *)recognizer {
//    
//	[self search];
//}














- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
