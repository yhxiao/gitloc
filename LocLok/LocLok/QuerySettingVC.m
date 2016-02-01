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
@end

@implementation QuerySettingVC
@synthesize timeArray;

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.timeArray = [NSArray arrayWithObjects:@"?", @"?", nil];
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Show"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(sendQuery)
                                           ];
    
    
    self.navigationItem.rightBarButtonItem = closeBarButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [self refreshControl];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Query_TimeSetting";
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID_TimeSetting"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Time:";
	cell.detailTextLabel.text = [
                                 [[self.timeArray objectAtIndex:0]
                                    stringByAppendingString:@" ~ "
                                 ]
                                 stringByAppendingString:[self.timeArray objectAtIndex:1]
                                ];
    
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
    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
    if([targetCell.reuseIdentifier isEqualToString:@"Query_TimeSetting" ]){
        [self performSegueWithIdentifier:@"toTimeSetting" sender:self];
        
        /*TimeSettingVC *timeVC = [[TimeSettingVC alloc] init];
        timeVC.timedelegate = self;
        [[self navigationController] pushViewController:timeVC animated:YES];*/
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
    [self.tableView reloadData];
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
        }
    }
    
    /*send timeArray to QueryAnswer*/
    if([segue.identifier isEqualToString:@"toAnswer"]){
        QueryAnswerViewController* destination=segue.destinationViewController;
        if([destination isKindOfClass:[QueryAnswerViewController class]]){
            destination.timeArray=self.timeArray;
        }
        
    }

}
@end
