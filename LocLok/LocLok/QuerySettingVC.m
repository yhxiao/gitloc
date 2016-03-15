//
//  QuerySettingVC.m
//  LocShare
//
//  Created by yxiao on 6/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "QuerySettingVC.h"
#import "TimeSettingVC.h"

@interface QuerySettingVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIFont * cellFont;
@property (nonatomic, retain) UIFont * cellFont2;
@end

@implementation QuerySettingVC
@synthesize timeArray,timeArrayConst, today00,yesterday00,thisWeek00,lastWeek00,thisMonth00,lastMonth00,last3day00,isCustomized;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isCustomized=NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.cellFont=[ UIFont fontWithName: @"Arial" size: 16 ];
    self.cellFont2=[ UIFont fontWithName: @"Arial" size: 8 ];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.timeArray =nil;
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Show"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(sendQuery)
                                           ];
    
    
    self.navigationItem.rightBarButtonItem = closeBarButtonItem;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    self.clearsSelectionOnViewWillAppear=YES;
}
- (void)viewWillAppear:(BOOL)animated{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components;
    //components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate alloc] init]];
    
    [components setDay:[components day] ];
    today00  = [cal dateFromComponents:components];
    
    //[components setHour:-[components hour]];
    //[components setMinute:-[components minute]];
    //[components setSecond:-[components second]];
    //[components setNanosecond:1];
    //today00 = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    //[components setHour:-24];
    //[components setMinute:0];
    //[components setSecond:0];
    //yesterday00 = [cal dateByAddingComponents:components toDate: today00 options:0];
    [components setDay:([components day] - 1)];
    yesterday00=[cal dateFromComponents:components];
    
    //[components setHour:-72];
    //[components setMinute:0];
    //[components setSecond:0];
    //last3day00=[cal dateByAddingComponents:components toDate: today00 options:0];
    [components setDay:([components day] - 2)];
    last3day00=[cal dateFromComponents:components];
    
    components = [cal components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    thisWeek00  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - 7)];
    lastWeek00  = [cal dateFromComponents:components];
    
    [components setDay:([components day] - ([components day] -1))];
    thisMonth00 = [cal dateFromComponents:components];
    
    [components setMonth:([components month] - 1)];
    lastMonth00 = [cal dateFromComponents:components];
    
//    NSLog(@"today=%@",today00);
//    NSLog(@"yesterday=%@",yesterday00);
//    NSLog(@"yesterday=%@",last3day00);
//    NSLog(@"thisWeek=%@",thisWeek00);
//    NSLog(@"lastWeek=%@",lastWeek00);
//    NSLog(@"thisMonth=%@",thisMonth00);
//    NSLog(@"lastMonth=%@",lastMonth00);
    
    if(timeArray!=nil && [self.tableView indexPathForSelectedRow].row==7){
        self.navigationItem.rightBarButtonItem.enabled=YES;
    }
    
    //[self refreshControl];
    
    NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
