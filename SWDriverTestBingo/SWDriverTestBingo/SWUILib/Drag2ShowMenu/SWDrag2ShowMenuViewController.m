//
//  SWDrag2ShowMenuViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDrag2ShowMenuViewController.h"

@interface SWDrag2ShowMenuViewController() <UIGestureRecognizerDelegate>
@property(nonatomic) CGPoint touchBeginPoint;
@property(nonatomic) CGFloat speedRation;
@property(nonatomic) CGFloat currentPointX;
@property(nonatomic) BOOL slideMenuShown;


@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRec;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRec;
@end

const CGFloat defaultSlideInWidth = 30;
const CGFloat defaultMenuWidth = 240;


const NSInteger menuViewTag = 3000;
const NSInteger contentViewTag = 3001;

@implementation SWDrag2ShowMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark INIT/GETTER/SETTER
-(instancetype) initWithContentView:(UIViewController *) contentViewController sideMenuView:(UIViewController *) sideMenuViewController
{
    self = [super init];
    if (self) {
        
        
        _menuViewSlideInWidth = defaultSlideInWidth;
        _menuViewWidth = defaultMenuWidth;
        
        _contentViewController = contentViewController;
        _menuContentViewController = sideMenuViewController;
        
        [self addChildViewController:contentViewController];
        [self addChildViewController:sideMenuViewController];
        [self.view addSubview:_menuContentViewController.view];
        [self.view addSubview:_contentViewController.view];
       
        
        
        _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureResponse:)];
        _tapGestureRec.delegate=self;
        [_contentViewController.view addGestureRecognizer:_tapGestureRec];
        
        
        _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
        [_contentViewController.view addGestureRecognizer:_panGestureRec];
        
        //为contentView设置阴影
        [[_contentViewController.view layer] setShadowOffset:CGSizeMake(1, 1)];
        [[_contentViewController.view  layer] setShadowRadius:5];
        [[_contentViewController.view  layer] setShadowOpacity:1];
        [[_contentViewController.view  layer] setShadowColor:[UIColor blackColor].CGColor];
        
        
        [self setMenuContentView:_menuContentViewController.view];
        
        
    }
    return self;
}

-(void) setMenuContentView:(UIView *) menuView
{
    //step1. according to contentView, caculate menuView position
    CGRect contentViewRect = self.contentViewController.view.frame;
    CGRect menuViewRect = CGRectMake(-self.menuViewSlideInWidth, contentViewRect.origin.y, self.menuViewWidth, contentViewRect.size.height);
    self.menuContentViewController.view.frame = menuViewRect;
    
    self.menuViewWidth = self.menuContentViewController.view.frame.size.width;
    
    self.menuContentViewController.view.tag = menuViewTag;
    
    // step2. caculate side menu, main content view speed ration
    _speedRation = self.menuViewSlideInWidth / self.menuViewWidth;
}

#pragma mark Gesture response
-(void) tapGestureResponse:(UITapGestureRecognizer *) rec
{
    [self closeSideMenu];
}


- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.currentPointX = self.contentViewController.view.transform.tx;
    }
    // CGPoint currentTouchPoint = [touch locationInView:_contentView];
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offsetX = [panGes translationInView:self.contentViewController.view].x - self.currentPointX;
        self.currentPointX = [panGes translationInView:self.contentViewController.view].x;
        self.contentViewController.view.center = CGPointMake(self.contentViewController.view.center.x + offsetX, self.contentViewController.view.center.y);
        // situation 1: side menu 已经被全部拖出，用户不能够继续拖
        if (self.contentViewController.view.frame.origin.x >= self.menuViewWidth)
        {
            self.contentViewController.view.frame = CGRectMake(self.menuViewWidth, self.contentViewController.view.frame.origin.y, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height);
            self.menuContentViewController.view.frame = CGRectMake(0, self.menuContentViewController.view.frame.origin.y, self.menuContentViewController.view.frame.size.width, self.menuContentViewController.view.frame.size.height);
            return;
        }
        
        // situation 2: 用户向左拖，sideMenu 关闭，则不能够继续再向左拖动
        if (self.contentViewController.view.frame.origin.x <=0) {
            self.contentViewController.view.frame = CGRectMake(0, self.contentViewController.view.frame.origin.y, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height);
            self.menuContentViewController.view.frame = CGRectMake(-self.menuViewSlideInWidth, self.menuContentViewController.view.frame.origin.y, self.menuContentViewController.view.frame.size.width, self.menuContentViewController.view.frame.size.height);
            return;
        }
        
        // situation 3: 用户可以各种拖动
        CGFloat menuCenterOffsetX = offsetX * _speedRation;
        self.contentViewController.view.center = CGPointMake(self.contentViewController.view.center.x + menuCenterOffsetX, self.contentViewController.view.center.y);
        
    }
    
    if (panGes.state == UIGestureRecognizerStateEnded) {
        if (self.contentViewController.view.frame.origin.x >= self.menuViewWidth/3)
        {
            [self showSlideMenu];
        }else
        {
            [self closeSideMenu];
        }
        
    }
}

#pragma mark show/close side menu
-(void) showSlideMenu
{
    NSLog(@"Open slide bar");
    CGRect contentViewToFrame = CGRectMake(self.menuViewWidth, self.contentViewController.view.frame.origin.y, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height);
    CGRect slideMenuViewToFrame = CGRectMake(0, self.menuContentViewController.view.frame.origin.y, self.menuContentViewController.view.frame.size.width, self.menuContentViewController.view.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentViewController.view setFrame:contentViewToFrame];
        [self.menuContentViewController.view setFrame:slideMenuViewToFrame];
    } completion:^(BOOL finished) {
        _slideMenuShown = YES;
    }];
}

-(void) closeSideMenu
{
    CGRect contentViewToFrame = CGRectMake(0, self.contentViewController.view.frame.origin.y, self.contentViewController.view.frame.size.width, self.contentViewController.view.frame.size.height);
    CGRect slideMenuViewToFrame = CGRectMake(-self.menuViewSlideInWidth, self.menuContentViewController.view.frame.origin.y, self.menuContentViewController.view.frame.size.width, self.menuContentViewController.view.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentViewController.view setFrame:contentViewToFrame];
        [self.menuContentViewController.view setFrame:slideMenuViewToFrame];
    } completion:^(BOOL finished) {
        _slideMenuShown = NO;
    }];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.slideMenuShown) {
        return YES;
    }else
    {
        return NO;
    }
}
@end
