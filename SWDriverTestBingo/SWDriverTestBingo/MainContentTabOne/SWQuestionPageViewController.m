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
#import "SWTestQuestionCell.h"
#import "SWQuestionStatusHeaderViewController.h"

#define SW_QUESTION_ITESM_STATUS_VIEW_INIT_HIEGHT 80.0
@interface SWQuestionPageViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic) NSInteger pageNumBeforePageScroll;

@property(nonatomic, strong) UIView *dragMoveView;
@property(nonatomic, strong) SWQuestionStatusHeaderViewController *dragMoveViewHeader;
@property(nonatomic) NSInteger initHeight;
@property(nonatomic) NSInteger beginHeight;
@property(nonatomic) NSInteger maxHeight;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic, strong) UICollectionView *contentCollectionView;
@property(nonatomic) CGPoint beginPoint;
@end

@implementation SWQuestionPageViewController

-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type questinPageType:(TestQuestionViewType) questionPageType
{
    _questionPageType = questionPageType;
    return [super initWithContentViewsCount:pageCount type:type];
}
-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type switchToPage:(NSUInteger) pageNum questinPageType:(TestQuestionViewType) questionPageType
{
    _questionPageType = questionPageType;
    return [super initWithContentViewsCount:pageCount type:type switchToPage:questionPageType];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.pageNumBeforePageScroll = self.initPageNum;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.navigationController.navigationBarHidden = NO;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    [self makeUpNavigationBarView];
    if (self.questionPageType == kTestQuestionViewTest) {
        [self AddTestQuestionStatusItemsView];
    }

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



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.questionPageType == kTestQuestionViewTest) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[self currentPageNum] inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma makr - For Questions Test Page
-(void) AddTestQuestionStatusItemsView
{
    _dragMoveView = [[UIView alloc] init];
    _dragMoveView.backgroundColor = [UIColor whiteColor];
    _dragMoveView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panViewResponse:)];
    [_dragMoveView addGestureRecognizer:pan];
    self.initHeight = SW_QUESTION_ITESM_STATUS_VIEW_INIT_HIEGHT;
    
    [self.view addSubview:_dragMoveView];
    [self.view bringSubviewToFront:_dragMoveView];
    NSDictionary *viewDict = @{@"dragMoveView":_dragMoveView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dragMoveView]|" options:0 metrics:nil views:viewDict]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_dragMoveView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
    [self.view addConstraint:self.heightConstraint];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(50.0, 50.0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 0.0f;
    
    _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    _contentCollectionView.dataSource = self;
    _contentCollectionView.delegate = self;
    _contentCollectionView.bounces = YES;
    [_contentCollectionView setShowsHorizontalScrollIndicator:NO];
    [_contentCollectionView setShowsVerticalScrollIndicator:NO];
    _contentCollectionView.backgroundColor = [UIColor clearColor];
    
    
    [_contentCollectionView registerNib:[UINib nibWithNibName:@"SWTestQuestionCell" bundle:nil] forCellWithReuseIdentifier:@"SW_QUESTION_NUM_CELL"];
    _contentCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dragMoveView addSubview:_contentCollectionView];
    viewDict = @{@"collectionView":_contentCollectionView};
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewDict]];
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[collectionView]|" options:0 metrics:nil views:viewDict]];
    
    _dragMoveViewHeader = [[SWQuestionStatusHeaderViewController alloc] initWithNibName:@"SWQuestionStatusHeaderViewController" bundle:nil];
    
    _dragMoveViewHeader.view.backgroundColor = [UIColor redColor];
    _dragMoveViewHeader.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dragMoveView addSubview:_dragMoveViewHeader.view];
    viewDict = @{@"headerView":_dragMoveViewHeader.view};
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:nil views:viewDict]];
    [self.dragMoveView addConstraint:[NSLayoutConstraint constraintWithItem:_dragMoveViewHeader.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dragMoveView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.dragMoveView addConstraint:[NSLayoutConstraint constraintWithItem:_dragMoveViewHeader.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0]];
    _dragMoveViewHeader.headImage.image = [UIImage imageNamed:@"List"];
    _dragMoveViewHeader.headImage.backgroundColor = [UIColor greenColor];
    
    
}

-(void) panViewResponse:(UIPanGestureRecognizer *) panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = [panGesture locationInView:self.view];
        self.maxHeight = (self.view.frame.size.height * 2)/3;
        self.beginHeight = self.dragMoveView.frame.size.height;
    }else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [panGesture locationInView:self.view];
        CGFloat newY = self.beginPoint.y - newPoint.y;
        [self.view removeConstraint:self.heightConstraint];
        
        if (newY + self.beginHeight <= self.initHeight) {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
            
        }else if(newY + self.beginHeight >= self.maxHeight)
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.maxHeight];
            
        }else
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:newY + self.beginHeight];
        }
        
        [self.view addConstraint:self.heightConstraint];
        [self.view layoutIfNeeded];
    }else if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint newPoint = [panGesture locationInView:self.view];
        CGFloat newY = self.beginPoint.y - newPoint.y;
        [self.view removeConstraint:self.heightConstraint];
        
        
        if (newY < 0) { // down
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
        }else if(newY > 0) // up
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.maxHeight];
        }
        
        
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addConstraint:self.heightConstraint];
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWTestQuestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SW_QUESTION_NUM_CELL" forIndexPath:indexPath];
    NSString * stringTitle = [NSString stringWithFormat:@"%ld", (long)(indexPath.row + 1)];
    [cell.SWQuestionNumLabel setText:stringTitle];
    [cell.SWQuestionNumLabel setBackgroundColor:[UIColor colorWithRed:(180.0f/255.0f) green:(228.0f/255.0f) blue:(247.0f/255.0f) alpha:0.6]];
    cell.SWQuestionNumLabel.layer.cornerRadius = 25.0f;
    cell.SWQuestionNumLabel.layer.masksToBounds = YES;
    [cell.SWQuestionNumLabel.layer setBorderWidth:1.0];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self currentPageNum]) {
        return;
    }
    [self releasePageAtIndex:[self currentPageNum]];
    [self releasePageAtIndex:[self currentPageNum] - 1];
    [self releasePageAtIndex:[self currentPageNum] + 1];
    
    [self changeToPage:indexPath.row];
    
    [self downTestQuestionItemStatusView];
}

-(void) upTestQuestionItemStatusView
{
     [self.view removeConstraint:self.heightConstraint];
     self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.maxHeight];
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view addConstraint:self.heightConstraint];
        [self.view layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
    
    }];

}

-(void) downTestQuestionItemStatusView
{
    [self.view removeConstraint:self.heightConstraint];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view addConstraint:self.heightConstraint];
        [self.view layoutIfNeeded];
        
        
    } completion:^(BOOL finished) {
        if (finished) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:[self currentPageNum] inSection:0];
            [self.contentCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    }];

}
@end
