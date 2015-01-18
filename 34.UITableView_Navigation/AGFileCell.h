//
//  AGFileCell.h
//  34.UITableView_Navigation
//
//  Created by MC723 on 15.01.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGFileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableName;
@property (weak, nonatomic) IBOutlet UILabel *lableSize;
@property (weak, nonatomic) IBOutlet UILabel *lableDate;

@end
