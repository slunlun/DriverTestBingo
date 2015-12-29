//
//  SWGoodIdeasViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/29/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWGoodIdeasViewController.h"

@interface SWGoodIdeasViewController ()

@end

@implementation SWGoodIdeasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
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
