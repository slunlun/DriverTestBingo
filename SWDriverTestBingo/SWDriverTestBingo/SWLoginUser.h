//
//  SWLoginUser.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/6.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWQuestionItems+CoreDataProperties.h"

@interface SWLoginUser : NSObject
+ (SWLoginUser *) loginWithUserName:(NSString *) userName PassWord:(NSString *) psw;
+ (SWLoginUser *) sharedInstance;

+ (void) markQuestion:(SWQuestionItems *) markedQuestion;
+ (void) unmarkQuestion:(SWQuestionItems *) markedQuestion;

@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) NSData *userImage;
@end
