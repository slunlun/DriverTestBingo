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

@interface SWDriverTestQuestionView : UIView
- (instancetype) initWithQuestion:(SWQuestionItems *) question;

@property(nonatomic, strong) SWQuestionItems *question;
@end
