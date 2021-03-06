//
//  SWLoginUser.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/6.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "SWLoginUser.h"


#import "SWUserInfo+CoreDataProperties.h"
#import "SWMarkItems+CoreDataProperties.h"
#import "SWWrongItems+CoreDataProperties.h"
#import "SWQuestionStatus+CoreDataProperties.h"
#import "SWCommonUtils.h"
#import "SWDriverTestBigoDef.h"

#define SW_USER_HEAD_IMAGE_NAME @"UserHeadImage"

@implementation SWLoginUser
static SWLoginUser *userInstance = nil;
static SWUserInfo *userInfo = nil;
+ (SWLoginUser *) loginWithUserName:(NSString *) userName PassWord:(NSString *) psw
{
    //to do keychain check password
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"SWUserInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName=%@", userName];
    fetch.predicate = predicate;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    if (result.count > 0) {
        userInfo = (SWUserInfo *)result.lastObject;
        static dispatch_once_t once_predicate;
        dispatch_once(&once_predicate, ^{
            userInstance = [[self alloc] init];
            if (userInstance) {
                userInstance.userName = userInfo.userName;
                [userInstance getUserHeadImage];
               
                NSLog(@"user ID is %ld", userInfo.userID.integerValue);
            }
        });
    }
    return userInstance;
    
}
+ (SWLoginUser *) sharedInstance
{
    return userInstance;
}

+ (SWUserRegisterRetType) registerUserWithName:(NSString *) userName PassWord:(NSString *) psw
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSEntityDescription *userInfoEntity = [NSEntityDescription entityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:userInfoEntity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName=%@", userName];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        return kUserNameExisted;
    }
    
    // insert the new user
    SWUserInfo *userInfoItem =  (SWUserInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    userInfoItem.userName = userName;
    [appDelegate saveContext];
    return kUserRegisterSuccessed;
    
}

#pragma mark Mark questions
- (void) markQuestion:(SWQuestionItems *) markedQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWMarkItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSLog(@"predicate is %@", [NSString stringWithFormat:@"userID=%ld", userInfo.userID.integerValue ]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        // create new mark lib
        SWMarkItems *markItems = (SWMarkItems *)[NSEntityDescription insertNewObjectForEntityForName:@"SWMarkItems" inManagedObjectContext:appDelegate.managedObjectContext];
        markItems.userID = userInfo.userID;
        [markItems addQuestionsObject:markedQuestion];
        markedQuestion.markQuestionsLib = markItems;
    }else
    {
        SWMarkItems *markItems = fetchedObjects.lastObject;
        [markItems addQuestionsObject:markedQuestion];
        markedQuestion.markQuestionsLib = markItems;
    }
    
    [appDelegate saveContext];
}

- (void) unmarkQuestion:(SWQuestionItems *) markedQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWMarkItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return;
    }else
    {
        SWMarkItems *markItems = fetchedObjects.lastObject;
        [markItems removeQuestionsObject:markedQuestion];
        markedQuestion.markQuestionsLib = nil;
    }
    
    [appDelegate saveContext];
}

- (NSSet *) getUserMarkedQuestions
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWMarkItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count != 0) {
        SWMarkItems *markItems = fetchedObjects.lastObject;
        return markItems.questions;
    }
    return nil;
}
#pragma mark Wrong QUestions
- (void) addWrongQuestion:(SWQuestionItems *) wrongQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWWrongItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        SWWrongItems *wrongQuestionLib = (SWWrongItems *)[NSEntityDescription insertNewObjectForEntityForName:@"SWWrongItems" inManagedObjectContext:appDelegate.managedObjectContext];
        wrongQuestionLib.userID = userInfo.userID;
        [wrongQuestionLib addQuestionsObject:wrongQuestion];
        wrongQuestion.wrongQuestionsLib = wrongQuestionLib;
    }else
    {
        SWWrongItems *wrongQuestionLib = fetchedObjects.lastObject;
        [wrongQuestionLib addQuestionsObject:wrongQuestion];
        wrongQuestion.wrongQuestionsLib = wrongQuestionLib;
    }
    // update wrong question
    [self increaseWrongQuestoion];
    [appDelegate saveContext];
}
- (void) removeWrongQuestion:(SWQuestionItems *) wrongQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWWrongItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return;
    }else
    {
        SWWrongItems *wrongItems = fetchedObjects.lastObject;
        [wrongItems removeQuestionsObject:wrongQuestion];
        wrongQuestion.wrongQuestionsLib = nil;
    }
    
    [appDelegate saveContext];

}

