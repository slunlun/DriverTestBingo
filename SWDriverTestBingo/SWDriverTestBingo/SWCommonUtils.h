//
//  SWCommonUtils.h
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/1/4.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWUserInfo+CoreDataProperties.h"
#import "SWWrongItems+CoreDataProperties.h"
#import "SWMarkItems+CoreDataProperties.h"
#import "SWQuestionItems+CoreDataProperties.h"
#import "SWQuestionStatus+CoreDataProperties.h"
#import "SWTableMaxIndex+CoreDataProperties.h"

typedef enum : NSUInteger {
    kSaveFileAlways = 1,
    kSaveFileIfNotExist,
} SWFileSaveMode;

@interface SWCommonUtils : NSObject
+ (NSNumber *) getTableMaxIndex:(NSString *) tableName;
+ (void) updataTableIndex:(NSString *) tableName;

+(NSString *) appDocumentFolderPath;

+(BOOL) createSubDirectory:(NSString *) directoryName atPath:(NSString *) parentPath;
+(BOOL) saveFile:(NSData *) fileData ToPath:(NSString *) filePath withMode:(SWFileSaveMode) saveMode;
@end
