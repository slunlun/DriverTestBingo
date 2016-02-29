//
//  SWQuestionItems+CoreDataProperties.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/2/27.
//  Copyright © 2016年 Eren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SWQuestionItems.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWQuestionItems (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *questionAnswerA;
@property (nullable, nonatomic, retain) NSString *questionAnswerB;
@property (nullable, nonatomic, retain) NSString *questionAnswerC;
@property (nullable, nonatomic, retain) NSString *questionAnswerD;
@property (nullable, nonatomic, retain) NSString *questionDesc;
@property (nullable, nonatomic, retain) NSNumber *questionID;
@property (nullable, nonatomic, retain) NSString *questionImageTitle;
@property (nullable, nonatomic, retain) NSNumber *questionRightAnswer;
@property (nullable, nonatomic, retain) NSNumber *questionSelectedIndex;
@property (nullable, nonatomic, retain) NSNumber *questionType;
@property (nullable, nonatomic, retain) NSString *questionExplain;
@property (nullable, nonatomic, retain) SWMarkItems *markQuestionsLib;
@property (nullable, nonatomic, retain) SWWrongItems *wrongQuestionsLib;

@end

NS_ASSUME_NONNULL_END
