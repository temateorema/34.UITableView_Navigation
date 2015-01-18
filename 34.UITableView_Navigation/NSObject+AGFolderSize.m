//
//  NSObject+AGFolderSize.m
//  34.UITableView_Navigation
//
//  Created by MC723 on 18.01.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "NSObject+AGFolderSize.h"

@implementation NSObject (AGFolderSize)


- (unsigned long long) sizeOfDirectory:(NSString*) folderPath {
    
    unsigned long long size = 0;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath
                                                                         error:nil];
    
    for (NSString *file in array) {
        
        NSString *path = [folderPath stringByAppendingPathComponent:file];
        
        BOOL directory = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&directory];
        
        
        if (!directory) {
            NSDictionary *attributes = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:path error:nil];
            
            size += [attributes fileSize];
        
        } else {
            size += [self sizeOfDirectory:[folderPath stringByAppendingPathComponent:file]];
        }
    }
    return size;

}

@end
