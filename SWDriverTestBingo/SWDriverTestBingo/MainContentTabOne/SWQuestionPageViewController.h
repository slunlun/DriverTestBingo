//
//  SWQuestionPageViewController.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/19.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import "SWPageViewController.h"
#import "SWDriverTestBigoDef.h"

@interface SWQuestionPageViewController : SWPageViewController
@property(nonatomic) TestQuestionViewType questionPageType;

-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type questinPageType:(TestQuestionViewType) questionPageType;
-(instancetype) initWithContentViewsCount:(NSInteger) pageCount type:(SWPageViewControllerType) type switchToPage:(NSUInteger) pageNum questinPageType:(TestQuestionViewType) questionPageType;
@end
