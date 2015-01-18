//
//  NSObject+AGFolderSize.h
//  34.UITableView_Navigation
//
//  Created by MC723 on 18.01.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AGFolderSize)

- (unsigned long long) sizeOfDirectory:(NSString*) folderPath;
@end
