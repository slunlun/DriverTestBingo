//
//  SWMessageBox.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/3/27.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "SWMessageBox.h"

#define DEFAULT_BOX_WIDTH 100
#define DEFAULT_BOX_HEIGHT 60

#define MESSAGE_BOX_VIEW_TAG 95001
#define MESSAGE_BOX_OK_BTN_TAG 85001
#define MESSAGE_BOX_CANCEL_BTN_TAG 85002

typedef void (^callBackBlock)(NSInteger);
@interface SWMessageBox()
@property(nonatomic, strong) NSString *title;
@property(nonatomic) SWMessageBoxType boxType;
@property(nonatomic, strong) UIImage *boxImage;
@property(nonatomic, strong) callBackBlock callBack;

// For ui view
//@property(nonatomic, strong) UIImageView *boxImageView;
//@property(nonatomic, strong) UILabel *boxTitleLabel;
//@property(nonatomic, strong) UIButton *boxOKBtn;
//@property(nonatomic, strong) UIButton *boxCancelBtn;
//@property(nonatomic, strong) UIView *boxBackGroundView;
@end

@implementation SWMessageBox
-(instancetype) initWithTitle:(NSString *) title boxImage:(UIImage *) image boxType:(SWMessageBoxType) messageBoxType completeBlock:(void(^)(NSInteger)) completeBlock
{
    self = [super init];
    if (self) {
        _title = title;
        _boxImage = image;
        _boxType = messageBoxType;
        _callBack = completeBlock;
        _boxHeight = DEFAULT_BOX_HEIGHT;
        _boxWidth = DEFAULT_BOX_WIDTH;
    }
    return self;
}
-(void) showMessageBoxInView:(UIView *) view
{
    if (view && self) {
        //self.frame = CGRectMake(0, 0, _boxWidth, _boxHeight);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.tag = MESSAGE_BOX_VIEW_TAG;
        [view addSubview:self];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
      //  [self makeUpMessageBox];
        
    }
    
    
}
#pragma makr - Response to UI
-(void) messageBoxBtnClicked:(UIButton *) button
{
    
}
#pragma mark - Private method
-(void) makeUpMessageBox
{
    self.backgroundColor = [UIColor yellowColor];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    
    UIImageView *boxImageView = [[UIImageView alloc] init];
    boxImageView.image = self.boxImage;
    boxImageView.backgroundColor = [UIColor whiteColor];
    boxImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:boxImageView];
    
    UIButton *OKButton = [[UIButton alloc] init];
    OKButton.tag = MESSAGE_BOX_OK_BTN_TAG;
    [OKButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    OKButton.backgroundColor = [UIColor greenColor];
    [OKButton addTarget:self action:@selector(messageBoxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    OKButton.translatesAutoresizingMaskIntoConstraints = NO;
   [self addSubview:OKButton];
    
    NSInteger headMargin = 10;
    NSInteger leftRightMargin = 20;
   
    
    NSInteger boxImageViewHeight = self.boxWidth / 3;
    NSInteger boxImageViewWidth = self.boxWidth / 3;
    
    
    NSInteger boxTitleHeight = (self.boxHeight/8) * 3;
    NSInteger OKButtonHeight = (self.boxHeight/8) * 3;
    // set up contentView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:headMargin + boxImageViewHeight/2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    
    
    // set up boxImageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:boxImageViewWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:boxImageViewHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeTop multiplier:1.0 constant:headMargin]];
    
    // set up title Label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:boxTitleHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel   attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:boxImageView  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0]];
    
//    // set up OK button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:leftRightMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:OKButtonHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:3.0]];
//
//    
    boxImageView.layer.cornerRadius = boxImageViewWidth / 2;
    boxImageView.clipsToBounds = YES;
    boxImageView.layer.borderWidth = 1.0f;
}
@end