-(void)viewWillDisappear:(BOOL)animated{
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    static NSString *CellIdentifier = @"Query_TimeSetting";
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID_TimeSetting"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font=self.cellFont;
    cell.detailTextLabel.font=self.cellFont2;
    cell.detailTextLabel.numberOfLines=2;
    cell.detailTextLabel.textColor=[UIColor blackColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Today";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:today00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:@"now"
                                         ];
            break;
            
        case 1:
            cell.textLabel.text = @"Yesterday";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:yesterday00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:[appDelegate.yearToSecondFormatter stringFromDate:today00]
                                         ];
            break;
            
        case 2:
            cell.textLabel.text = @"Last 3 days";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:last3day00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:[appDelegate.yearToSecondFormatter stringFromDate:today00]
                                         ];
            break;
            
        case 3:
            cell.textLabel.text = @"This week";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:thisWeek00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:@"now"
                                         ];

            break;
            
        case 4:
            cell.textLabel.text = @"Last week";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:lastWeek00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:[appDelegate.yearToSecondFormatter stringFromDate:thisWeek00]
                                         ];

            break;
            
        case 5:
            cell.textLabel.text = @"This month";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:thisMonth00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:@"now"
                                         ];

            break;
            
        case 6:
            cell.textLabel.text = @"Last month";
            cell.detailTextLabel.text = [
                                         [[appDelegate.yearToSecondFormatter stringFromDate:lastMonth00]
                                          stringByAppendingString:@" ~ "
                                          ]stringByAppendingString:[appDelegate.yearToSecondFormatter stringFromDate:thisMonth00]
                                         ];

            break;
        case 7:
            cell.textLabel.text = @"Customize";
            cell.detailTextLabel.text = [[
            self.timeArray==nil?@"?":[self.dateFormatter stringFromDate:[self.timeArray objectAtIndex:0]]
                                          stringByAppendingString:@" ~ "
                                         ]
                                         stringByAppendingString:
            self.timeArray==nil?@"?":[self.dateFormatter stringFromDate:[self.timeArray objectAtIndex:1]]
                                         ] ;
            break;
        default:
            break;
    }
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if(indexPath.row<7){//not custom
        isCustomized=NO;
        self.navigationItem.rightBarButtonItem.enabled=YES;
        switch(indexPath.row){
            case 0:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:today00,
                                                          [NSDate date],nil];
                break;
                
            case 1:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:yesterday00,
                                                          today00,nil
                                
                                ];
                break;
                
            case 2:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:last3day00,
                                                          today00,nil
                                
                                ];
                break;
                
            case 3:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:thisWeek00,
                                                          [NSDate date],nil
                                
                                ];
                
                break;
                
            case 4:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:lastWeek00,
                                                          thisWeek00,nil
                                
                                ];
                
                break;
                
            case 5:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:thisMonth00,
                                                          [NSDate date],nil
                                
                                ];
                
                break;
                
            case 6:
                timeArrayConst=nil;
                timeArrayConst=[NSArray arrayWithObjects:lastMonth00,
                                                          thisMonth00,nil
                                
                                ];
                
                break;
            default:break;
        }
    }
    else{//customize
        isCustomized=YES;
        //UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
        //if([targetCell.reuseIdentifier isEqualToString:@"Query_TimeSetting" ]){
            [self performSegueWithIdentifier:@"toTimeSetting" sender:self];
            
            /*TimeSettingVC *timeVC = [[TimeSettingVC alloc] init];
            timeVC.timedelegate = self;
            [[self navigationController] pushViewController:timeVC animated:YES];*/
        //}
        if(self.timeArray!=nil){
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled=NO;
        }
    }
    
    //[tableView reloadData];
}


- (void)TimeSettingVCDidFinish:(NSMutableArray*)theTime
{
    //[self.timeArray  initWithCapacity:2];
    //[self.timeArray replaceObjectAtIndex:0 withObject:[theTime objectAtIndex:0]];
    //[self.timeArray replaceObjectAtIndex:1 withObject:[theTime objectAtIndex:1]];
    self.timeArray=theTime;
    //NSLog([self.timeArray objectAtIndex:0]);
    // Do something with the array
    NSIndexPath *ipath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:ipath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (IBAction)sendQuery{
    [self performSegueWithIdentifier:@"toAnswer" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    /*set self as the TimeSetting's delegate to get timeArray*/
    if([segue.identifier isEqualToString:@"toTimeSetting"]){
        TimeSettingVC *destination = segue.destinationViewController;
        if ([destination isKindOfClass:[TimeSettingVC class]]) {
            destination.timedelegate = self;
            if([self.tableView indexPathForSelectedRow].row==7){
                destination.timeArray=self.timeArray;
            }
        }
    }
    
    /*send timeArray to QueryAnswer*/
    if([segue.identifier isEqualToString:@"toAnswer"]){
        QueryAnswerViewController* destination=segue.destinationViewController;
        if([destination isKindOfClass:[QueryAnswerViewController class]]){
            if(isCustomized){
                destination.timeArray=self.timeArray;
            }
            else{
                destination.timeArray=self.timeArrayConst;
            }
        }
        
    }

}
@end
