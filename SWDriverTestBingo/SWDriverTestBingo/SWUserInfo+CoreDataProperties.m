//
//  SWUserInfo+CoreDataProperties.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SWUserInfo+CoreDataProperties.h"

@implementation SWUserInfo (CoreDataProperties)

@dynamic userID;
@dynamic userName;
@dynamic userImage;
@dynamic remark;
@dynamic totalAnswersNum;
@dynamic wrongAnswersNum;
@dynamic averageTestScore;
@dynamic markQuestionsLib;
@dynamic wrongQuestionsLib;
@dynamic questionStatus;

@end
