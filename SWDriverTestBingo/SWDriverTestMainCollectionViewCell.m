//
//  WaterFallUICollectionViewCell.m
//  WaterFall
//
//  Created by JackXu on 15/5/8.
//  Copyright (c) 2015年 BFMobile. All rights reserved.
//

#import "SWDriverTestMainCollectionViewCell.h"
#define WIDTH ([UIScreen mainScreen].bounds.size.width-20)/3

@implementation SWDriverTestMainCollectionViewCell
- (void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = image;
    }
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    float newHeight = _image.size.height / _image.size.width * WIDTH;
    [_image drawInRect:CGRectMake(0, 0, WIDTH, newHeight)];
    self.backgroundColor = [UIColor grayColor];
}

@end
