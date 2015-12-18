//
//  SWDriverTestQuestion.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/18/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDriverTestQuestion.h"

@implementation SWDriverTestQuestion
-(instancetype) initWithQuestionImage:(UIImage *) image questionDescp:(NSString *) questionDescp answers:(NSArray *) answers rightIndex:(NSInteger) rightIndex
{
    self = [super init];
    if (self) {
        _questionImage = image;
        _questionDescp = questionDescp;
        _questionAnswers = [answers copy];
        _rightAnswerIndex = rightIndex;
    }
    return self;
}
@end
