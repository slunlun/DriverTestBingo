//
//  SWRotateViewController.m
//  SWScrollView
//
//  Created by EShi on 12/14/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWPageViewController.h"

@interface SWPageViewController ()<UIScrollViewDelegate>

@property(nonatomic) BOOL isInit;
@property(nonatomic) BOOL isFirstShown;
@property(nonatomic, strong) UIView *lastView;
@property(nonatomic) NSInteger createdPageNum;

@end

@implementation SWPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFirstShown) {
        [self createPageAtIndex:self.initPageNum];
        [self createPageAtIndex:self.initPageNum + 1];
        [self createPageAtIndex:self.initPageNum - 1];
        [self changeToPage:self.initPageNum];
        self.isFirstShown = NO;

    }
}

-(void) viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageCount, self.scrollView.contentSize.height);
}

#pragma mark INIT/SETTER/GETTER
-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type
{
    self = [super init];
    if (self) {
        _pageCount = pageCount;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delaysContentTouches = YES;
        _scrollView.canCancelContentTouches = YES;
        _isInit = YES;
        _type = type;
        _isFirstShown = YES;
        [self.view addSubview:_scrollView];
    }
    return self;
}
-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type switchToPage:(NSUInteger) pageNum
{
    self = [super init];
    if (self) {
        _pageCount = pageCount;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delaysContentTouches = YES;
        _scrollView.canCancelContentTouches = YES;
        _isInit = YES;
        _type = type;
        _isFirstShown = YES;
        _initPageNum = pageNum;
        [self.view addSubview:_scrollView];
    }
    return self;

}

-(instancetype) init
{
    self = [super init];
    if (self) {
        _isInit = YES;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delaysContentTouches = YES;
        _scrollView.canCancelContentTouches = YES;
        _isFirstShown = YES;
        [self.view addSubview:_scrollView];
    }
    return self;
}

-(void) setDelegate:(id<SWPageViewControllerDelegate>)delegate
{
    _delegate = delegate;
    [self makeUpScrollViews];
    [self createPageAtIndex:0];
}

#pragma mark Layout
-(void) makeUpScrollViews
{
    if (self.isInit) {
        // set up scrollView
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        
        _lastView = nil;
        // set up contentViews in scrollView
        for (NSInteger pageIndex = 0; pageIndex < self.pageCount; pageIndex++) {
            UIView *contentView = [self.delegate swpageViewController:self pageForIndex:pageIndex];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            contentView.tag = pageIndex;
            [self.scrollView addSubview:contentView];
            if (_lastView == nil) { // first view
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
                topConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                
                NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
                widthConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                
                NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
                bottomConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                
                NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
                leadingConstraint.identifier = [self pageConstraintIdentify:pageIndex];

                [self.view addConstraint:topConstraint];
                [self.view addConstraint:widthConstraint];
                [self.view addConstraint:bottomConstraint];
                [self.view addConstraint:leadingConstraint];
                
                _lastView = contentView;
            
            }else
            {
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
                topConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                
                NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
                widthConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                
                NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
                bottomConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                
                NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
                leadingConstraint.identifier = [self pageConstraintIdentify:pageIndex];
                [self.view addConstraint:topConstraint];
                [self.view addConstraint:widthConstraint];
                [self.view addConstraint:bottomConstraint];
                [self.view addConstraint:leadingConstraint];

                _lastView = contentView;
                
                // if type is Optimized, only init two pages, the other pages will create when user call createNextPage method.
                if (self.type == kOptimizedPageController) {
                    self.createdPageNum = 2;
                    break;
                }
            }
            
            
        }
        self.isInit = NO;
    }
    
    
}

#pragma mark public method
-(NSInteger) currentPageNum
{
    return (self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
}

-(void) nextPage
{
    NSInteger currentPageNum = [self currentPageNum];
    if (currentPageNum < self.pageCount - 1) {
        currentPageNum++;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * currentPageNum, self.scrollView.contentOffset.y);
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void) previousPage
{
    NSInteger currentPageNum = [self currentPageNum];
    if (currentPageNum > 0) {
        currentPageNum--;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * currentPageNum, self.scrollView.contentOffset.y);
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void) changeToPage:(NSInteger) pageNum
{
    if (pageNum >= 0 && pageNum < self.pageCount) {
        NSLog(@"The width is %lf", self.scrollView.frame.size.width);
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * pageNum, self.scrollView.contentOffset.y);
    }
}

