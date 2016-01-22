//
//  SWInputTableViewCellView.h
//  SWDriverTestBingo
//
//  Created by EShi on 1/22/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWInputTableViewCellView : UIView

- (instancetype) initWithTitle:(NSString *) title inputContent:(NSString *) content placeHolder:(NSString *) placeHolder;
@property(nonatomic, strong) UILabel *inputTitleLable;
@property(nonatomic, strong) UITextField *inputContentTextField;


@end
