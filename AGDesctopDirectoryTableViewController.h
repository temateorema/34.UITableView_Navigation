//
//  AGDesctopDirectoryTableViewController.h
//  34.UITableView_Navigation
//
//  Created by MC723 on 15.01.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGDesctopDirectoryTableViewController : UITableViewController

@property (strong, nonatomic) NSString *path;

- (id) initWithFolderPath:(NSString *) path;
- (IBAction)actionEdit:(UIBarButtonItem *)sender;

@end
