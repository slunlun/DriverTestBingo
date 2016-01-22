//
//  SWTitleImageCellView.m
//  SWDriverTestBingo
//
//  Created by EShi on 1/22/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "SWTitleImageCellView.h"

@implementation SWTitleImageCellView

- (instancetype) initWithTitle:(NSString *) title image:(UIImage *) image frame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = image;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_titleLabel];
    }
    return  self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    NSDictionary *constraintViews = @{@"imageView":_imageView, @"titleLabel":_titleLabel};
    NSDictionary *metricsDic = @{@"space":@(5), @"margin":@(20)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[titleLabel(==100)]-[imageView(==60)]-space@1000-|" options:0 metrics:metricsDic views:constraintViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[titleLabel]-|" options:0 metrics:nil views:constraintViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[imageView]-|" options:0 metrics:nil views:constraintViews]];
}
@end
