//
//  SWWrongItems+CoreDataProperties.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SWWrongItems.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWWrongItems (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSSet<SWQuestionItems *> *questions;
@property (nullable, nonatomic, retain) SWUserInfo *user;

@end

@interface SWWrongItems (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(SWQuestionItems *)value;
- (void)removeQuestionsObject:(SWQuestionItems *)value;
- (void)addQuestions:(NSSet<SWQuestionItems *> *)values;
- (void)removeQuestions:(NSSet<SWQuestionItems *> *)values;

@end

NS_ASSUME_NONNULL_END
