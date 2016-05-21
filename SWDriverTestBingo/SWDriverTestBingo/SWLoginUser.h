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

typedef NS_ENUM(NSInteger, SWUserRegisterRetType)
{
    kUserNameExisted = 1,
    kUserRegisterSuccessed,
};

@interface SWLoginUser : NSObject
+ (SWLoginUser *) loginWithUserName:(NSString *) userName PassWord:(NSString *) psw;
+ (SWLoginUser *) sharedInstance;
+ (SWUserRegisterRetType) registerUserWithName:(NSString *) userName PassWord:(NSString *) psw;

- (void) markQuestion:(SWQuestionItems *) markedQuestion;
- (void) unmarkQuestion:(SWQuestionItems *) markedQuestion;
- (NSSet *) getUserMarkedQuestions;

- (void) addWrongQuestion:(SWQuestionItems *) wrongQuestion;
- (void) removeWrongQuestion:(SWQuestionItems *) wrongQuestion;
- (NSSet *) getUserWrongQuestions;

- (void) savaUserQuestionStatus:(NSNumber *) questionIndex;
- (NSNumber *) loadUserQuestionIndex;

- (BOOL) updateUserHeadImage:(UIImage *) headImage;
- (BOOL) updateUserName:(NSString *) userName;

- (UIImage *) getUserHeadImage;
- (NSString *) getUserName;

- (void) saveUserAnsweredQuestion:(SWQuestionItems *) answeredQuestion;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) UIImage *userImage;
@end
