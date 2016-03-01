//
//  SWPageViewController.h
//
//
//  Created by EShi on 12/14/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kNormalPageController = 1,
    kOptimizedPageController,
    
}SWPageViewControllerType;
@class SWPageViewController;
@protocol SWPageViewControllerDelegate <NSObject>
@required
-(UIView *) swpageViewController:(SWPageViewController *) pageViewController pageForIndex:(NSInteger) pageNum;
-(id) swpageViewController:(SWPageViewController *) pageViewController pageDataForIndex:(NSInteger) pageNum;
@end
@interface SWPageViewController : UIViewController


-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type;
-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type switchToPage:(NSUInteger) pageNum;
-(NSInteger) currentPageNum;
-(void) nextPage;
-(void) previousPage;
-(void) changeToPage:(NSInteger) pageNum;
//-(void) addPageView:(UIView *) pageView;

-(void) createNextPageView;
-(void) createPageAtIndex:(NSInteger) index;

-(void) releasePageAtIndex:(NSInteger) index;


@property(nonatomic) NSUInteger initPageNum;
@property(nonatomic) NSInteger pageCount;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic) SWPageViewControllerType type;
@property(nonatomic, weak) id<SWPageViewControllerDelegate> delegate;

@end
