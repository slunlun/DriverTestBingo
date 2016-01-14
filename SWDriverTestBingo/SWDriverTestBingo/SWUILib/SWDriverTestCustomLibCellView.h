//
//  SWDriverTestCustomLibCellView.h
//  SWDriverTestBingo
//
//  Created by EShi on 1/14/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWDriverTestCustomLibCellView : UIView
- (instancetype) initWithImageView:(UIImageView *) imageView TitleLabel:(UILabel *) titleLabel SubtitleLabel:(UILabel *) subtitleLabel;
- (void) layoutLibCellView;
@property(nonatomic, strong) UIImageView *customLibImageView;
@property(nonatomic, strong) UILabel *customLibTitleLabel;
@property(nonatomic, strong) UILabel *customLibSubtitleLabel;
@end
