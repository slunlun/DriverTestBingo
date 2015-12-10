//
//  SWRootNavigationController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWRootNavigationController.h"
#import "SWMainContentTabBarController.h"
#import "SWSideMenuContentViewController.h"
#import "SWMainViewController.h"
@interface SWRootNavigationController ()

@end

@implementation SWRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *sideMenuVC = [[UIViewController alloc] init];
    sideMenuVC.view.backgroundColor = [UIColor grayColor];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    SWMainContentTabBarController *mainContentVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MAIN_CONTENT_VC"];
    mainContentVC.view.backgroundColor = [UIColor greenColor];
    
    SWMainViewController *mainVC = [[SWMainViewController alloc] initWithContentView:mainContentVC sideMenuView:sideMenuVC];
    self.viewControllers = @[mainVC];
    // Do any additional setup after loading the view.
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

@end
