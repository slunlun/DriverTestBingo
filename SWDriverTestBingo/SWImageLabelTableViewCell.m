//
//  SWImageLabelTableViewCell.m
//  SWDriverTestBingo
//
//  Created by EShi on 4/8/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "SWImageLabelTableViewCell.h"

@implementation SWImageLabelTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _SWCellImageView.layer.borderWidth = 0.5;
    _SWCellImageView.layer.cornerRadius = 5.0;
    _SWCellImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _SWCellImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
