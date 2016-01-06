//
//  SWTableMaxIndex+CoreDataProperties.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SWTableMaxIndex.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWTableMaxIndex (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *maxIndex;
@property (nullable, nonatomic, retain) NSString *tableName;

@end

NS_ASSUME_NONNULL_END
