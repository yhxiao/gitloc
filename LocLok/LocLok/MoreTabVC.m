//
//  MoreTabVC.m
//  LocShare
//
//  Created by yxiao on 12/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "MoreTabVC.h"
//#import "CommonFunctions.h"
//#import "UpdateMyInfoVC.h"

@interface MoreTabVC ()

@end

@implementation MoreTabVC
@synthesize MoreTableView;
@synthesize words, sections,orderedSequence;

//- (NSMutableDictionary *)words
//{
//	if (!words) {
//		//NSURL *wordsURL = [NSURL URLWithString:@"http://cs193p.stanford.edu/vocabwords.txt"];
//        
////        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////        NSString* fileLoc=[NSString stringWithFormat:@"%@/MoreTabFile.txt", documentsDirectoryPath];
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//        // get documents path
//        NSString *documentsPath = [paths objectAtIndex:0];
//        NSString *fileLoc = [documentsPath stringByAppendingPathComponent:@"MoreTabFile.plist"];
//        // check to see if Data.plist exists in documents
//        if (![[NSFileManager defaultManager] fileExistsAtPath:fileLoc])
//        {
//            // if not in documents, get property list from main bundle
//            fileLoc = [[NSBundle mainBundle] pathForResource:@"MoreTabFile" ofType:@"plist"];
//            //NSLog(@"BasicData does not exist");
//        }
//        
//		words = [NSMutableDictionary dictionaryWithContentsOfFile:fileLoc];
//	}
//    NSLog(@"%@",words);
//	return words;
//}
//
//- (NSArray *)sections
//{
//	if (!sections) {
//		sections = [[self.words allKeys] sortedArrayUsingSelector:@selector(compare:)] ;
//	}
//	return sections;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor purpleColor]}];
    //self.title=@"LocLok";
    self.navigationItem.title=@"More";
	// Do any additional setup after loading the view.
    CGRect viewRect=CGRectMake(self.view.bounds.origin.x,
                               self.view.bounds.origin.y,
                               self.view.bounds.size.width,
                               self.view.bounds.size.height-[[self tabBarController] tabBar].frame.size.height
    );
    //self.MoreTableView.frame=mapRect;
    self.MoreTableView = [[UITableView alloc] initWithFrame:viewRect style:UITableViewStyleGrouped];
    //self.MoreTableView = [[UITableView alloc] init];
    self.MoreTableView.dataSource=self;
    self.MoreTableView.hidden=NO;
    self.MoreTableView.delegate=self;
    //[self.MoreTableView setEditing:NO animated:NO];
    //self.MoreTableView.editing=NO;
    //self.MoreTableView UITableViewCellEditingStyleNone;
    
    
    
    /*//scroll view;
    UIScrollView *MoreScrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    [MoreScrollView addSubview:self.MoreTableView];*/
    
    //[[[self tabBarController] tabBar] addSubview:self.MoreTableView];
    //[self.view bringSubviewToFront:self.MoreTableView];
    //self.MoreTableView.bounces = YES;
    
    
    [self.view addSubview:self.MoreTableView];
    //initialize words and sections;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *fileLoc = [documentsPath stringByAppendingPathComponent:@"MoreTabFile.plist"];
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileLoc])
    {
        // if not in documents, get property list from main bundle
        fileLoc = [[NSBundle mainBundle] pathForResource:@"MoreTabFile" ofType:@"plist"];
        //NSLog(@"BasicData does not exist");
    }
    
    words = [NSMutableDictionary dictionaryWithContentsOfFile:fileLoc];
    sections = [[self.words allKeys] sortedArrayUsingSelector:@selector(compare:)] ;
    
    
    //to keep the order of the dictionary;
    orderedSequence=[[NSMutableArray alloc] init];
    [orderedSequence addObject:[NSNumber numberWithInt:3]];
    [orderedSequence addObject:[NSNumber numberWithInt:2]];
    [orderedSequence addObject:[NSNumber numberWithInt:1]];
    [orderedSequence addObject:[NSNumber numberWithInt:0]];
    
}
-(NSNumber*)findSequence:(NSInteger*)n_section{
    return [orderedSequence objectAtIndex:n_section ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
	[self.MoreTableView deselectRowAtIndexPath:self.MoreTableView.indexPathForSelectedRow animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *wordsInSection;
    switch (section) {
        case 0:
            wordsInSection =[self.words objectForKey:@"Settings"];
            break;
        case 1:
            wordsInSection =[self.words objectForKey:@"Friends Management"];
            break;
            
        case 2:
            wordsInSection =[self.words objectForKey:@"Advanced"];
            break;
        case 3:
            wordsInSection =[self.words objectForKey:@"About LocLok"];
            break;
            
        default:
            break;
    }
	return wordsInSection.count;
}

- (NSString *)wordAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *wordsInSection;
    switch (indexPath.section) {
        case 0:
            wordsInSection =[self.words objectForKey:@"Settings"];
            break;
        case 1:
            wordsInSection =[self.words objectForKey:@"Friends Management"];
            break;
            
        case 2:
            wordsInSection =[self.words objectForKey:@"Advanced"];
            break;
        case 3:
            wordsInSection =[self.words objectForKey:@"About LocLok"];
            break;
            
        default:
            break;
    }
	//NSLog(@"%d,%d,%@",indexPath.section,indexPath.row,[wordsInSection objectAtIndex:indexPath.row]);
    return [wordsInSection objectAtIndex:indexPath.row];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor=[UIColor grayColor];
	cell.textLabel.text = [self wordAtIndexPath:indexPath];
    //The icon on the right side of a row;
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if([cell.textLabel.text isEqualToString:@"Log Out"]){
        cell.textLabel.textColor=[UIColor redColor];
    }
    if([cell.textLabel.text isEqualToString:@"Update Info"] || [cell.textLabel.text isEqualToString:@"Find Friends"] || [cell.textLabel.text isEqualToString:@"Friends' Permissions of Me"] || [cell.textLabel.text isEqualToString:@"My Permissions of Friends"] || [cell.textLabel.text isEqualToString:@"About LocLok"]){
        cell.textLabel.textColor=[UIColor blackColor];
    }
    
    NSString* strIconName;
    switch(indexPath.section){
        case 0:{
            switch (indexPath.row) {
                case 0:{//My History
                    strIconName=@"Query";
                    [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                case 1:{//Update Info;
                    strIconName=@"Update_info2";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 44)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                case 2:{
                    strIconName=@"Notification_setting";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 44)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                case 3:{
                    strIconName=@"Save_Battery";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 44)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:{//Find Friends;
                    strIconName=@"Find_friends2";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 30)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                case 1:{//Friends' permissions of me;
                    strIconName=@"Friends_permission_me2";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 30)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                    
                case 2:{//my permissions of friends;
                    strIconName=@"My_permission_friends2";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 30)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
            
        case 2:{
            switch(indexPath.row){
                case 0:{
                    strIconName=@"My_statistics";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 30)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                case 1:{
                    strIconName=@"My_privacy";
                    [cell.imageView setFrame:CGRectMake(0, 0, 30, 30)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    strIconName=@"About_this_app2";
                    [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                case 1:{
                    strIconName=@"Logout2";
                    [cell.imageView setFrame:CGRectMake(0, 0, 44, 44)];
                    [cell.imageView  setImage:[UIImage imageNamed:strIconName]];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
        default:
            break;
            
    }
    
    
    
    return cell;
}
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Settings";
            break;
        case 1:
            return @"Friends Management";
            break;
            
        case 2:
            return @"Advanced";
            break;
        case 3:
            return @"About LocLok";
            break;
            
        default:
            break;
    }
    return 0;
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
    
    switch(indexPath.section){
        case 0:{
            switch (indexPath.row) {
                case 0://My History
                    
                    break;
                case 1:{//Update Info;
                    UpdateMyInfoVC* infoVC = [[UpdateMyInfoVC alloc] initWithNibName:@"UpdateMyInfoVC" bundle:nil];
                    //LoginVC.modalTransitionStyle=UIModalTrans
                    infoVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    
                    //[self.window makeKeyAndVisible];
                    //[self presentViewController:infoVC animated:NO completion:NULL];
                    [self.navigationController pushViewController:infoVC animated:YES];
                }
                    break;
                case 2:break;
                case 3:{
                    /*
                    WriteUpdateViewController *footVC = [[WriteUpdateViewController alloc] initWithNibName:@"WriteUpdateViewController" bundle:nil
                    ];
                    //LoginVC.modalTransitionStyle=UIModalTrans
                    footVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    
                    //[self.window makeKeyAndVisible];
                    [self presentViewController:footVC animated:NO completion:NULL];
                     */
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        case 1:{
            switch (indexPath.row) {
                case 0:{//Find Friends;
                    FindFriendVC* ffVC = [[FindFriendVC alloc] initWithNibName:@"FindFriendVC" bundle:nil];
                    //LoginVC.modalTransitionStyle=UIModalTrans
                    ffVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    
                    //[self.window makeKeyAndVisible];
                    //[self presentViewController:ffVC animated:NO completion:NULL];
                    [self.navigationController pushViewController:ffVC animated:YES];
                }
                    break;
                case 1:{//Friends' permissions of me;
                    FriendsPermissions* fpVC = [[FriendsPermissions alloc] init ];
                    fpVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [self.navigationController pushViewController:fpVC animated:YES];
                }
                    break;
                    
                case 2:{//my permissions of friends;
                    MyPermissions* mpVC = [[MyPermissions alloc] init ];
                    mpVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [self.navigationController pushViewController:mpVC animated:YES];
                }
                    break;
                
                default:
                    break;
            }
                
        }
            
            break;
            
        case 2:{
            
        }
            
            break;
            
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    AboutVC* aboutVC = [[AboutVC alloc]  init];
                    aboutVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    
                    
                    [self.navigationController pushViewController:aboutVC animated:YES];
                }
                    break;
                case 1:
                    [self logout];
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
        default:
            break;
        
    }
	
}
#pragma mark -
#pragma mark More Item functions

-(IBAction)logout{
    //[[KCSUser activeUser] logout] should clear the cache, but it does not work;
    //[KCSCachedStore clearCaches];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    [appDelegate DataCleanBeforeLogout];
    //transit to the rootVC of tabbarController;
    
    LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    //LoginVC.modalTransitionStyle=UIModalTrans
    loginVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    //test
    //UITabBarController *navController = (UITabBarController *)appDelegate.window.rootViewController;
    //[navController ];
    
    
    
    [self presentViewController:loginVC animated:NO completion:^{
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                //jump to the root view controller: map;
                [self tabBarController].selectedIndex=0;
    }
     ];
    //[self performSegueWithIdentifier:@"toLogin" sender:self];
    
    /*[CommonFunctions writeToPlist:@"BasicData"
              ojbArray:[NSArray arrayWithObjects:@"",@"",@"", nil]
               objName:[NSArray arrayWithObjects:@"userInfo", nil]
     ];*/
}



@end
