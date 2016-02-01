//
//  TimeSettingVC.m
//  LocShare
//
//  Created by yxiao on 6/27/13.
//  Copyright (c) 2013 Yonghui Xiao. All rights reserved.
//

#import "TimeSettingVC.h"

#define kPickerAnimationDuration 0.40

@interface TimeSettingVC ()

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton; // this button appears only when the date picker is shown

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
//@property (nonatomic, strong) NSIndexPath *path;

@end


//#pragma mark -

@implementation TimeSettingVC
@synthesize timedelegate;
@synthesize timeArray;

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
    //self.path=[NSIndexPath alloc];
    
    self.dataArray = [NSArray arrayWithObjects:@"Start Date", @"End Date", nil];
    self.timeArray=[NSMutableArray arrayWithCapacity:2];
    [self.timeArray addObjectsFromArray:self.dataArray];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    //timedelegate=[self navigationController].topViewController;
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Done"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(doneAction:)
                                          ];
    self.navigationItem.rightBarButtonItem = closeBarButtonItem;
    
    CGRect pickerFrame = CGRectMake(0,152,0,0);
    self.pickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [self.pickerView addTarget:self
                        action:@selector(dateAction:)
              forControlEvents:UIControlEventValueChanged
    ];
    [self.view addSubview:self.pickerView];
    
    
    //self.tableView.
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"CellID_TimeSetting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID_TimeSetting"];
	//static NSString *kCustomCellID = @"CellID_TimeSetting";
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    
	cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
    //cell.selected=YES;
	
    /*if(self.path==nil){
        NSUInteger intPath[2];
        intPath[0]=0;intPath[1]=0;
        self.path=[NSIndexPath indexPathWithIndexes:intPath length:2];
    }*/
	return cell;
}


//#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
	self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	
    
    // the date picker might already be showing, so don't add it to our view
    /*if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = self.view.frame.size.height;
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        self.pickerView.frame = endFrame;
        [UIView commitAnimations];
        
        // add the "Done" button to the nav bar
        //self.navigationItem.rightBarButtonItem = self.doneButton;
    }
    */
}


//#pragma mark - Actions

- (IBAction)dateAction:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if(indexPath==nil){
        NSUInteger intPath[2];
        intPath[0]=0;intPath[1]=0;
        indexPath=[NSIndexPath indexPathWithIndexes:intPath length:2];
    }
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
    [self.timeArray replaceObjectAtIndex:[indexPath indexAtPosition:1]
                              withObject:cell.detailTextLabel.text
    ];
}

- (void)slideDownDidStop
{
	// the date picker has finished sliding downwards, so remove it from the view hierarchy
	[self.pickerView removeFromSuperview];
}

- (IBAction)doneAction:(id)sender
{
    /*CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickerView.frame = pickerFrame;
    [UIView commitAnimations];
    
	// remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;
	*/
	// deselect the current table row
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //timedelegate=self.navigationController.parentViewController;
    
    [self.timedelegate TimeSettingVCDidFinish:self.timeArray];
    [[self navigationController] popViewControllerAnimated:YES];
    
    //[self performSegueWithIdentifier:@"toQuerySetting1" sender:self];
}

/*Send startTime and endTime to the next QuerySetting*/
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//     UIViewController *destination = segue.destinationViewController;
//     if ([destination respondsToSelector:@selector(setData:)]) {
//         [destination setValue:self.timeArray forKey:@"timeArray"];
//     }
// 
//}

@end

