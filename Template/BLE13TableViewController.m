//
//  BLE13TableViewController.m
//  Template
//
//  Created by Travis Kruse on 11/30/13.
//  Copyright (c) 2013 Travis Kruse. All rights reserved.
//

#import "BLE13TableViewController.h"

@interface BLE13TableViewController ()
@property (strong, nonatomic) NSMutableArray *listofFakeECG;
@property (strong, nonatomic) NSMutableArray *listofSubTitle;
@property (strong, nonatomic) NSMutableArray *listofSelectedFakeECG;
@end

@implementation BLE13TableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Calibration"]) {
                PlotViewController *vc = [segue destinationViewController];
                [vc setDeviceName:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            }
        }
    } else {
        if ([segue.identifier isEqualToString:@"MultiPlot"]) {
            MultiPlotViewController *vc = [segue destinationViewController];
            [vc setDeviceNames:self.listofSelectedFakeECG];
        }
    }
}

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
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    self.title=@"BLE Sensors available";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"BLEPlotPlotPLot";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.listofFakeECG count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLESensorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *cellValue = [self.listofFakeECG objectAtIndex:indexPath.row];
    NSString *subCellValue = [self.listofSubTitle objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.detailTextLabel.text = subCellValue;
    
    UISwitch *mySwitch = [[UISwitch alloc] init];
    cell.accessoryView = mySwitch;
    [mySwitch setOn:NO animated:NO];
    [mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
}

- (void) switchChanged:(id)sender {
    for (int i = 0; i < [self.listofFakeECG count]; i++) {
        [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathsForVisibleRows] [i]] setSelected:[[self.tableView cellForRowAtIndexPath:[self.tableView indexPathsForVisibleRows] [i]].accessoryView.accessibilityValue intValue] ? YES : NO];
    }
}

#pragma mark - refreshView

-(void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Looking for Bluetooth LE devices..."];
    // custom refresh logic would be placed here...
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    /*
     NSArray	*uuidArray = [NSArray arrayWithObject:[CBUUID UUIDWithString:kBLEShieldServiceUUIDString]];
     NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
     [self.cbManager scanForPeripheralsWithServices:uuidArray options:options];
     */
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    self.listofFakeECG = [[NSMutableArray alloc] init];
    [self.listofFakeECG addObject:@"FakeECG1"];
    [self.listofFakeECG addObject:@"FakeECG2"];
    [self.listofFakeECG addObject:@"FakeECG3"];
    self.listofSubTitle = [[NSMutableArray alloc] init];
    [self.listofSubTitle addObject:@"1"];
    [self.listofSubTitle addObject:@"2"];
    [self.listofSubTitle addObject:@"3"];
}

-(void) connectionTimer:(NSTimer *)timer
{
    // turn off refreshing
    [self.refreshControl endRefreshing];
    // update table view in case bluetooth devices were found
    [self.tableView reloadData];
}

- (IBAction)startMultiplePlot:(UIButton *)sender {
    int numOfPlot = 0;
    for (int i = 0; i < [self.listofFakeECG count]; i++) {
        if ([self.tableView cellForRowAtIndexPath:[self.tableView indexPathsForVisibleRows] [i]].isSelected) {
            numOfPlot++;
        }
    }
    if (numOfPlot) {
        self.listofSelectedFakeECG = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self.listofFakeECG count]; i++) {
            [[self.tableView cellForRowAtIndexPath:[self.tableView indexPathsForVisibleRows] [i]].accessoryView.accessibilityValue intValue] ? [self.listofSelectedFakeECG addObject:[self.tableView cellForRowAtIndexPath:[self.tableView indexPathsForVisibleRows] [i]].textLabel.text] : nil;
        }
        [self performSegueWithIdentifier:@"MultiPlot" sender:self];
    }
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
}

@end
