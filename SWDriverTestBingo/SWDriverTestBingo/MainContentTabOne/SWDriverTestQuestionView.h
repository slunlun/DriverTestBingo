//
//  SWDriverTestQuestionView.h
//  SWDriverTestBingo
//
//  Created by EShi on 12/18/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWDriverTestQuestion.h"
@interface SWDriverTestQuestionView : UIView
- (instancetype) initWithQuestion:(SWDriverTestQuestion *) question;

@property(nonatomic, strong) SWDriverTestQuestion *question;
@end
