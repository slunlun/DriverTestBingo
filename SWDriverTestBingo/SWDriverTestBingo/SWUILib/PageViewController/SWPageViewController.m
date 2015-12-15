//
//  SWRotateViewController.m
//  SWScrollView
//
//  Created by EShi on 12/14/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWPageViewController.h"

@interface SWPageViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *contentViewsArray;
@property(nonatomic) BOOL isInit;
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
    NSLog(@"The contsize is width = %f, height = %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

#pragma mark INIT/SETTER/GETTER
-(instancetype) initWithContentViews:(NSMutableArray *) viewContents
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
        
        UIView *lastView = nil;
        // set up contentViews in scrollView
        for (UIView *contentView in self.contentViewsArray) {
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.scrollView addSubview:contentView];
            if (lastView == nil) { // first view
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
                
            }else
            {
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
                [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
            }
            lastView = contentView;
            
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
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentViewsArray.lastObject attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    }else
    {
        // first page
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    }
    [self.contentViewsArray addObject:pageView];
}

#pragma mark private method

#pragma mark UIScrollViewDelegate

@end
