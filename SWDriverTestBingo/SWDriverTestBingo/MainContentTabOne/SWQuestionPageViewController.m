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
#import "SWDragToMoveView.h"
#import "NSTimer+SWCountDownTimer.h"
#import "SWDriverTestBigoDef.h"
#import "SWMessageBox.h"

#define SW_QUESTION_ITESM_STATUS_VIEW_INIT_HIEGHT 80.0
#define SW_BACK_GROUND_COVER_VIEW_TAG 6001
#define TEST_PAUSE_MESSAGE_BOX_TAG 6002
#define COUNT_DOWN_TIME 2700  // 45 mins
#define QUESTION_STATUS_CELL_SIZE 46
@interface SWQuestionPageViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic) NSInteger pageNumBeforePageScroll;

@property(nonatomic, strong) SWDragToMoveView *dragMoveView;
@property(nonatomic, strong) SWQuestionStatusHeaderViewController *dragMoveViewHeader;
@property(nonatomic) NSInteger initHeight;
@property(nonatomic) NSInteger beginHeight;
@property(nonatomic) NSInteger maxHeight;
@property(nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property(nonatomic, strong) UICollectionView *contentCollectionView;
@property(nonatomic, strong) UIButton *dragViewHeadButton;

@property(nonatomic, strong) UILabel *testWrongNum;
@property(nonatomic, strong) UILabel *testRightNum;

@property(nonatomic) CGPoint beginPoint;

@property(nonatomic, strong) NSTimer *countDownTimer;
@property(nonatomic, strong) FlexibleAlignButton *timerCountdownButton;
@property(nonatomic) NSInteger examTimeLeft;
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
    if (self.questionPageType == kTestQuestionViewTest) {
        _examTimeLeft = COUNT_DOWN_TIME;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveResponse:) name:APP_WILL_RESIGNACTIVE_NOTIFICATION object:nil];
        
    }
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
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountDownTime:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes]; // add timer to other mode, avoid UI event interupts
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
    
    if (self.questionPageType != kTestQuestionViewTest) {
        
        FlexibleAlignButton *questionIndexBtn = [[FlexibleAlignButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        questionIndexBtn.alignment = kButtonAlignmentImageTop;
        questionIndexBtn.gap = 2;
        [questionIndexBtn setImage:[UIImage imageNamed:@"questionIndex"] forState:UIControlStateNormal];
        [questionIndexBtn setTitle:[NSString stringWithFormat:@"%ld/%ld", ([self currentPageNum] + 1), self.pageCount] forState:UIControlStateNormal];
        questionIndexBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [questionIndexBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        UIBarButtonItem *btnQuestionIndex = [[UIBarButtonItem alloc] initWithCustomView:questionIndexBtn];
        UIBarButtonItem *btnMakrQuestion = [[UIBarButtonItem alloc] initWithCustomView:markBtn];
        NSArray *barBtnItemArray = @[btnMakrQuestion, btnQuestionIndex];
        self.navigationItem.rightBarButtonItems = barBtnItemArray;
        
    }else if(self.questionPageType == kTestQuestionViewTest)
    {
        _timerCountdownButton = [[FlexibleAlignButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        _timerCountdownButton.alignment = kButtonAlignmentImageTop;
        _timerCountdownButton.gap = 2;
        [_timerCountdownButton setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
        [_timerCountdownButton setTitle:[self convertLeftTimeToString:self.examTimeLeft] forState:UIControlStateNormal];
        _timerCountdownButton.titleLabel.font = [UIFont systemFontOfSize:9];
        [_timerCountdownButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];


        FlexibleAlignButton *submitTest = [[FlexibleAlignButton alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [submitTest addTarget:self action:@selector(submitPaperPressed:) forControlEvents:UIControlEventTouchUpInside];
        submitTest.alignment = kButtonAlignmentImageTop;
        submitTest.gap = 2;
        [submitTest setImage:[UIImage imageNamed:@"paper"] forState:UIControlStateNormal];
        [submitTest setTitle:NSLocalizedString(@"SubmitPaper", nil) forState:UIControlStateNormal];
        submitTest.titleLabel.font = [UIFont systemFontOfSize:9];
        [submitTest setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        UIBarButtonItem *btnMakrQuestion = [[UIBarButtonItem alloc] initWithCustomView:markBtn];
        UIBarButtonItem *btnExamLeft = [[UIBarButtonItem alloc] initWithCustomView:_timerCountdownButton];
        UIBarButtonItem *btnSubmitText = [[UIBarButtonItem alloc] initWithCustomView:submitTest];
        NSArray *barBtnItemArray = @[btnMakrQuestion, btnExamLeft, btnSubmitText];
        self.navigationItem.rightBarButtonItems = barBtnItemArray;
        
        

    }
   
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark UI response
-(void) dragToMoveViewHeadButtonClick:(UIButton *) headButton
{
    NSLog(@"HeadButton Click");
    if(self.dragMoveView.status == dragToMoveViewUp)
    {
        [self downTestQuestionItemStatusView];
        
    }else if(self.dragMoveView.status == dragToMoveViewDown)
    {
        [self upTestQuestionItemStatusView];
    }
}


-(void) submitPaperPressed:(UIButton *) btn
{
    NSLog(@"Submit paper");
}

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
    if (self.questionPageType != kTestQuestionViewTest) {
        [self updataQuestionIndexTitle];
    }
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
    if (self.questionPageType == kTestQuestionViewTest && self.dragMoveView.status == dragToMoveViewDown) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:[self currentPageNum] inSection:0];
        [self.contentCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

#pragma makr - For Questions Test Page
-(void) AddTestQuestionStatusItemsView
{
    _dragMoveView = [[SWDragToMoveView alloc] init];
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
    flowLayout.itemSize = CGSizeMake(QUESTION_STATUS_CELL_SIZE, QUESTION_STATUS_CELL_SIZE);
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
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(25)-[collectionView]|" options:0 metrics:nil views:viewDict]];
    
    _dragViewHeadButton = [[UIButton alloc] init];
    _dragViewHeadButton.backgroundColor = [UIColor whiteColor];
    _dragViewHeadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_dragViewHeadButton setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
    [_dragViewHeadButton addTarget:self action:@selector(dragToMoveViewHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _dragViewHeadButton.layer.cornerRadius = 5.0;
    _dragViewHeadButton.layer.borderWidth = 0.5;
    _dragViewHeadButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_dragViewHeadButton addGestureRecognizer:pan];
    
    [self.dragMoveView addSubview:_dragViewHeadButton];
    viewDict = @{@"headerButton":_dragViewHeadButton};
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerButton]|" options:0 metrics:nil views:viewDict]];
    [self.dragMoveView addConstraint:[NSLayoutConstraint constraintWithItem:_dragViewHeadButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.dragMoveView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.dragMoveView addConstraint:[NSLayoutConstraint constraintWithItem:_dragViewHeadButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25.0]];
    
    UILabel *rightTitleLabel = [[UILabel alloc] init];
    rightTitleLabel.text = NSLocalizedString(@"Right", nil);
    rightTitleLabel.font = [UIFont systemFontOfSize:9];
    rightTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _testRightNum = [[UILabel alloc] init];
    _testRightNum.text = @"0";
    _testRightNum.font = [UIFont systemFontOfSize:8];
    _testRightNum.textColor = [UIColor greenColor];
    _testWrongNum.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel *wrongTitleLabel = [[UILabel alloc] init];
    wrongTitleLabel.text = NSLocalizedString(@"Wrong", nil);
    wrongTitleLabel.font = [UIFont systemFontOfSize:9];
    wrongTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    _testWrongNum = [[UILabel alloc] init];
    _testWrongNum.text = @"0";
    _testWrongNum.font = [UIFont systemFontOfSize:8];
    _testWrongNum.textColor = [UIColor redColor];
    _testWrongNum.translatesAutoresizingMaskIntoConstraints = NO;
    
    viewDict = @{@"rightTitleLabel":rightTitleLabel, @"testRightNum":_testRightNum, @"wrongTitleLabel":wrongTitleLabel, @"testWrongNum":_testWrongNum};
    NSDictionary *viewMetric = @{@"titleLabelWidth":@15, @"numLabelWidth":@15};
    
    [_dragViewHeadButton addSubview:rightTitleLabel];
    [_dragViewHeadButton addSubview:_testRightNum];
    [_dragViewHeadButton addSubview:wrongTitleLabel];
    [_dragViewHeadButton addSubview:_testWrongNum];
    
    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightTitleLabel]|" options:0 metrics:nil views:viewDict]];
    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[testRightNum]|" options:0 metrics:nil views:viewDict]];
//    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrongTitleLabel]|" options:0 metrics:nil views:viewDict]];
//    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[testWrongNum]|" options:0 metrics:nil views:viewDict]];
    
    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightTitleLabel(==15)][testRightNum(==15)]" options:NSLayoutFormatAlignAllRight metrics:nil views:viewDict]];
    
    
    self.dragMoveView.status = dragToMoveViewDown;
    self.maxHeight = (self.view.frame.size.height * 2)/3;
}

-(void) panViewResponse:(UIPanGestureRecognizer *) panGesture
{
    NSLog(@"Pan Pan");
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.beginPoint = [panGesture locationInView:self.view];
        
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
//            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.initHeight];
//            self.dragMoveView.status = dragToMoveViewDown;
            [self downTestQuestionItemStatusView];
            
        }else if(newY > 0) // up
        {
            [self upTestQuestionItemStatusView];
//            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.dragMoveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.maxHeight];
//            self.dragMoveView.status = dragToMoveViewUp;

        }
        
//        [UIView animateWithDuration:0.5 animations:^{
//            
//            [self.view addConstraint:self.heightConstraint];
//            [self.view layoutIfNeeded];
//            
//            
//        } completion:^(BOOL finished) {
//            if(self.dragMoveView.status == dragToMoveViewDown){
//                NSIndexPath *index = [NSIndexPath indexPathForRow:[self currentPageNum] inSection:0];
//                [self.contentCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//                [self removeBackgroundConverView];
//            }
//            
//            if (self.dragMoveView.status == dragToMoveViewUp) {
//                [self addBackgroudConverView];
//                [self.view bringSubviewToFront:self.dragMoveView];
//            }
//        }];
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
    cell.SWQuestionNumLabel.layer.cornerRadius = QUESTION_STATUS_CELL_SIZE / 2;
    cell.SWQuestionNumLabel.layer.masksToBounds = YES;
    [cell.SWQuestionNumLabel.layer setBorderWidth:0.3];
    cell.SWQuestionNumLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
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
        [self addBackgroudConverView];
        [self.view bringSubviewToFront:self.dragMoveView];
        [self.dragViewHeadButton setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
        self.dragMoveView.status = dragToMoveViewUp;
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
            [self removeBackgroundConverView];
            [self.dragViewHeadButton setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
            self.dragMoveView.status = dragToMoveViewDown;
        }
    }];

}

#pragma mark - Private Method
-(NSString *) convertLeftTimeToString:(NSInteger) leftTime
{
    NSInteger min = leftTime / 60;
    NSInteger sec = leftTime % 60;
    NSString *leftTimeStr = [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    return leftTimeStr;
}

-(void) updateCountDownTime:(NSTimer *) timer
{
    NSString *timeLeftStr = [self convertLeftTimeToString:--self.examTimeLeft];
    if (self.examTimeLeft < 0) {
        [timer invalidate];
        
    }else
    {
        [self.timerCountdownButton setTitle:timeLeftStr forState:UIControlStateNormal];
    }
}

-(void) addBackgroudConverView
{
    if (![self.view viewWithTag:SW_BACK_GROUND_COVER_VIEW_TAG]) {
        UIView *backGroudView = [[UIView alloc] init];
        backGroudView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        backGroudView.translatesAutoresizingMaskIntoConstraints = NO;
        backGroudView.tag = SW_BACK_GROUND_COVER_VIEW_TAG;
        [self.view addSubview:backGroudView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    }
}

-(void) removeBackgroundConverView
{
    UIView *backgourndView = [self.view viewWithTag:SW_BACK_GROUND_COVER_VIEW_TAG];
    [backgourndView removeFromSuperview];
    
}

#pragma mark - Notification Response
-(void) appWillResignActiveResponse:(NSNotification *) notification
{
    SWMessageBox *messageBox = [[SWMessageBox alloc]initWithTitle:@"共100题，还剩100题未做" boxImage:[UIImage imageNamed:@"testUserHead"] boxType:SWMessageBoxType_ContinueTest completeBlock:^(NSInteger btnIndex) {
            
            [self removeBackgroundConverView];
            [self.countDownTimer resumeTimer];
            
        }];
        
    messageBox.tag = TEST_PAUSE_MESSAGE_BOX_TAG;
    
    [self addBackgroudConverView];
    [messageBox showMessageBoxInView:self.view];
    [self.countDownTimer pauseTimer];
    
}

#pragma mark - For test Page View
-(void) testTimeOut
{
    
}
@end
