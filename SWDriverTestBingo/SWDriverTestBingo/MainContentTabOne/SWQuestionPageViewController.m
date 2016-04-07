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

#define SW_QUESTION_ITESM_STATUS_VIEW_INIT_HIEGHT 90.0
#define SW_BACK_GROUND_COVER_VIEW_TAG 5001

#define TEST_PAUSE_MESSAGE_BOX_TAG 6002
#define TEST_PAUSE_MESSAGE_BACK_GROUND_TAG 5002

#define TEST_SUBMIT_MESSAGE_BOX_TAG 6003
#define TEST_SUBMIT_MESSAGE_BACK_GROUND_TAG 5003

#define COUNT_DOWN_TIME 2700  // 45 mins
#define QUESTION_STATUS_CELL_SIZE 46

@class SWTestScoreCounter;
@protocol SWTestScoreCounterDelegate <NSObject>

-(void) userDidAnserQuestion:(NSInteger) questionIndex result:(BOOL) isRight scoreCounter:(SWTestScoreCounter *) scoreCounter;

@end

typedef enum AnswerStatus{
    kAnswerStatusUnset = 1,
    kAnswerStatusRight = 2,
    kAnswerStatusWrong = 3,
}AnswerStatus;
@interface SWTestScoreCounter : NSObject
-(void) answerQuestionAtIndex:(NSInteger) questionIndex result:(NSDictionary *) result;
-(NSArray *) answeredStatus;
-(NSInteger) testScore;
@property(nonatomic, weak) id<SWTestScoreCounterDelegate> delegate;
@property(nonatomic) NSInteger rightAnswerNum;
@property(nonatomic) NSInteger wrongAnswerNum;
@property(nonatomic) NSInteger unDoneAnswerNum;
@end

@interface SWTestScoreCounter()
@property(nonatomic, strong) NSMutableArray *answerStatusArray;
@end
@implementation SWTestScoreCounter

-(instancetype) init
{
    self = [super init];
    if (self) {
        _unDoneAnswerNum = 100;
        _rightAnswerNum = 0;
        _wrongAnswerNum = 0;
    }
    return self;
}
-(NSMutableArray *) answerStatusArray
{
    if (_answerStatusArray == nil) {
        _answerStatusArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 100; ++i) {
            [_answerStatusArray addObject:[NSNumber numberWithInteger:kAnswerStatusUnset]];
        }
        
    }
    return _answerStatusArray;
}

-(void) answerQuestionAtIndex:(NSInteger) questionIndex result:(NSDictionary *) result
{
    NSNumber *answerResult = nil;
    BOOL isRight = NO;
    --self.unDoneAnswerNum;
    NSString *answerStatusStr = (NSString *)result[SELECTED_ANSWER__USERINFO_IS_RIGHT_KEY];
    if ([answerStatusStr isEqualToString:@"RIGHT"]) {
        answerResult = [NSNumber numberWithInteger:kAnswerStatusRight];
        isRight = YES;
        ++self.rightAnswerNum;
        
    }else
    {
        answerResult = [NSNumber numberWithInteger:kAnswerStatusWrong];
        isRight = NO;
        ++self.wrongAnswerNum;
    }
    
    [self.answerStatusArray insertObject:answerResult atIndex:questionIndex];
    if ([self.delegate respondsToSelector:@selector(userDidAnserQuestion:result:scoreCounter:)]) {
        [self.delegate userDidAnserQuestion:questionIndex result:isRight scoreCounter:self];
    }
}

-(NSArray *) answeredStatus
{
    return self.answerStatusArray;
}

-(AnswerStatus) answeredStatusAtIndex:(NSInteger) index
{
    return (AnswerStatus)((NSNumber *)self.answerStatusArray[index]).integerValue;
}
-(NSInteger) testScore
{
    return self.rightAnswerNum;
}

@end


