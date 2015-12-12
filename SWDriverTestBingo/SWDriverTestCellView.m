//
//  SWDriverTestCellView.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/12.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import "SWDriverTestCellView.h"

@implementation SWDriverTestCellView

-(instancetype) initWithCellImage:(UIImageView *) imgView cellTitle:(UILabel *) titleView
{
    self = [super init];
    if (self) {
        _imageView = imgView;
        _titleLab = titleView;
    }
    return self;
}

-(void) layoutCellView
{
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLab.font = [UIFont systemFontOfSize:15.0f];
//    _imageView.backgroundColor = [UIColor yellowColor];
//    _titleLab.backgroundColor = [UIColor redColor];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_imageView];
    [self addSubview:_titleLab];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:32]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:32]];


    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    NSDictionary *boundViewsDict = @{@"imageView":_imageView, @"titleView":_titleLab};
    NSDictionary *metricsDic = @{@"topEdge":@(30), @"bottomEdge":@(24)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topEdge)-[imageView]-[titleView]-(bottomEdge)-|" options:0 metrics:metricsDic views:boundViewsDict]];
}

@end
