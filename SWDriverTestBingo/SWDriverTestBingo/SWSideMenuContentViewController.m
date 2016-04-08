//
//  SWSideMenuContentViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWSideMenuContentViewController.h"
#import "SWRoundButtonTableViewCell.h"

#import "SWUserInfoConfigViewController.h"
#import "SWGoodIdeasViewController.h"

@interface SWSideMenuContentViewController ()

@end

@implementation SWSideMenuContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentInset = UIEdgeInsetsMake(20, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) { // user info
        return 1;
    }else if(section == 1)  // other operations
    {
        return 4;
    }
    
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SWRoundButtonTableViewCell *cell = [SWRoundButtonTableViewCell initWithTableView:tableView userInfoCellWithUserName:@"EShi" userHeadImage:[UIImage imageNamed:@"testUserHead"]];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    // other opeartions 0 考试锦囊 1 考前许愿 2 设置 3 关于
    static NSString* OPERATION_CELL_IDENTITY = @"OPERATION_CELL_IDENTITY";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OPERATION_CELL_IDENTITY];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OPERATION_CELL_IDENTITY];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = NSLocalizedString(@"GoodIdeasForTest", nil);
            cell.imageView.image = [UIImage imageNamed:@"goodIdeas"];
            cell.backgroundColor = [UIColor clearColor];
        }
            break;
        case 1:
        {
            cell.textLabel.text = NSLocalizedString(@"GoodWishForTest", nil);
            cell.imageView.image = [UIImage imageNamed:@"wish"];
            cell.backgroundColor = [UIColor clearColor];
        }
            break;
        case 2:
        {
            cell.textLabel.text = NSLocalizedString(@"Setting", nil);
            cell.imageView.image = [UIImage imageNamed:@"config"];
            cell.backgroundColor = [UIColor clearColor];
        }
            break;
        case 3:
        {
            cell.textLabel.text = NSLocalizedString(@"About", nil);
            cell.imageView.image = [UIImage imageNamed:@"about"];
            cell.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.drag2ShowMenuVC closeSideMenu];
    
    if (indexPath.section == 0) {  // user info cell
        SWUserInfoConfigViewController *vc = [[SWUserInfoConfigViewController alloc] init];
        vc.view.backgroundColor = [UIColor blueColor];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        switch (indexPath.row) {
            case 0:  // goodIdeas
            {
                SWGoodIdeasViewController *vc = [[SWGoodIdeasViewController alloc] init];
                vc.view.backgroundColor = [UIColor lightGrayColor];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: // wish
            {}
                break;
            case 2: // config
            {}
                break;
            case 3: // about
            {}
                break;
            default:
                break;
        }
    }
}

@end
