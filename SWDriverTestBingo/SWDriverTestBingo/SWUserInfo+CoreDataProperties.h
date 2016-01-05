//
//  SWUserInfo+CoreDataProperties.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SWUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWUserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSData *userImage;
@property (nullable, nonatomic, retain) NSString *remark;
@property (nullable, nonatomic, retain) NSNumber *totalAnswersNum;
@property (nullable, nonatomic, retain) NSNumber *wrongAnswersNum;
@property (nullable, nonatomic, retain) NSNumber *averageTestScore;
@property (nullable, nonatomic, retain) SWMarkItems *markQuestionsLib;
@property (nullable, nonatomic, retain) SWWrongItems *wrongQuestionsLib;
@property (nullable, nonatomic, retain) SWQuestionStatus *questionStatus;

@end

NS_ASSUME_NONNULL_END
