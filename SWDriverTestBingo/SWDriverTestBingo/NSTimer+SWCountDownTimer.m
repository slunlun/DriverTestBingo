//
//  NSTimer+SWCountDownTimer.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/3/27.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "NSTimer+SWCountDownTimer.h"

@implementation NSTimer (SWCountDownTimer)
-(void) pauseTimer
{
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}
-(void) resumeTimer
{
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}
@end
