//
//  SWTitleImageCellView.h
//  SWDriverTestBingo
//
//  Created by EShi on 1/22/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWTitleImageCellView : UIView

- (instancetype) initWithTitle:(NSString *) title image:(UIImage *) image frame:(CGRect) frame;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *imageView;
@end
