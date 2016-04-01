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

@interface SWDriverTestQuestionViewDisplayData : NSObject
@property (nonatomic, strong) NSString *questionAnswerA;
@property (nonatomic, strong) NSString *questionAnswerB;
@property (nonatomic, strong) NSString *questionAnswerC;
@property (nonatomic, strong) NSString *questionAnswerD;
@property (nonatomic, strong) NSString *questionDesc;
@property (nonatomic, strong) NSNumber *questionID;
@property (nonatomic, strong) NSString *questionImageTitle;
@property (nonatomic, strong) NSNumber *questionRightAnswer;
@property (nonatomic, strong) NSNumber *questionSelectedIndex;
@property (nonatomic, strong) NSNumber *questionType;
@property (nonatomic, strong) NSString *questionExplain;

-(instancetype) initWithQuestionItem:(SWQuestionItems *) questionItem questionType:(TestQuestionViewType) type;
@end


@interface SWDriverTestQuestionView : UIView
- (instancetype) initWithQuestion:(SWQuestionItems *) question viewType:(TestQuestionViewType) viewType displayData:(SWDriverTestQuestionViewDisplayData *) displayData;

//- (instancetype) initWithQuestion:(SWQuestionItems *)question viewType:(TestQuestionViewType)viewType pageNum:(NSInteger) pageNum;
@property(nonatomic, strong) SWQuestionItems *question;
@end