- (NSSet *) getUserWrongQuestions
{
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWWrongItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count != 0) {
        SWWrongItems *markItems = fetchedObjects.lastObject;
        return markItems.questions;
    }
    return nil;

}

- (void) savaUserQuestionStatus:(NSNumber *) questionIndex
{
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWQuestionStatus" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchResult = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchResult.count ==0) {
        SWQuestionStatus *questionStatus = [NSEntityDescription insertNewObjectForEntityForName:@"SWQuestionStatus" inManagedObjectContext:appDelegate.managedObjectContext];
        questionStatus.userID = userInfo.userID;
        questionStatus.currentQuestionIndex = questionIndex;
    }else
    {
        SWQuestionStatus *questionStatus = fetchResult.lastObject;
        questionStatus.currentQuestionIndex = questionIndex;
    }
    
    [appDelegate saveContext];
}

- (NSNumber *) loadUserQuestionIndex
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWQuestionStatus" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count != 0) {
        SWQuestionStatus *questionStatus = fetchedObjects.lastObject;
        return questionStatus.currentQuestionIndex;
    }
    return [NSNumber numberWithInteger:0];

}

-(void) saveUserAnsweredQuestion:(SWQuestionItems *) answeredQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

- (NSInteger) increaseAnsweredQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result.count) {
        SWUserInfo *userInfo = result.lastObject;
        userInfo.totalAnswersNum = [NSNumber numberWithInteger:(userInfo.totalAnswersNum.integerValue+1)];
        [appDelegate saveContext];
    }
    return userInfo.totalAnswersNum.integerValue;
    
}
- (NSInteger) increaseWrongQuestoion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result.count) {
        SWUserInfo *userInfo = result.lastObject;
        userInfo.wrongAnswersNum = [NSNumber numberWithInteger:(userInfo.wrongAnswersNum.integerValue+1)];
        [appDelegate saveContext];
    }
    return userInfo.wrongAnswersNum.integerValue;
}

- (NSInteger) totalAnsweredQuestions
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result.count) {
        SWUserInfo *userInfo = result.lastObject;
        return userInfo.totalAnswersNum.integerValue;
    }
    return 0;

}
- (NSInteger) totalWrongQuestions
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result.count) {
        SWUserInfo *userInfo = result.lastObject;
        return userInfo.wrongAnswersNum.integerValue;
    }
    return 0;
}

- (void) cleanUpAnswerStatistic
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWUserInfo" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%ld", userInfo.userID.integerValue];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (result.count) {
        SWUserInfo *userInfo = result.lastObject;
        userInfo.totalAnswersNum = nil;
        userInfo.wrongAnswersNum = nil;
    }

}

- (BOOL) updateUserHeadImage:(UIImage *) headImage
{
    NSString *savePath = [SWLoginUser userImageSavedDiectoryPath];
    savePath = [savePath stringByAppendingPathComponent:SW_USER_HEAD_IMAGE_NAME];
    NSData * imageData = nil;
    if((imageData = UIImagePNGRepresentation(headImage)) ||
       (imageData = UIImageJPEGRepresentation(headImage, 0.6)))
    {
        if([SWCommonUtils saveFile:imageData ToPath:savePath withMode:kSaveFileAlways])
        {
            _userImage = headImage;
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATED object:nil];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) updateUserName:(NSString *) userName
{
    userInfo.userName = userName;
    userInstance.userName = userName;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_INFO_UPDATED object:nil];
    return YES;
}

- (UIImage *) getUserHeadImage
{
    if (_userImage) {
        return _userImage;
    }
    
    NSString *savePath = [SWLoginUser userImageSavedDiectoryPath];
    savePath = [savePath stringByAppendingPathComponent:SW_USER_HEAD_IMAGE_NAME];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if ([fileManager fileExistsAtPath:savePath isDirectory:&isDirectory]) {
        if (!isDirectory) {
            _userImage =  [UIImage imageWithContentsOfFile:savePath];
        }
    }else
    {
        _userImage = [UIImage imageNamed:@"defUserHeadImg"];
    }
    
    return _userImage;
}

-(NSString *) getUserName
{
    return _userName;
}

#pragma mark - private tool functions
+(NSString *) userImageSavedDiectoryPath
{
    NSString *savepath = [[SWCommonUtils appDocumentFolderPath] stringByAppendingPathComponent:@"UserData"];
    if([SWCommonUtils createSubDirectory:@"UserData" atPath:[SWCommonUtils appDocumentFolderPath]])
    {
        return savepath;
    }
    return nil;
}


@end