//-(void) addPageView:(UIView *) pageView
//{
//    pageView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.scrollView addSubview:pageView];
//    if (self.contentViewsArray.count > 0) {
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentViewsArray.lastObject attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
//
//    }else
//    {
//        // first page
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
//        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
//    }
//    [self.contentViewsArray addObject:pageView];
//}

-(void) createNextPageView
{
    if (self.type != kOptimizedPageController) {
        return;
    }
    
    if ([self currentPageNum] > 0) { // 初始化时已经创建了2个page, 因此当前page index == 0时，不需要补充新的page
        if (([self currentPageNum] + 1) < self.pageCount && ([self currentPageNum] + 1) == self.createdPageNum) {
            self.createdPageNum++;
            UIView *nextPageView = [self.delegate swpageViewController:self pageForIndex:(self.currentPageNum + 1)];
            nextPageView.translatesAutoresizingMaskIntoConstraints = NO;
            nextPageView.tag = ([self currentPageNum] + 1);
            NSInteger pageIndex = ([self currentPageNum] + 1);

            [self.scrollView addSubview:nextPageView];
            
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
            topConstraint.identifier = [self pageConstraintIdentify:pageIndex];
            
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
            widthConstraint.identifier = [self pageConstraintIdentify:pageIndex];
            
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
            bottomConstraint.identifier = [self pageConstraintIdentify:pageIndex];
            
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
            leadingConstraint.identifier = [self pageConstraintIdentify:pageIndex];
            
            [self.view addConstraint:topConstraint];
            [self.view addConstraint:widthConstraint];
            [self.view addConstraint:bottomConstraint];
            [self.view addConstraint:leadingConstraint];
            
            self.lastView = nextPageView;
        }

    }
}

-(void) createPageAtIndex:(NSInteger) index
{
    if (self.type != kOptimizedPageController || index >= self.pageCount || index < 0) {
        return;
    }
    UIView *newPageView = nil;
    if ([self.delegate respondsToSelector:@selector(swpageViewController:pageForIndex:)]) {
        newPageView = [self.delegate swpageViewController:self pageForIndex:index];
    }
    
    newPageView.translatesAutoresizingMaskIntoConstraints = NO;
    newPageView.tag = index;
    [self.scrollView addSubview:newPageView];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:newPageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    topConstraint.identifier = [self pageConstraintIdentify:index];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:newPageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    widthConstraint.identifier = [self pageConstraintIdentify:index];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:newPageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    bottomConstraint.identifier = [self pageConstraintIdentify:index];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:newPageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.scrollView.frame.size.width * index];
    leadingConstraint.identifier = [self pageConstraintIdentify:index];
    
    [self.view addConstraint:topConstraint];
    [self.view addConstraint:widthConstraint];
    [self.view addConstraint:bottomConstraint];
    [self.view addConstraint:leadingConstraint];

    
}

-(void) releasePageAtIndex:(NSInteger) index
{
//    NSString *constraintIdentifyB = [self pageConstraintIdentify:index];
//    for (NSLayoutConstraint* constraints in self.view.constraints) {
//        NSLog(@"BEfroe The cons identify is %@ do be del is %@", constraints.identifier, constraintIdentifyB);
//    }

    // The constraint with the view will be deleted with the sub view.
    if (self.type == kOptimizedPageController && index == 0) { // 0 is position base view, so do not remove it.
        return;
    }
    UIView *page = [self.scrollView viewWithTag:index];
    [page removeFromSuperview];
    
//    NSString *constraintIdentify = [self pageConstraintIdentify:index];
//    for (NSLayoutConstraint* constraints in self.view.constraints) {
//        NSLog(@"After The cons identify is %@ do be del is %@", constraints.identifier, constraintIdentify);
//    }
}

#pragma mark private method

-(NSString *) pageConstraintIdentify:(NSInteger) pageIndex
{
    if (pageIndex < 0 || pageIndex >= self.pageCount) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"PAGE_CONS_%ld", pageIndex];
}

#pragma mark UIScrollViewDelegate

@end
