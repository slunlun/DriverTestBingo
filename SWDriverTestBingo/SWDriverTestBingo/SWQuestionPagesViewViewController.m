//
//  SWQuestionPagesViewViewController.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/15.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import "SWQuestionPagesViewViewController.h"

@interface SWQuestionPagesViewViewController ()
@property(nonatomic, strong) SWPageViewController *pagesVC;
@property(nonatomic, strong) NSMutableArray *questionItemViews;
@end

@implementation SWQuestionPagesViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    UIView *yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    [self.questionItemViews addObject:redView];
    [self.questionItemViews addObject:yellowView];
    [self.questionItemViews addObject:greenView];
    _pagesVC = [[SWPageViewController alloc] initWithContentViews:self.questionItemViews];
    [self addChildViewController:_pagesVC];
    [self.view addSubview:_pagesVC.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark INIT/SETTER/GETTER
-(NSMutableArray *) questionItemViews
{
    if (_questionItemViews == nil) {
        _questionItemViews = [[NSMutableArray alloc] init];
    }
    return _questionItemViews;
}

@end
