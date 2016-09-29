//
//  SWQuestionStatisticsPageViewController.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/9/27.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWQuestionStatisticsPageViewController : UIViewController

- (instancetype) initWithTotalQuestionCount:(NSInteger) totalQustionCount wrongQustionCount:(NSInteger) wrongQustionCount;
@end
