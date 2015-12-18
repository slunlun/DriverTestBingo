//
//  SWDriverTestMainViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDriverTestMainViewController.h"
#import "SWDriverTestMainItemsViewController.h"



@interface SWDriverTestMainViewController ()

@property(nonatomic, strong) UINavigationController *driverTestNavigationViewController;
@end

@implementation SWDriverTestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUpNavigationBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark INIT/Set up UI


-(void) makeUpNavigationBarView
{
    _driverTestNavigationViewController = [[UINavigationController alloc] init];
    _driverTestNavigationViewController.view.backgroundColor = [UIColor clearColor];
    _driverTestNavigationViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    SWDriverTestMainItemsViewController *vc = [[SWDriverTestMainItemsViewController alloc] init];
    vc.view.backgroundColor = [UIColor lightGrayColor];
    
    [_driverTestNavigationViewController pushViewController:vc animated:NO];
    [self.view addSubview:_driverTestNavigationViewController.view];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_driverTestNavigationViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_driverTestNavigationViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_driverTestNavigationViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_driverTestNavigationViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
}


@end
