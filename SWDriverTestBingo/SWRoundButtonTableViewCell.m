//
//  SWRoundButtonTableViewCell.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/28.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import "SWRoundButtonTableViewCell.h"

@implementation SWRoundButtonTableViewCell
+(instancetype) initWithTableView:(UITableView *)tableView userInfoCellWithUserName:(NSString *) userName userHeadImage:(UIImage *) headImage
{
    static NSString *userCellIdentify = @"userCellIdentify";
    SWRoundButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil]lastObject];
    }
    
    cell.userHeadImage.image = headImage;
    cell.userHeadImage.layer.cornerRadius = cell.userHeadImage.frame.size.width / 2;
    cell.userHeadImage.clipsToBounds = YES;
    cell.userHeadImage.layer.borderWidth = 2;
    cell.userHeadImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cell.userName.text = userName;
    return cell;
    
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
