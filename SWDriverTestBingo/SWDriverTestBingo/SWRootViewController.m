//
//  SWRootViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/11/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWRootViewController.h"
#import "SWMainContentTabBarController.h"
#import "SWSideMenuContentViewController.h"
#import "SWMainViewController.h"

@interface SWRootViewController ()

@end

@implementation SWRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWSideMenuContentViewController *sideMenuVC = [[SWSideMenuContentViewController alloc] init];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    

    SWMainContentTabBarController *tabBarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MAIN_CONTENT_VC"];
//    SWMainContentTabBarController *mainContentVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MAIN_CONTENT_VC"];
//    mainContentVC.view.backgroundColor = [UIColor greenColor];
    
    SWMainViewController *mainVC = [[SWMainViewController alloc] initWithContentView:tabBarController sideMenuView:sideMenuVC];
    [self addChildViewController:mainVC];
    [self.view addSubview:mainVC.view];

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
