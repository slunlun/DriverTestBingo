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
-(NSInteger) currentPageNum;
-(void) nextPage;
-(void) previousPage;
-(void) changeToPage:(NSInteger) pageNum;
-(void) addPageView:(UIView *) pageView;
-(void) createNextPageView;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *contentViewsArray;
@property(nonatomic) SWPageViewControllerType type;

@end
