//
//  SWUserInfoConfigViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/29/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWUserInfoConfigViewController.h"
#import "SWInputTableViewCellView.h"
#import "SWLoginUser.h"
#import "SWImageLabelTableViewCell.h"
#import "SWUserNameImageConfigTableViewController.h"

#define USER_INFO_SECTION 0
#define USER_PSW_SECTION 1
#define SIGN_OUT_SECTION 2
#define INPUT_CELL_TAG 9000
#define TITLE_CELL_TAG 9001
#define TITLE_IMAGE_CELL_TAG 9002

@interface SWUserInfoConfigViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *userInfoTableView;
@property(nonatomic) BOOL isEditPSW;
@end

@implementation SWUserInfoConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    
    _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _userInfoTableView.delegate = self;
    _userInfoTableView.dataSource = self;
   
    _userInfoTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_userInfoTableView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_userInfoTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_userInfoTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_userInfoTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_userInfoTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    
    _isEditPSW = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.userInfoTableView reloadData];

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        if (self.isEditPSW) {
            return 5;
        }else
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    static NSString *INPUT_CELL_IDENTIFY = @"INPUT_CELL_IDENTIFY";
    static NSString *TITLE_CELL_IDENTIFY = @"TITLE_CELL_IDENTIFY";
    static NSString *TITLE_IMAGE_CELL_IDENTIFY = @"SWImageLabelTableViewCell";
    
    switch (indexPath.section) {
        case USER_INFO_SECTION:
        {
            SWImageLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TITLE_IMAGE_CELL_IDENTIFY];
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:@"SWImageLabelTableViewCell" bundle:nil] forCellReuseIdentifier:TITLE_IMAGE_CELL_IDENTIFY];
                cell = [tableView dequeueReusableCellWithIdentifier:TITLE_IMAGE_CELL_IDENTIFY];
            }
            cell.SWCellImageView.image = [SWLoginUser sharedInstance].userImage;
            cell.SWCellLabel.text = [SWLoginUser sharedInstance].userName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case USER_PSW_SECTION:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFY];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLE_CELL_IDENTIFY];
                    }
                    
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = @"修改密码";
                }
                    break;
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:INPUT_CELL_IDENTIFY];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:INPUT_CELL_IDENTIFY];
                    }
                    SWInputTableViewCellView *inputCellView = nil;
                    if ([cell.contentView viewWithTag:INPUT_CELL_TAG]) {
                        inputCellView = (SWInputTableViewCellView *)[cell.contentView viewWithTag:INPUT_CELL_TAG];
                        
                    }else
                    {
                        inputCellView = [[SWInputTableViewCellView alloc] initWithTitle:@"" inputContent:@"" placeHolder:@""];
                        inputCellView.tag = INPUT_CELL_TAG;
                        inputCellView.frame = cell.contentView.frame;
                        [inputCellView layoutIfNeeded];
                        [cell.contentView addSubview:inputCellView];
                    }
                    inputCellView.inputTitleLable.text = @"旧密码";
                    inputCellView.inputContentTextField.text = @"";
                    inputCellView.inputContentTextField.placeholder = @"请输入旧的密码";
                    inputCellView.inputContentTextField.secureTextEntry = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                    break;
                case 2:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:INPUT_CELL_IDENTIFY];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:INPUT_CELL_IDENTIFY];
                    }
                    SWInputTableViewCellView *inputCellView = nil;
                    if ([cell.contentView viewWithTag:INPUT_CELL_TAG]) {
                        inputCellView = (SWInputTableViewCellView *)[cell.contentView viewWithTag:INPUT_CELL_TAG];
                        
                    }else
                    {
                        inputCellView = [[SWInputTableViewCellView alloc] initWithTitle:@"" inputContent:@"" placeHolder:@""];
                        inputCellView.tag = INPUT_CELL_TAG;
                        inputCellView.frame = cell.contentView.frame;
                        [inputCellView layoutIfNeeded];
                        [cell.contentView addSubview:inputCellView];
                    }
                    inputCellView.inputTitleLable.text = @"新密码";
                    inputCellView.inputContentTextField.text = @"";
                    inputCellView.inputContentTextField.placeholder = @"请输入新的密码";
                    inputCellView.inputContentTextField.secureTextEntry = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                    break;
                case 3:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:INPUT_CELL_IDENTIFY];
                    if(cell == nil)
                    {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:INPUT_CELL_IDENTIFY];
                    }
                    SWInputTableViewCellView *inputCellView = nil;
                    if ([cell.contentView viewWithTag:INPUT_CELL_TAG]) {
                        inputCellView = (SWInputTableViewCellView *)[cell.contentView viewWithTag:INPUT_CELL_TAG];
                        
                    }else
                    {
                        inputCellView = [[SWInputTableViewCellView alloc] initWithTitle:@"" inputContent:@"" placeHolder:@""];
                        inputCellView.tag = INPUT_CELL_TAG;
                        inputCellView.frame = cell.contentView.frame;
                        [inputCellView layoutIfNeeded];
                        [cell.contentView addSubview:inputCellView];
                    }
                    inputCellView.inputTitleLable.text = @"确认新密码";
                    inputCellView.inputContentTextField.text = @"";
                    inputCellView.inputContentTextField.placeholder = @"再次输入新的密码";
                    inputCellView.inputContentTextField.secureTextEntry = YES;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                    break;
                case 4:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFY];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLE_CELL_IDENTIFY];
                    }
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.text = @"确定";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case SIGN_OUT_SECTION:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:TITLE_CELL_IDENTIFY];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TITLE_CELL_IDENTIFY];
            }
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"注销";
            cell.textLabel.textColor = [UIColor redColor];

        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == USER_PSW_SECTION && indexPath.row == 0) {
        self.isEditPSW = !self.isEditPSW;
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:USER_PSW_SECTION];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:USER_PSW_SECTION];
        NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:3 inSection:USER_PSW_SECTION];
        NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:4 inSection:USER_PSW_SECTION];
        NSArray *indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, indexPath3, indexPath4, nil];
        if (self.isEditPSW) {
           
            [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
        }else
        {
            [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
        }
    }else if(indexPath.section == USER_INFO_SECTION)
    {
        SWUserNameImageConfigTableViewController *userNameImageVC = [[SWUserNameImageConfigTableViewController alloc] init];
        [self.navigationController pushViewController:userNameImageVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == USER_INFO_SECTION) {
        return 80.0;
    }else
    {
        return 50.0;
    }
}

@end