@interface SWQuestionPageViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SWTestScoreCounterDelegate>
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
@property(nonatomic, strong) SWTestScoreCounter *scoreCounter;
@property(nonatomic, strong) UIColor *testCellDefaultColor;
@property(nonatomic, strong) UIColor *testCellRightColor;
@property(nonatomic, strong) UIColor *testCellWrongColor;
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
    return [super initWithContentViewsCount:pageCount type:type switchToPage:pageNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.pageNumBeforePageScroll = self.initPageNum;
    if (self.questionPageType == kTestQuestionViewTest) {
        _examTimeLeft = COUNT_DOWN_TIME;
        _scoreCounter = [[SWTestScoreCounter alloc] init];
        _scoreCounter.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveResponse:) name:APP_WILL_RESIGNACTIVE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSelectedTestAnswer:) name:USER_SELECTED_TEST_ANSWER_NOTIFICATION object:nil];
        
        _testCellDefaultColor = [UIColor whiteColor];
        _testCellRightColor = [UIColor colorWithRed:(206.0f/255.0f) green:(248.0f/255.0f) blue:(205.0f/255.0f) alpha:0.6];
        _testCellWrongColor = [UIColor colorWithRed:(252.0f/255.0f) green:(211.0f/255.0f) blue:(213.0f/255.0f) alpha:0.6];
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
        NSLog(@"The page Num is %ld", (long)[self currentPageNum]);
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
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (![window viewWithTag:TEST_SUBMIT_MESSAGE_BOX_TAG]) {
        [self addWindowBackgroudConverView:TEST_SUBMIT_MESSAGE_BACK_GROUND_TAG];
        if (self.scoreCounter.unDoneAnswerNum != 0) {
            NSString *title = [NSString stringWithFormat:@"您还有%ld题未做，确定交卷吗？", self.scoreCounter.unDoneAnswerNum];
            SWMessageBox *messageBox = [[SWMessageBox alloc] initWithTitle:title boxImage:[UIImage imageNamed:@"testUserHead"] boxType:SWMessageBoxType_OKCancel buttonTitles:@[NSLocalizedString(@"ContinueTest", nil), NSLocalizedString(@"SubmitPaper", nil)] completeBlock:^(NSInteger selectIndex) {
                if (selectIndex == 0) {  // go on test
                    [self removeBackgroundConverView:TEST_SUBMIT_MESSAGE_BACK_GROUND_TAG];
                }else if(selectIndex == 1)
                {
                    [self removeBackgroundConverView:TEST_SUBMIT_MESSAGE_BACK_GROUND_TAG];
                    [self submitTestPaper];
                }
            }];
            
            messageBox.tag = TEST_SUBMIT_MESSAGE_BOX_TAG;
        
            
            [messageBox showMessageBoxInView:window];
            
        }else
        {
            [self submitTestPaper];
        }
    }
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
    [self.dragMoveView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(30)-[collectionView]|" options:0 metrics:nil views:viewDict]];
    
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
    [self.dragMoveView addConstraint:[NSLayoutConstraint constraintWithItem:_dragViewHeadButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0]];
    
    UILabel *rightTitleLabel = [[UILabel alloc] init];
    rightTitleLabel.text = NSLocalizedString(@"Right", nil);
    rightTitleLabel.font = [UIFont systemFontOfSize:15];
    rightTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //rightTitleLabel.userInteractionEnabled = NO;
    
    _testRightNum = [[UILabel alloc] init];
    _testRightNum.text = @"0";
    _testRightNum.font = [UIFont systemFontOfSize:15];
    _testRightNum.textColor = [UIColor greenColor];
    _testRightNum.translatesAutoresizingMaskIntoConstraints = NO;
   // _testRightNum.userInteractionEnabled = NO;
    
    UILabel *wrongTitleLabel = [[UILabel alloc] init];
    wrongTitleLabel.text = NSLocalizedString(@"Wrong", nil);
    wrongTitleLabel.font = [UIFont systemFontOfSize:15];
    wrongTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //wrongTitleLabel.userInteractionEnabled = NO;
    
    _testWrongNum = [[UILabel alloc] init];
    _testWrongNum.text = @"0";
    _testWrongNum.font = [UIFont systemFontOfSize:15];
    _testWrongNum.textColor = [UIColor redColor];
    _testWrongNum.translatesAutoresizingMaskIntoConstraints = NO;
    //_testWrongNum.userInteractionEnabled = NO;
    
    
   
    UIView *testScoreView = [[UIView alloc] init];
    testScoreView.translatesAutoresizingMaskIntoConstraints = NO;
    testScoreView.backgroundColor = [UIColor clearColor];
    testScoreView.userInteractionEnabled = NO;
    
     viewDict = @{@"rightTitleLabel":rightTitleLabel, @"testRightNum":_testRightNum, @"wrongTitleLabel":wrongTitleLabel, @"testWrongNum":_testWrongNum, @"testScoreView":testScoreView};
    
    [_dragViewHeadButton addSubview:testScoreView];
    [testScoreView addSubview:rightTitleLabel];
    [testScoreView addSubview:_testRightNum];
    [testScoreView addSubview:wrongTitleLabel];
    [testScoreView addSubview:_testWrongNum];
    
    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[testScoreView]|" options:0 metrics:nil views:viewDict]];
    [_dragViewHeadButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[testScoreView(==90)]-|" options:0 metrics:nil views:viewDict]];
    
    [testScoreView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rightTitleLabel]|" options:0 metrics:nil views:viewDict]];
    [testScoreView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[testRightNum]|" options:0 metrics:nil views:viewDict]];
    [testScoreView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[wrongTitleLabel]|" options:0 metrics:nil views:viewDict]];
    [testScoreView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[testWrongNum]|" options:0 metrics:nil views:viewDict]];
    [testScoreView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightTitleLabel]-[testRightNum]-[wrongTitleLabel]-[testWrongNum]-|" options:0 metrics:nil views:viewDict]];
    
    
    
    
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

            [self downTestQuestionItemStatusView];
            
        }else if(newY > 0) // up
        {
            [self upTestQuestionItemStatusView];
        }
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
    AnswerStatus status = [self.scoreCounter answeredStatusAtIndex:indexPath.row];
    if (status == kAnswerStatusUnset) {
        
        [cell.SWQuestionNumLabel setBackgroundColor:self.testCellDefaultColor];
        
    }else if(status == kAnswerStatusRight)
    {
        [cell.SWQuestionNumLabel setBackgroundColor:self.testCellRightColor];
        
    }else if(status == kAnswerStatusWrong)
    {
        [cell.SWQuestionNumLabel setBackgroundColor:self.testCellWrongColor];
    }
    
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
        [self addBackgroudConverView:SW_BACK_GROUND_COVER_VIEW_TAG];
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
            [self removeBackgroundConverView:SW_BACK_GROUND_COVER_VIEW_TAG];
            [self.dragViewHeadButton setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateNormal];
            self.dragMoveView.status = dragToMoveViewDown;
        }
    }];

}

