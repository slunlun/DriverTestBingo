//
//  SWRoundButtonTableViewCell.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 15/12/28.
//  Copyright © 2015年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWRoundButtonTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;

+(instancetype) initWithTableView:(UITableView *)tableView userInfoCellWithUserName:(NSString *) userName userHeadImage:(UIImage *) headImage;
@end
