//
//  SWQuestionPageViewController.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/19.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import "SWQuestionPageViewController.h"
#import "UIButton+SWUIButtonExt.h"
#import "FlexibleAlignButton.h"

@interface SWQuestionPageViewController () <UIScrollViewDelegate>


@end

@implementation SWQuestionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self makeUpNavigationBarView];
}

#pragma mark INIT/SETTER/GETTER
-(void) makeUpNavigationBarView
{
    FlexibleAlignButton *questionIndexBtn = [[FlexibleAlignButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    questionIndexBtn.alignment = kButtonAlignmentImageTop;
    questionIndexBtn.gap = 2;
    [questionIndexBtn setImage:[UIImage imageNamed:@"questionIndex"] forState:UIControlStateNormal];
    [questionIndexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld", ([self currentPageNum] + 1), self.contentViewsArray.count] forState:UIControlStateNormal];
    questionIndexBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    questionIndexBtn.titleLabel.backgroundColor = [UIColor yellowColor];
    [questionIndexBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
   // [questionIndexBtn centerImageAndTitle:1.0];
    
    UIButton *markBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    [markBtn setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
    
    [markBtn setTitle: NSLocalizedString(@"MarkQuestion", NULL) forState:UIControlStateNormal];
    markBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [markBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [markBtn addTarget:self action:@selector(markQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [markBtn centerImageAndTitle:1.0];
    
    
    UIBarButtonItem *btnQuestionIndex = [[UIBarButtonItem alloc] initWithCustomView:questionIndexBtn];
    UIBarButtonItem *btnMakrQuestion = [[UIBarButtonItem alloc] initWithCustomView:markBtn];
    NSArray *barBtnItemArray = @[btnMakrQuestion, btnQuestionIndex];
    self.navigationItem.rightBarButtonItems = barBtnItemArray;
}
#pragma mark UI response
-(void) updataQuestionIndexTitle
{
    UIButton *btnQuestionIndex = (UIButton *)self.navigationItem.rightBarButtonItems[1].customView;
    [btnQuestionIndex setTitle:[NSString stringWithFormat:@"%ld/%ld", ([self currentPageNum] + 1), self.contentViewsArray.count] forState:UIControlStateNormal];
}

-(void) markQuestion:(UIButton *) markBtn
{
    
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updataQuestionIndexTitle];
   
}
@end
