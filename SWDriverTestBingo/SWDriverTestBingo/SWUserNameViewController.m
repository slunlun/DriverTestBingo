//
//  SWUserNameViewController.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/5/15.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "SWUserNameViewController.h"
#import "SWLoginUser.h"
#import "SWDriverTestBigoDef.h"

@interface SWUserNameViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonnull, strong) UITextField *userNameTextField;
@property(nonnull, strong) UITableView *userNameTableView;
@end

@implementation SWUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set up username tableView
    _userNameTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _userNameTableView.delegate = self;
    _userNameTableView.dataSource = self;
    _userNameTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_userNameTableView];
    
    NSDictionary *viewsDict = @{@"userNameTableView":_userNameTableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameTableView]|" options:0 metrics:nil views:viewsDict]];
   
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userNameTableView]|" options:0 metrics:nil views:viewsDict]];
    
    
    // set up userNameTextField
    _userNameTextField = [[UITextField alloc] init];
    _userNameTextField.text =[SWLoginUser sharedInstance].userName;
    _userNameTextField.delegate = self;
    _userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _userNameTextField.borderStyle = UITextBorderStyleNone;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    [_userNameTextField addTarget:self action:@selector(userNameTextFiledContentChanged:) forControlEvents:UIControlEventEditingChanged];
    
   // [self.view addSubview:_userNameTextField];
    self.view.backgroundColor = [UIColor colorWithRed:(200.0/255.0) green:(199.0/255.0) blue:(204.0/255.0) alpha:1.0];
    
    
    // set up navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(saveNameButtonClicked:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNameEditButtonClicked:)];
    self.navigationItem.title = NSLocalizedString(@"NickName", nil);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Response
-(void) saveNameButtonClicked:(UIBarButtonItem *) barButtonItem
{
    [[SWLoginUser sharedInstance] updateUserName:self.userNameTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) cancelNameEditButtonClicked:(UIBarButtonItem *) barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) userNameTextFiledContentChanged:(UITextField *) textField
{
    if (textField == self.userNameTextField) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
        
        if (textField.text.length == 0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }else
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    
}

#pragma mark - UITextFileDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"The rang is %ld, %ld", range.location, range.length);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* TEXT_FIELD_IDENTIFY = @"TEXT_FIELD_IDENTIFY";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXT_FIELD_IDENTIFY];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXT_FIELD_IDENTIFY];
        [cell.contentView addSubview:_userNameTextField];
        NSDictionary *viewDict = @{@"userNameTextField" : _userNameTextField};
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userNameTextField]|" options:0 metrics:nil views:viewDict]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[userNameTextField]-|" options:0 metrics:nil views:viewDict]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
   
    return cell;
}

@end
