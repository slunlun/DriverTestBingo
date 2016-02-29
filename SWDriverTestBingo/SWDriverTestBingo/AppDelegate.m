//
//  AppDelegate.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "AppDelegate.h"

#import "SWUserInfo+CoreDataProperties.h"
#import "SWCommonUtils.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [self initUserInfo];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.eren.SWDriverTestBingo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SWDriverTestBingo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SWDriverTestBingo.sqlite"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SWDriverTestBingo" ofType:@"sqlite"]];
        NSError *err = nil;
        if ([[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            if (err) {
                NSLog(@"Oops, could  copy!");
            }
        }
    }
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - JUST FOR TEST
- (void) initUserInfo
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        NSLog(@"第一次启动");
        
        // userInfo
        SWUserInfo *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SWUserInfo" inManagedObjectContext:[self managedObjectContext]];
        userInfo.userName = @"John";
        userInfo.userID = [SWCommonUtils getTableMaxIndex:@"SWUserInfo"];
        
        
        // questionItem
//        for (int i = 1; i < 600; i++) {
//            SWQuestionItems *questionItem = [NSEntityDescription insertNewObjectForEntityForName:@"SWQuestionItems" inManagedObjectContext:self.managedObjectContext];
//            questionItem.questionDesc = @"当前方有人行横道时，应该加速行驶。";
//            questionItem.questionAnswerA = @"A.正确";
//            questionItem.questionAnswerB = @"B.错误";
//            questionItem.questionRightAnswer = [NSNumber numberWithInteger:0];
//            questionItem.questionType = [NSNumber numberWithInteger:2];
//            
//            SWQuestionItems *questionItem2 = [NSEntityDescription insertNewObjectForEntityForName:@"SWQuestionItems" inManagedObjectContext:self.managedObjectContext];
//            questionItem2.questionDesc = @"当机动车驾驶人驾驶没有牌照的车子上路时，交警可以做出如下那种处罚";
//            questionItem2.questionAnswerA = @"A.吊销驾照";
//            questionItem2.questionAnswerB = @"B.罚款500元以上 1000元以下";
//            questionItem2.questionAnswerC = @"C.拘禁四个月";
//            questionItem2.questionAnswerD = @"D.在规定的30个工作日内，向当地车管所备案";
//            questionItem2.questionRightAnswer = [NSNumber numberWithInteger:2];
//            questionItem2.questionImageTitle = @"qImg1";
//            questionItem2.questionType = [NSNumber numberWithInteger:1];
//            
//            [self.managedObjectContext save:nil];
//
//        }
        
    }else{
        NSLog(@"不是第一次启动");
    }
}

-(BOOL) application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL) application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
