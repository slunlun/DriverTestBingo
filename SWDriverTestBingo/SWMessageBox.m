//
//  SWMessageBox.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/3/27.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "SWMessageBox.h"

#define DEFAULT_BOX_WIDTH 250
#define DEFAULT_BOX_HEIGHT 200

#define MESSAGE_BOX_OK_BTN_TAG 85001
#define MESSAGE_BOX_CANCEL_BTN_TAG 85002

typedef void (^callBackBlock)(NSInteger);
@interface SWMessageBox()
@property(nonatomic, strong) NSString *title;
@property(nonatomic) SWMessageBoxType boxType;
@property(nonatomic, strong) UIImage *boxImage;
@property(nonatomic, strong) callBackBlock callBack;
@property(nonatomic, strong) NSArray *buttonTitles;
// For ui view
//@property(nonatomic, strong) UIImageView *boxImageView;
//@property(nonatomic, strong) UILabel *boxTitleLabel;
//@property(nonatomic, strong) UIButton *boxOKBtn;
//@property(nonatomic, strong) UIButton *boxCancelBtn;
//@property(nonatomic, strong) UIView *boxBackGroundView;
@end

@implementation SWMessageBox
-(instancetype) initWithTitle:(NSString *) title boxImage:(UIImage *) image boxType:(SWMessageBoxType) messageBoxType buttonTitles:(NSArray *) buttonTitles completeBlock:(void(^)(NSInteger)) completeBlock
{
    self = [super init];
    if (self) {
        _title = title;
        _boxImage = image;
        _boxType = messageBoxType;
        _callBack = completeBlock;
        _boxHeight = DEFAULT_BOX_HEIGHT;
        _boxWidth = DEFAULT_BOX_WIDTH;
        _buttonTitles = buttonTitles;
    }
    return self;
}
-(void) showMessageBoxInView:(UIView *) view
{
   // if (view && self && ![view viewWithTag:MESSAGE_BOX_VIEW_TAG]) {
        //self.frame = CGRectMake(0, 0, _boxWidth, _boxHeight);
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:self];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_boxWidth]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_boxHeight]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-60.0]];  //减去navigation bar之类的
        [self makeUpMessageBox];
  //  }
    
}
#pragma makr - Response to UI
-(void) messageBoxBtnClicked:(UIButton *) button
{
    NSInteger buttonIndex;
    switch (button.tag) {
        case MESSAGE_BOX_OK_BTN_TAG:
        {
            buttonIndex = 1;
        }
            break;
        case MESSAGE_BOX_CANCEL_BTN_TAG:
        {
            buttonIndex = 0;
        }
        default:
            break;
    }
    self.callBack(buttonIndex);
    [self removeFromSuperview];
}
#pragma mark - Private method
-(void) makeUpMessageBox
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contentView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:titleLabel];
    
    UIImageView *boxImageView = [[UIImageView alloc] init];
    boxImageView.image = self.boxImage;
    boxImageView.backgroundColor = [UIColor whiteColor];
    boxImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:boxImageView];
    
    UIButton *OKButton = [[UIButton alloc] init];
    OKButton.tag = MESSAGE_BOX_OK_BTN_TAG;
    OKButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    if (self.boxType == SWMessageBoxType_OK) {
        [OKButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
        
    }else if(self.boxType == SWMessageBoxType_OKCancel)
    {
        [OKButton setTitle:self.buttonTitles[1] forState:UIControlStateNormal];

    }
    OKButton.backgroundColor = [UIColor colorWithRed:25.f/255.f green:184.f/255.f blue:121.f/255.f alpha:1.f];
    [OKButton addTarget:self action:@selector(messageBoxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    OKButton.translatesAutoresizingMaskIntoConstraints = NO;
   [self addSubview:OKButton];
    
   
    
    NSInteger headMargin = 10;
    NSInteger leftRightMargin = 40;
   
    
    NSInteger boxImageViewHeight = self.boxWidth / 3;
    NSInteger boxImageViewWidth = self.boxWidth / 3;
    
    
    NSInteger boxTitleHeight = (self.boxHeight/8) * 3;
    //NSInteger OKButtonHeight = 44;
    // set up contentView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:headMargin + boxImageViewHeight/2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

    
    
    // set up boxImageView
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:boxImageViewWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:boxImageViewHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:boxImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeTop multiplier:1.0 constant:headMargin]];
    
    // set up title Label
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:boxTitleHeight]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel   attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:boxImageView  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-(boxTitleHeight/2) + 15]];
    
//    // set up OK button
    if (self.boxType == SWMessageBoxType_OK) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant: (self.boxWidth - leftRightMargin)]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0]];
        OKButton.layer.cornerRadius = 5.0f;
        OKButton.clipsToBounds = YES;
        
    }else if(self.boxType == SWMessageBoxType_OKCancel)
    {
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.tag = MESSAGE_BOX_CANCEL_BTN_TAG;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [cancelButton setTitle:self.buttonTitles[0] forState:UIControlStateNormal];
        
        cancelButton.backgroundColor = [UIColor redColor];
        [cancelButton addTarget:self action:@selector(messageBoxBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:cancelButton];
        

        [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:OKButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0]];
        
        NSDictionary *viewDict = @{@"CancelButton":cancelButton, @"OKButton":OKButton};
       
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[CancelButton(==OKButton)]-[OKButton]-|" options:0 metrics:nil views:viewDict]];
        
        
        OKButton.layer.cornerRadius = 5.0f;
        OKButton.clipsToBounds = YES;
        
        cancelButton.layer.cornerRadius = 5.0f;
        cancelButton.clipsToBounds = YES;
        
    }
   
//
//    
    boxImageView.layer.cornerRadius = boxImageViewWidth / 2;
    boxImageView.clipsToBounds = YES;
    boxImageView.layer.borderWidth = 1.0f;
    
    contentView.layer.cornerRadius = 10;
    contentView.clipsToBounds = YES;
    
    
}
@end
