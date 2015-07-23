//
//  BaseTableViewController.h
//  DecorationChain
//
//  Created by huangxinping on 15/2/2.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewController.h"
#import <AFDynamicTableHelper/AFDynamicTableHelper.h>

@interface BaseTableViewController : BaseViewController <AFDynamicTableHelperDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AFDynamicTableHelper *tableHelper;
@property (nonatomic, strong) UITableView *tableView;

@end
