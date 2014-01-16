//
//  DEMOMenuViewController.h
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface DEMOMenuViewController : REFrostedViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *songsDictionary;
}

@property (weak, readwrite, nonatomic) UINavigationController *navigationController;
@property (strong, readwrite, nonatomic) UITableView *tableView;
@end