#pragma mark - Private Method
-(void) submitTestPaper
{
    
}
-(NSString *) convertLeftTimeToString:(NSInteger) leftTime
{
    NSInteger min = leftTime / 60;
    NSInteger sec = leftTime % 60;
    NSString *leftTimeStr = [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    return leftTimeStr;
}

-(void) changeToNextTestPage
{
    [self releasePageAtIndex:[self currentPageNum]];
    [self releasePageAtIndex:[self currentPageNum] - 1];
    [self releasePageAtIndex:[self currentPageNum] + 1];
    
    [self changeToPage:([self currentPageNum] + 1)];
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

-(void) addBackgroudConverView:(NSInteger) backGroundTag
{
    if (![self.view viewWithTag:backGroundTag]) {
        UIView *backGroudView = [[UIView alloc] init];
        backGroudView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        backGroudView.translatesAutoresizingMaskIntoConstraints = NO;
        backGroudView.tag = backGroundTag;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundConverViewClicked:)];
        [backGroudView addGestureRecognizer:tap];
        [self.view addSubview:backGroudView];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:backGroudView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    }

}

-(void) backgroundConverViewClicked:(UITapGestureRecognizer *) tap
{
    [self downTestQuestionItemStatusView];
}
-(void) addWindowBackgroudConverView:(NSInteger) backGroundTag
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *backGroudView = [[UIView alloc] init];
    backGroudView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    backGroudView.translatesAutoresizingMaskIntoConstraints = NO;
    backGroudView.tag = backGroundTag;
    [window addSubview:backGroudView];
    
    NSDictionary *viewDict = @{@"backView":backGroudView};
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backView]|" options:0 metrics:nil views:viewDict]];
    [window addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backView]|" options:0 metrics:nil views:viewDict]];
    [window bringSubviewToFront:backGroudView];
}

