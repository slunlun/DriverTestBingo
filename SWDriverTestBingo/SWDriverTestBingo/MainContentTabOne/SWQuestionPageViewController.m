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
#import "SWQuestionItems+CoreDataProperties.h"
#import "SWDriverTestQuestionView.h"
#import "SWLoginUser.h"

@interface SWQuestionPageViewController () <UIScrollViewDelegate>
@property(nonatomic) NSInteger pageNumBeforePageScroll;

@end

@implementation SWQuestionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.pageNumBeforePageScroll = self.initPageNum;
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

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.pageNumBeforePageScroll = [self currentPageNum];
    if (self.questionPageType == kTestQuestionViewSequence) { // 只有顺序答题 才需要保存答题页数
        [SWLoginUser savaUserQuestionStatus:[NSNumber numberWithInteger:[self currentPageNum]]];
    }
}

#pragma mark INIT/SETTER/GETTER
-(void) makeUpNavigationBarView
{
    FlexibleAlignButton *questionIndexBtn = [[FlexibleAlignButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    questionIndexBtn.alignment = kButtonAlignmentImageTop;
    questionIndexBtn.gap = 2;
    [questionIndexBtn setImage:[UIImage imageNamed:@"questionIndex"] forState:UIControlStateNormal];
    [questionIndexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld", ([self currentPageNum] + 1), self.pageCount] forState:UIControlStateNormal];
    questionIndexBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [questionIndexBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
   // [questionIndexBtn centerImageAndTitle:1.0];
    
    UIButton *markBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    SWQuestionItems *questionItem = [self currentQuestionItem];
    if (questionItem.markQuestionsLib) {
        [markBtn setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
    }else
    {
        [markBtn setImage:[UIImage imageNamed:@"markNot"] forState:UIControlStateNormal];
    }
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
    [btnQuestionIndex setTitle:[NSString stringWithFormat:@"%ld/%ld", ([self currentPageNum] + 1), self.pageCount] forState:UIControlStateNormal];
}

-(void) updateMarkBtn
{
    SWQuestionItems *question = [self currentQuestionItem];
    UIButton *btnMark = (UIButton *)self.navigationItem.rightBarButtonItems[0].customView;
    if (question.markQuestionsLib) {
        [btnMark setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
    }else
    {
        [btnMark setImage:[UIImage imageNamed:@"markNot"] forState:UIControlStateNormal];
    }

}

-(void) markQuestion:(UIButton *) markBtn
{
    SWQuestionItems *question = [self currentQuestionItem];
    UIButton *btnMark = (UIButton *)self.navigationItem.rightBarButtonItems[0].customView;
    if (question.markQuestionsLib) {
        [SWLoginUser unmarkQuestion:question];
        [btnMark setImage:[UIImage imageNamed:@"markNot"] forState:UIControlStateNormal];
    }else
    {
        [SWLoginUser markQuestion:question];
        [btnMark setImage:[UIImage imageNamed:@"mark"] forState:UIControlStateNormal];
    }
}
#pragma mark Question Operation
- (SWQuestionItems *) currentQuestionItem
{
    return [self.delegate swpageViewController:self pageDataForIndex:[self currentPageNum]];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updataQuestionIndexTitle];
    [self updateMarkBtn];
    
    // 当前的pageVC为优化模式，需要显示实时补充新的page
    NSInteger pageNum = [self currentPageNum];
    if (self.pageNumBeforePageScroll != pageNum) {
        NSInteger pageChange = pageNum - self.pageNumBeforePageScroll;
        if (pageChange > 0) {
            // generate next pages
            [self createPageAtIndex:(pageNum + 1)];
            // release page that can not see
            [self releasePageAtIndex:(pageNum - 2)];
            NSLog(@"The subview count is %ld", self.scrollView.subviews.count);
            
        }else if(pageChange < 0)
        {
            // generate pre pages
            [self createPageAtIndex:(pageNum - 1)];
            // release page that can not see
            [self releasePageAtIndex:(pageNum + 2)];
             NSLog(@"The subview count is %ld", self.scrollView.subviews.count);
            
        }
        self.pageNumBeforePageScroll = pageNum;
    }
}

@end
