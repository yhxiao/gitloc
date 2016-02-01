//
//  PrivacyRuleSettingVC.m
//  LocShare
//
//  Created by yxiao on 8/23/15.
//  Copyright (c) 2015 Yonghui Xiao. All rights reserved.
//

#import "PrivacyRuleSettingVC.h"

@interface PrivacyRuleSettingVC ()
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@end

@implementation PrivacyRuleSettingVC
@synthesize configTable;
@synthesize labelText,detailedText;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    
    configTable=[[UITableView alloc]init];
    configTable.frame=CGRectMake(0, 0, self.view.bounds.size.width, 196);
    configTable.dataSource=self;
    configTable.delegate=self;
    [self.view addSubview:configTable];
    
    
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Done"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(doneAction:)
                                           ];
    //self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem = closeBarButtonItem;
    
    
    CGRect pickerFrame = CGRectMake(0,self.view.bounds.size.height,0,0);
    self.pickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    self.pickerView.datePickerMode=UIDatePickerModeTime;
    [self.pickerView addTarget:self
                        action:@selector(timeAction:)
              forControlEvents:UIControlEventValueChanged
     ];
    [self.view addSubview:self.pickerView];
    
    
    
    labelText=[[NSMutableArray alloc] init];
    [labelText addObject:@"Weekday: "];
    [labelText addObject:@"Start time: "];
    [labelText addObject:@"End time: "];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    //set initial value for labelText and detailedText;
    
        
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"CellID_RuleSetting";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    if(cell==nil)cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier2];
    
    
    cell.textLabel.text = [labelText objectAtIndex:indexPath.row];
    //NSLog(@"%@",[labelText objectAtIndex:indexPath.row]);
    cell.detailTextLabel.text = [detailedText objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor=[UIColor blueColor];
    [cell.detailTextLabel setTextAlignment:NSTextAlignmentRight];
    
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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"HH:mm"];
    
    switch(indexPath.row){
        case 0:{
            UIActionSheet* actionAlert = [[UIActionSheet alloc]
                initWithTitle:nil
                delegate:self
                cancelButtonTitle:nil
                destructiveButtonTitle:nil
                otherButtonTitles:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Cancel",
                nil,
                nil
            ];
            
            [actionAlert showInView:self.view];
        }
        break;
        case 1:{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 CGRect frame=self.pickerView.frame;
                                 frame.origin.y=self.view.bounds.size.height-frame.size.height-49;
                                 self.pickerView.frame=frame;
                                 self.pickerView.date=[dateFormat dateFromString:targetCell.detailTextLabel.text];
                             }
                             completion:^(BOOL finished){
                                 
                             }
             ];
        }
        break;
        case 2:{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 CGRect frame=self.pickerView.frame;
                                 frame.origin.y=self.view.bounds.size.height-frame.size.height-49;
                                 self.pickerView.frame=frame;
                                 self.pickerView.date=[dateFormat dateFromString:targetCell.detailTextLabel.text];
                             }
                             completion:^(BOOL finished){
                                 
                             }
             ];
        }
            break;
        default:
            break;
        
        
    }
    
    
    //[tableView reloadData];
}
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:{
            [detailedText replaceObjectAtIndex:0 withObject:@"Sunday"];
        }
        break;
        case 1:
            [detailedText replaceObjectAtIndex:0 withObject:@"Monday"];
            break;
        case 2:
            [detailedText replaceObjectAtIndex:0 withObject:@"Tuesday"];
            break;
        case 3:
            [detailedText replaceObjectAtIndex:0 withObject:@"Wednesday"];
            break;
        case 4:
            [detailedText replaceObjectAtIndex:0 withObject:@"Thursday"];
            break;
        case 5:
            [detailedText replaceObjectAtIndex:0 withObject:@"Friday"];
            break;
        case 6:
            [detailedText replaceObjectAtIndex:0 withObject:@"Saturday"];
            break;
        default:
            break;
    }
    [self.configTable reloadData];
}


- (IBAction)timeAction:(id)sender{
    NSIndexPath *indexPath = [self.configTable indexPathForSelectedRow];
    
    if(indexPath==nil){
        NSUInteger intPath[2];
        intPath[0]=0;intPath[1]=1;
        indexPath=[NSIndexPath indexPathWithIndexes:intPath length:2];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"HH:mm"];
    UITableViewCell *cell = [self.configTable cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [dateFormat stringFromDate:self.pickerView.date];
    
    [detailedText replaceObjectAtIndex:indexPath.row
                            withObject:[dateFormat stringFromDate:self.pickerView.date]
     ];
    
    if([[dateFormat dateFromString:[detailedText objectAtIndex:1]] compare:[dateFormat dateFromString:[detailedText objectAtIndex:2]]]==NSOrderedDescending){
        NSLog(@"%@, %@",[dateFormat dateFromString:[detailedText objectAtIndex:1]],[dateFormat dateFromString:[detailedText objectAtIndex:2]]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"\"End time\" must be larger than \"Start time\"."
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil
                              ];
        [alert show];
    }
    
}

- (IBAction)doneAction:(id)sender{
    
    //send rule data back;
    [self.delegate getRuleData:detailedText];
    //close this;
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
