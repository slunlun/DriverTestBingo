//
//  SWLoginUser.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/6.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "SWQuestionItems+CoreDataProperties.h"

@interface SWLoginUser : NSObject
+ (SWLoginUser *) loginWithUserName:(NSString *) userName PassWord:(NSString *) psw;
+ (SWLoginUser *) sharedInstance;

+ (void) markQuestion:(SWQuestionItems *) markedQuestion;
+ (void) unmarkQuestion:(SWQuestionItems *) markedQuestion;
+ (NSSet *) getUserMarkedQuestions;

+ (void) addWrongQuestion:(SWQuestionItems *) wrongQuestion;
+ (void) removeWrongQuestion:(SWQuestionItems *) wrongQuestion;
+ (NSSet *) getUserWrongQuestions;

@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) UIImage *userImage;
@end
