//
//  AGDesctopDirectoryTableViewController.m
//  34.UITableView_Navigation
//
//  Created by MC723 on 15.01.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGDesctopDirectoryTableViewController.h"
#import "AGFileCell.h"
#import "NSObject+AGFolderSize.h"

@interface AGDesctopDirectoryTableViewController ()
@property (strong, nonatomic) NSArray *contents;

@end

@implementation AGDesctopDirectoryTableViewController

- (id) initWithFolderPath: (NSString *) path {
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    return self;
}


- (void) setPath:(NSString *)path {
    _path = path;
    
    NSError *error = nil;
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path
                                                                        error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSString *name in self.contents) {
        if (![name hasPrefix:@"."]) {
            [tempArray addObject:name];
        }
    }
    self.contents = tempArray;
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
}


- (void) dealloc {
    NSLog(@"controller with path %@ has been deallocated", self.path);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/md318/Desktop";
    }
    [self sortObjects: self.contents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods

- (NSArray*) sortArray:(NSMutableArray*) muableArray {
    
    NSArray *sortedArray = [NSArray arrayWithArray:muableArray];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
    NSArray * arrayWithDescriptor = [NSArray arrayWithObject:descriptor];
    sortedArray = [sortedArray sortedArrayUsingDescriptors:arrayWithDescriptor];
    
    return sortedArray;
    
}

- (void) sortObjects:(NSArray*)array {
    
    NSArray *tempArray = [NSArray arrayWithArray:array];
    NSMutableArray *arrayDirectory = [[NSMutableArray alloc] init];
    NSMutableArray *arrayFiles = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [tempArray count]; i++) {
        
        if ([self isDirectoryAtIndexPathWithInteger:i]) {
            
            [arrayDirectory addObject:[array objectAtIndex:i]];
            
        } else {
            [arrayFiles addObject:[array objectAtIndex:i]];
        }
        
        
    }
    
    NSArray *sortedTempArray = [[self sortArray:arrayDirectory] arrayByAddingObjectsFromArray:[self sortArray:arrayFiles]];
    
    self.contents = sortedTempArray;
}



- (BOOL) isDirectoryAtIndexPath:(NSIndexPath *) indexPath {
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return isDirectory;
}

- (BOOL) isDirectoryAtIndexPathWithInteger:(NSInteger) index {
    
    NSString* fileName = [self.contents objectAtIndex:index];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return isDirectory;
}

- (NSString*) fileSizeFromValue:(unsigned long long) size {
    
    static NSString* units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
    
    int index = 0;
    
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitsCount) {
        fileSize /= 1024;
        index++;
    }
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
}


#pragma mark - Actions

- (IBAction)actionEdit:(UIBarButtonItem *)sender {
    
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    if (self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(actionAdd:)];
        [self.navigationItem setLeftBarButtonItem:addButton animated:YES];
        
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:item
                                   target:self
                                   action:@selector(actionEdit:)];
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
}


- (void) actionAdd:(UIBarButtonItem *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File manager"
                                                    message:@"Type name of file or directory"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *alertText = [alertView textFieldAtIndex:0].text;
    NSString *pathNewFile = [self.path stringByAppendingPathComponent:alertText];
    
    
    NSFileManager *directory = [NSFileManager defaultManager];
    NSError *error = nil;
    
    BOOL isDir = NO;
    if (![directory fileExistsAtPath:pathNewFile isDirectory:&isDir]){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:pathNewFile withIntermediateDirectories:NO attributes:nil error:&error];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.contents];
        [tempArray addObject:alertText];
        
        self.contents = tempArray;
        
        [self sortObjects:self.contents];
        
        NSInteger rowInArray = [self.contents indexOfObject:alertText];
        
        [self.tableView beginUpdates];
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:rowInArray inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[NSString stringWithFormat:@"File or folder \"%@\" already exists!", alertText]
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *folderCell = @"FolderCell";
    static NSString *fileCell = @"FileCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];

    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                                                error:nil];

        
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderCell];
        
        cell.textLabel.text = fileName;
        cell.detailTextLabel.text = [self fileSizeFromValue:[self sizeOfDirectory:filePath]];
        return cell;
        
        
        
    } else {
        
        AGFileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileCell];
        
        cell.lableName.text = fileName;
        cell.lableSize.text = [self fileSizeFromValue:[attributes fileSize]];
        
        static NSDateFormatter *dateFormatter = nil;
        
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        cell.lableDate.text = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        return cell;
        
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString* name = [self.contents objectAtIndex:indexPath.row];
        NSString* path = [self.path stringByAppendingPathComponent:name];
        
        NSFileManager* defaultManager = [NSFileManager defaultManager];
        NSError* error = nil;
        
        [defaultManager removeItemAtPath:path error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        self.path = _path;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        return 60.f;
    } else {
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* path = [self.path stringByAppendingPathComponent:fileName];
        
        AGDesctopDirectoryTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AGDesctopDirectoryTableViewController"];
        vc.path = path;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
