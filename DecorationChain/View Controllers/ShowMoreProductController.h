//
//  ShowMoreProductController.h
//  DecorationChain
//
//  Created by sven on 7/27/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductProfileTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "XPProgressHUD.h"

@interface ShowMoreProductController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *mutListMore;
@end
