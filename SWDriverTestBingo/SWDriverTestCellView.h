//
//  SWDriverTestCellView.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/12.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SW_DRIVER_TEST_CELL_VIEW_TAG 90000
@interface SWDriverTestCellView : UIView
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *titleLab;

-(instancetype) initWithCellImage:(UIImageView *) imgView cellTitle:(UILabel *) titleView;
-(void) layoutCellView;
@end
