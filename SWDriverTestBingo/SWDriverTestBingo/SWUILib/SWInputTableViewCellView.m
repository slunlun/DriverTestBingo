//
//  SWInputTableViewCellView.m
//  SWDriverTestBingo
//
//  Created by EShi on 1/22/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "SWInputTableViewCellView.h"
@interface SWInputTableViewCellView()

@end

@implementation SWInputTableViewCellView

- (instancetype) initWithTitle:(NSString *) title inputContent:(NSString *) content placeHolder:(NSString *) placeHolder
{
    self = [super init];
    if (self) {
        _inputTitleLable = [[UILabel alloc] init];
        _inputTitleLable.text = title;
        _inputTitleLable.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_inputTitleLable];
        
        _inputContentTextField = [[UITextField alloc] init];
        _inputContentTextField.text = content;
        _inputContentTextField.placeholder = placeHolder;

        _inputContentTextField.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_inputContentTextField];
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    NSDictionary *constraintViews = @{@"inputTitleLabel":_inputTitleLable, @"inputContentTextField":_inputContentTextField};
    NSDictionary *metricsDic = @{@"space":@(5), @"margin":@(20)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[inputTitleLabel(==100)]-[inputContentTextField]|" options:0 metrics:metricsDic views:constraintViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[inputTitleLabel]-|" options:0 metrics:nil views:constraintViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[inputContentTextField]-|" options:0 metrics:nil views:constraintViews]];

    
}

@end
