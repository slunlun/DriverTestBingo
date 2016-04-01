//
//  SWMessageBox.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/3/27.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum SWMessageBoxType {
    SWMessageBoxType_OK = 1,
    SWMessageBoxType_OKCancel,
}SWMessageBoxType;
@interface SWMessageBox : UIView
-(instancetype) initWithTitle:(NSString *) title boxImage:(UIImage *) image boxType:(SWMessageBoxType) messageBoxType buttonTitles:(NSArray *) buttonTitles completeBlock:(void(^)(NSInteger)) completeBlock;
-(void) showMessageBoxInView:(UIView *) view;

@property(nonatomic) NSInteger boxWidth;
@property(nonatomic) NSInteger boxHeight;
@end
