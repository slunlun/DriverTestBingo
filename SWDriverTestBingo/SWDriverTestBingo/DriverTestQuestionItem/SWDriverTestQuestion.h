//
//  SWDriverTestQuestion.h
//  SWDriverTestBingo
//
//  Created by EShi on 12/18/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWDriverTestQuestion : NSObject
-(instancetype) initWithQuestionImage:(UIImage *) image questionDescp:(NSString *) questionDescp answers:(NSArray *) answers rightIndex:(NSInteger) rightIndex;
@property(nonatomic, strong) UIImage *questionImage;
@property(nonatomic, strong) NSString *questionDescp;
@property(nonatomic, strong) NSArray *questionAnswers;
@property(nonatomic) NSInteger rightAnswerIndex;
@end
