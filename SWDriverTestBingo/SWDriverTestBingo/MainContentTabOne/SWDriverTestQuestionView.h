//
//  SWDriverTestQuestionView.h
//  SWDriverTestBingo
//
//  Created by EShi on 12/18/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWDriverTestQuestion.h"
#import "SWQuestionItems+CoreDataProperties.h"
#import "SWDriverTestBigoDef.h"

@interface SWDriverTestQuestionView : UIView
- (instancetype) initWithQuestion:(SWQuestionItems *) question viewType:(TestQuestionViewType) viewType;

- (instancetype) initWithQuestion:(SWQuestionItems *)question viewType:(TestQuestionViewType)viewType pageNum:(NSInteger) pageNum;
@property(nonatomic, strong) SWQuestionItems *question;
@end
