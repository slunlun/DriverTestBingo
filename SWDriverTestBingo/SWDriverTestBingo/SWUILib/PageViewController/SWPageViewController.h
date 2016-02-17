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
@interface SWPageViewController : UIViewController

-(instancetype) initWithContentViews:(NSMutableArray *) viewContents type:(SWPageViewControllerType) type;
-(instancetype) initWithContentViews:(NSMutableArray *) viewContents type:(SWPageViewControllerType) type switchToPage:(NSUInteger) pageNum;
-(NSInteger) currentPageNum;
-(void) nextPage;
-(void) previousPage;
-(void) changeToPage:(NSInteger) pageNum;
//-(void) addPageView:(UIView *) pageView;

-(void) createNextPageView;
-(void) createPageAtIndex:(NSInteger) index;

-(void) releasePageAtIndex:(NSInteger) index;


@property(nonatomic) NSUInteger initPageNum;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *contentViewsArray;
@property(nonatomic) SWPageViewControllerType type;

@end
