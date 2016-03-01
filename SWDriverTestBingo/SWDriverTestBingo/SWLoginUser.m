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
                userInstance.userImage = [UIImage imageWithData:userInfo.userImage];
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

#pragma mark Mark questions
+ (void) markQuestion:(SWQuestionItems *) markedQuestion
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

+ (void) unmarkQuestion:(SWQuestionItems *) markedQuestion
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

+ (NSSet *) getUserMarkedQuestions
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
+ (void) addWrongQuestion:(SWQuestionItems *) wrongQuestion
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
    
    [appDelegate saveContext];
}
+ (void) removeWrongQuestion:(SWQuestionItems *) wrongQuestion
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

+ (NSSet *) getUserWrongQuestions
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

+ (void) savaUserQuestionStatus:(NSNumber *) questionIndex
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

+ (NSNumber *) loadUserQuestionIndex
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

+(void) saveUserAnsweredQuestion:(SWQuestionItems *) answeredQuestion
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
}

@end
