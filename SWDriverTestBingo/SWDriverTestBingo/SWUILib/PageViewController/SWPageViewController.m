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

-(void) viewDidLayoutSubviews
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.contentViewsArray.count, self.scrollView.contentSize.height);
    NSLog(@"The contsize is width = %f, height = %f, frame = %@", self.scrollView.contentSize.width, self.scrollView.contentSize.height, NSStringFromCGRect(self.scrollView.frame));
}

#pragma mark INIT/SETTER/GETTER
-(instancetype) initWithContentViews:(NSMutableArray *) viewContents type:(SWPageViewControllerType) type
{
    self = [super init];
    if (self) {
        _contentViewsArray = viewContents;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.delaysContentTouches = YES;
        _scrollView.canCancelContentTouches = YES;
        _isInit = YES;
        _type = type;
        [self.view addSubview:_scrollView];
        [self makeUpScrollViews];
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
        [self.view addSubview:_scrollView];
        [self makeUpScrollViews];
    }
    return self;
}

-(NSMutableArray *) contentViewsArray
{
    if (_contentViewsArray == nil) {
        _contentViewsArray = [[NSMutableArray alloc] init];
    }
    return _contentViewsArray;
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
        for (UIView *contentView in self.contentViewsArray) {
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.scrollView addSubview:contentView];
            if (_lastView == nil) { // first view
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
                
                _lastView = contentView;
            
            }else
            {
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
                [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
                
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
    if (currentPageNum < self.contentViewsArray.count - 1) {
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
    if (pageNum >= 0 && pageNum < self.contentViewsArray.count) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * pageNum, self.scrollView.contentOffset.y);
    }
}

-(void) addPageView:(UIView *) pageView
{
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:pageView];
    if (self.contentViewsArray.count > 0) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentViewsArray.lastObject attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];

    }else
    {
        // first page
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    }
    [self.contentViewsArray addObject:pageView];
}

-(void) createNextPageView
{
    if (self.type != kOptimizedPageController) {
        return;
    }
    
    if ([self currentPageNum] > 0) { // 初始化时已经创建了2个page, 因此当前page index == 0时，不需要补充新的page
        if (([self currentPageNum] + 1) < self.contentViewsArray.count && ([self currentPageNum] + 1) == self.createdPageNum) {
            self.createdPageNum++;
            UIView *nextPageView = self.contentViewsArray[([self currentPageNum] + 1)];
            nextPageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.scrollView addSubview:nextPageView];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:nextPageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
            self.lastView = nextPageView;
        }

    }
}

#pragma mark private method

#pragma mark UIScrollViewDelegate

@end
