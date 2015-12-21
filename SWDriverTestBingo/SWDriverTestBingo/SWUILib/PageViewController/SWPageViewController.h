//
//  SWPageViewController.h
//
//
//  Created by EShi on 12/14/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPageViewController : UIViewController

-(instancetype) initWithContentViews:(NSMutableArray *) viewContents;
-(NSInteger) currentPageNum;
-(void) nextPage;
-(void) previousPage;
-(void) changeToPage:(NSInteger) pageNum;
-(void) addPageView:(UIView *) pageView;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *contentViewsArray;
@end
