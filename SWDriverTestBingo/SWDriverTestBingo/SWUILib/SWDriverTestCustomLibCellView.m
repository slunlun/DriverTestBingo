//
//  SWDriverTestCustomLibCellView.m
//  SWDriverTestBingo
//
//  Created by EShi on 1/14/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "SWDriverTestCustomLibCellView.h"

@implementation SWDriverTestCustomLibCellView

- (instancetype) initWithImageView:(UIImageView *) imageView TitleLabel:(UILabel *) titleLabel SubtitleLabel:(UILabel *) subtitleLabel
{
    self = [super init];
    if (self) {
        _customLibImageView = imageView;
        _customLibTitleLabel = titleLabel;
        _customLibSubtitleLabel = subtitleLabel;
    }
    return self;
}
- (void) layoutLibCellView
{
    self.customLibImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.customLibSubtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.customLibTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_customLibImageView];
    [self addSubview:_customLibSubtitleLabel];
    [self addSubview:_customLibTitleLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_customLibImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_customLibImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:32]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_customLibImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:32]];
    
    NSDictionary *boundViews = @{@"customLibImageView":_customLibImageView, @"customLibSubtitleLabel":_customLibSubtitleLabel, @"customLibTitleLabel":_customLibTitleLabel};
    
    NSDictionary *metricsDic = @{@"topEdge":@(30), @"bottomEdge":@(24)};    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topEdge)-[customLibImageView]-[customLibTitleLabel]-(bottomEdge)-|" options:0 metrics:metricsDic views:boundViews]];
      [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topEdge)-[customLibImageView]-[customLibSubtitleLabel]-(bottomEdge)-|" options:0 metrics:metricsDic views:boundViews]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.customLibTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.customLibSubtitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.customLibTitleLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:2]];
}

@end
