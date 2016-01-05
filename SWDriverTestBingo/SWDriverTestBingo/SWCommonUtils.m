//
//  SWCommonUtils.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "SWCommonUtils.h"
#import "AppDelegate.h"

@implementation SWCommonUtils
+ (NSNumber *) getTableMaxIndex:(NSString *) tableName
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWTableMaxIndex" inManagedObjectContext:appDelegate.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tableName=%@", tableName];
    fetch.predicate = predicate;
    fetch.entity = entity;
    
   
    NSError *error = nil;
    NSArray *fetchResult = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"get table max index error = %@", error);
        return nil;
    }
    
    if (fetchResult.count > 0) {
        SWTableMaxIndex *maxIndex = (SWTableMaxIndex *)fetchResult.lastObject;
        return maxIndex.maxIndex;
    }else
    {
        SWTableMaxIndex *maxIndex = [NSEntityDescription insertNewObjectForEntityForName:@"SWTableMaxIndex" inManagedObjectContext:appDelegate.managedObjectContext];
        maxIndex.maxIndex = [NSNumber numberWithInteger:1];
        maxIndex.tableName = tableName;
        [appDelegate.managedObjectContext save:nil];
        return [NSNumber numberWithInteger:1];
    }
    return nil;
}
+ (void) updataTableIndex:(NSString *) tableName
{
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"SWTableMaxIndex"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"table=%@", tableName];
    fetch.predicate = predicate;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSError *error = nil;
    NSArray *fetchResult = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"updata max table index error = %@", error);
        return;
    }
    if (fetchResult.count > 0) {
        SWTableMaxIndex *maxIndex = (SWTableMaxIndex *)fetchResult.lastObject;
        NSInteger index = [maxIndex.maxIndex integerValue];
        index++;
        maxIndex.maxIndex = [NSNumber numberWithInteger:index];
        [appDelegate.managedObjectContext save:nil];
    }else
    {
        SWTableMaxIndex *maxIndex = [NSEntityDescription insertNewObjectForEntityForName:@"SWTableMaxIndex" inManagedObjectContext:appDelegate.managedObjectContext];
        maxIndex.maxIndex = [NSNumber numberWithInteger:1];
        [appDelegate.managedObjectContext save:nil];
    }
    
}
@end
