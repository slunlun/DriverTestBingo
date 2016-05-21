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

@interface SWUserNameViewController ()<UITextFieldDelegate>
@property(nonnull, strong) UITextField *userNameTextField;
@end

@implementation SWUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up userNameTextField
    _userNameTextField = [[UITextField alloc] init];
    _userNameTextField.text =[SWLoginUser sharedInstance].userName;
    _userNameTextField.delegate = self;
    _userNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    [_userNameTextField addTarget:self action:@selector(userNameTextFiledContentChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:_userNameTextField];
    self.view.backgroundColor = [UIColor colorWithRed:(200.0/255.0) green:(199.0/255.0) blue:(204.0/255.0) alpha:1.0];
    
    NSDictionary *viewsDict = @{@"userNameTextField":_userNameTextField};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[userNameTextField]|" options:0 metrics:nil views:viewsDict]];
    NSDictionary *constraintsSizeDict = @{@"userNameTextFieldHeight":@40, @"userNameTextFieldTopMergin":@25};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(userNameTextFieldTopMergin)-[userNameTextField(==userNameTextFieldHeight)]" options:0 metrics:constraintsSizeDict views:viewsDict]];
    
    
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

@end
