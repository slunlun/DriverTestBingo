//
//  SWDragToMoveView.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/3/26.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum DragToMoveViewStatus{
    dragToMoveViewUp = 1,
    dragToMoveViewDown,
}DragToMoveViewStatus;
@interface SWDragToMoveView : UIView
@property(nonatomic) DragToMoveViewStatus status;
@end
