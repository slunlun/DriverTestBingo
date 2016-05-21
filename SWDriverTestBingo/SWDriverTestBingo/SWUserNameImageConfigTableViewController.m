//
//  SWUserNameImageConfigTableViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 4/8/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "SWUserNameImageConfigTableViewController.h"
#import "SWLoginUser.h"
#import "SWUserHeadImageViewController.h"
#import "SWUserNameViewController.h"
#import "SWDriverTestBigoDef.h"
@interface SWUserNameImageConfigTableViewController ()

@end

@implementation SWUserNameImageConfigTableViewController
static  NSString *NORMAL_CELL_IDENTITY = @"CELL_IDENTITY";
static NSString  *DETAIL_CELL_IDENTITY = @"DETAIL_CELL_IDENTITY";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationController.navigationBarHidden = NO;
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseToUserInfoUpdatedNotification:) name:USER_INFO_UPDATED object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = nil;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:NORMAL_CELL_IDENTITY];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NORMAL_CELL_IDENTITY];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.image = [SWLoginUser sharedInstance].userImage;
        cell.accessoryView = imageView;
        cell.textLabel.text = NSLocalizedString(@"UserHeadImage", nil);
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:DETAIL_CELL_IDENTITY];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DETAIL_CELL_IDENTITY];
        }
        cell.textLabel.text = NSLocalizedString(@"UserName", nil);
        cell.detailTextLabel.text = [SWLoginUser sharedInstance].userName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 50.0;
        
    }else
    {
        return 40.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { // Change user image
        
        SWUserHeadImageViewController *vc = [[SWUserHeadImageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1) // Change user name
    {
        SWUserNameViewController *vc = [[SWUserNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Response to Notification
-(void) responseToUserInfoUpdatedNotification:(NSNotification *) notification
{
    [self.tableView reloadData];
}

@end