-(void) removeBackgroundConverView:(NSInteger) backGroundTag
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *backgourndView = [window viewWithTag:backGroundTag];
    [backgourndView removeFromSuperview];
    
}

#pragma mark - Notification Response
-(void) appWillResignActiveResponse:(NSNotification *) notification
{
    [self showPauseTestMessageBox];
}

-(void) showPauseTestMessageBox
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (![window viewWithTag:TEST_PAUSE_MESSAGE_BOX_TAG]) {
        NSString *title = [NSString stringWithFormat:@"共100题，还剩%ld题未做", (long)self.scoreCounter.unDoneAnswerNum];
        SWMessageBox *messageBox = [[SWMessageBox alloc]initWithTitle:title boxImage:[UIImage imageNamed:@"testUserHead"] boxType:SWMessageBoxType_OK buttonTitles:@[NSLocalizedString(@"ContinueTest", nil)] completeBlock:^(NSInteger btnIndex) {
            
            [self removeBackgroundConverView:TEST_PAUSE_MESSAGE_BACK_GROUND_TAG];
            [self.countDownTimer resumeTimer];
            
        }];
        
        messageBox.tag = TEST_PAUSE_MESSAGE_BOX_TAG;
        
        [self addWindowBackgroudConverView:TEST_PAUSE_MESSAGE_BACK_GROUND_TAG];
        
        [messageBox showMessageBoxInView:window];
        [self.countDownTimer pauseTimer];
        
    }
}

-(void) userSelectedTestAnswer:(NSNotification *) notification
{
    [self.scoreCounter answerQuestionAtIndex: [self currentPageNum]  result:notification.userInfo];
}

#pragma mark - For test Page View
-(void) testTimeOut
{
    
}

#pragma mark - SWTestScoreCounterDelegate
-(void) userDidAnserQuestion:(NSInteger) questionIndex result:(BOOL) isRight scoreCounter:(SWTestScoreCounter *) scoreCounter
{
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:questionIndex inSection:0];
    SWTestQuestionCell* cell = (SWTestQuestionCell *)[self.contentCollectionView cellForItemAtIndexPath:cellIndexPath];
    if (isRight) {
        cell.SWQuestionNumLabel.backgroundColor = self.testCellRightColor;
        
    }else
    {
        cell.SWQuestionNumLabel.backgroundColor = self.testCellWrongColor;
    }
    
    [self.contentCollectionView reloadItemsAtIndexPaths:@[cellIndexPath]];
    self.testRightNum.text = [NSString stringWithFormat:@"%ld", (long)scoreCounter.rightAnswerNum];
    self.testWrongNum.text = [NSString stringWithFormat:@"%ld", (long)scoreCounter.wrongAnswerNum];
    [self changeToNextTestPage];
    NSIndexPath *index = [NSIndexPath indexPathForRow:[self currentPageNum] inSection:0];
    [self.contentCollectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    
    
    
    
}
@end
