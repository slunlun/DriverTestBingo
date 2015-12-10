//
//  SWDrag2ShowMenu.m
//  Drag2ShowMenu
//
//  Created by EShi on 7/17/15.
//  Copyright (c) 2015 EShi. All rights reserved.
//

#import "SWDrag2ShowMenu.h"
@interface SWDrag2ShowMenu()<UIGestureRecognizerDelegate>
@property(nonatomic) CGPoint touchBeginPoint;
@property(nonatomic) CGFloat speedRation;
@property(nonatomic) CGFloat currentPointX;
@property(nonatomic) BOOL slideMenuShown;


@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRec;
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRec;
@end

@implementation SWDrag2ShowMenu

const CGFloat defaultSlideInWidth = 30;
const CGFloat defaultMenuWidth = 240;


const NSInteger menuViewTag = 3000;
const NSInteger contentViewTag = 3001;

-(instancetype) initWithContentView:(UIView *) contentView sideMenuView:(UIView *) sideMenuView
{
    self = [super init];
    if (self) {
        
        _menuViewSlideInWidth = defaultSlideInWidth;
        _menuViewWidth = defaultMenuWidth;
        
        _contentView = contentView;
        _contentView.tag = contentViewTag;
        
        self.frame = _contentView.frame;
        [self addSubview:_contentView];
       
        
        _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideMenu)];
        _tapGestureRec.delegate=self;
        [_contentView addGestureRecognizer:_tapGestureRec];
      
        
        _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
        [_contentView addGestureRecognizer:_panGestureRec];
        
        //为contentView设置阴影
        [[_contentView layer] setShadowOffset:CGSizeMake(1, 1)];
        [[_contentView layer] setShadowRadius:5];
        [[_contentView layer] setShadowOpacity:1];
        [[_contentView layer] setShadowColor:[UIColor blackColor].CGColor];
        

        [self setMenuContentView:sideMenuView];
    }
    return self;
}

#pragma mark GestureRect

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    NSLog(@"moveViewWithGesture");
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.currentPointX = _contentView.transform.tx;
    }
    // CGPoint currentTouchPoint = [touch locationInView:_contentView];
    if (panGes.state == UIGestureRecognizerStateChanged)
    {
        CGFloat offsetX = [panGes translationInView:_contentView].x - self.currentPointX;
        self.currentPointX = [panGes translationInView:_contentView].x;
        _contentView.center = CGPointMake(_contentView.center.x + offsetX, _contentView.center.y);
        if (_contentView.frame.origin.x >= self.menuViewWidth)
        {
            _contentView.frame = CGRectMake(self.menuViewWidth, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
            _menuContentView.frame = CGRectMake(0, _menuContentView.frame.origin.y, _menuContentView.frame.size.width, _menuContentView.frame.size.height);
            return;
        }
        
        if (_contentView.frame.origin.x <=0) {
            _contentView.frame = CGRectMake(0, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
            _menuContentView.frame = CGRectMake(-self.menuViewSlideInWidth, _menuContentView.frame.origin.y, _menuContentView.frame.size.width, _menuContentView.frame.size.height);
            return;
        }
        
        CGFloat menuCenterOffsetX = offsetX * _speedRation;
        _menuContentView.center = CGPointMake(_menuContentView.center.x + menuCenterOffsetX, _menuContentView.center.y);

    }
    
    if (panGes.state == UIGestureRecognizerStateEnded) {
        if (_contentView.frame.origin.x >= self.menuViewWidth/3)
        {
            [self showSlideMenu];
        }else
        {
            [self closeSideMenu];
        }

    }
}
#pragma mark setter/getter
-(void) setMenuContentView:(UIView *) menuView
{
    _menuContentView = menuView;
    
    //step1. according to contentView, caculate menuView position
    CGRect contentViewRect = self.contentView.frame;
    CGRect menuViewRect = CGRectMake(-self.menuViewSlideInWidth, contentViewRect.origin.y, self.menuViewWidth, contentViewRect.size.height);
    _menuContentView.frame = menuViewRect;
    
    self.menuViewWidth = _menuContentView.frame.size.width;
    
    _menuContentView.tag = menuViewTag;
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == menuViewTag) {
            [subView removeFromSuperview];
        }
    }
    
    _speedRation = self.menuViewSlideInWidth / self.menuViewWidth;
    
    [self addSubview:_menuContentView];
    [self sendSubviewToBack:_menuContentView];
    
}

-(void) setMenuViewWidth:(CGFloat) menuWidth
{
    _menuViewWidth = menuWidth;
    _speedRation = _menuViewSlideInWidth / _menuViewWidth;
}

-(void) setMenuViewSlideInWidth:(CGFloat) slideInWidth
{
    _menuViewSlideInWidth = slideInWidth;
    _speedRation = _menuViewSlideInWidth / _menuViewWidth;
}

#pragma mark SWDrag2ShowMenu public method
-(void) showSlideMenu
{
    NSLog(@"Open slide bar");
    CGRect contentViewToFrame = CGRectMake(self.menuViewWidth, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
    CGRect slideMenuViewToFrame = CGRectMake(0, _menuContentView.frame.origin.y, _menuContentView.frame.size.width, _menuContentView.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [_contentView setFrame:contentViewToFrame];
        [_menuContentView setFrame:slideMenuViewToFrame];
    } completion:^(BOOL finished) {
        _slideMenuShown = YES;
    }];
}

- (void) closeSideMenu
{
    NSLog(@"Close Slide Bar");
    CGRect contentViewToFrame = CGRectMake(0, _contentView.frame.origin.y, _contentView.frame.size.width, _contentView.frame.size.height);
    CGRect slideMenuViewToFrame = CGRectMake(-self.menuViewSlideInWidth, _menuContentView.frame.origin.y, _menuContentView.frame.size.width, _menuContentView.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        [_contentView setFrame:contentViewToFrame];
        [_menuContentView setFrame:slideMenuViewToFrame];
    } completion:^(BOOL finished) {
        _slideMenuShown = NO;
    }];
}

-(void) switchSlideBarState
{
    if (self.slideMenuShown) {
        [self closeSideMenu];
    }else
    {
        [self showSlideMenu];
    }
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.slideMenuShown) {
        return YES;
    }else
    {
        return NO;
    }
}
@end
