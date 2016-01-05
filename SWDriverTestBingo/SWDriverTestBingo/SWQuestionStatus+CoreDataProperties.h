//
//  SWQuestionStatus+CoreDataProperties.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SWQuestionStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWQuestionStatus (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSNumber *currentQuestionIndex;
@property (nullable, nonatomic, retain) SWUserInfo *user;

@end

NS_ASSUME_NONNULL_END
