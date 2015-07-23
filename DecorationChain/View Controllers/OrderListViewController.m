//
//  OrderListViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"

#import "MyOrderViewModel.h"
#import "ProfileModel.h"

#import <XPKit/XPKit.h>
#import "XPProgressHUD.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>

#ifndef REUSE_CELL_IDENTIFIER
#define REUSE_CELL_IDENTIFIER  @"Cell"
#endif
@interface OrderListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MyOrderViewModel *viewModel;
@property (nonatomic, strong) NSArray *orders;
@property (nonatomic, assign) NSInteger page;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:REUSE_CELL_IDENTIFIER];
	[self.tableView hideEmptySeparators];

	@weakify(self);
	[self.tableView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self orderListWithPage:self.page];
	}];
	[self.tableView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self orderListWithPage:self.page];
	}];
	[self.tableView headerBeginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_order_info"]) {
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
		viewController.model = [BaseObject new];
		viewController.model.baseTransfer = [(OrderListModel *)sender id];
	}
}

#pragma mark - override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELL_IDENTIFIER forIndexPath:indexPath];
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil] lastObject];
	}
	OrderListModel *model = self.orders[indexPath.row];
	[cell updateWithModel:model];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	OrderListModel *model = self.orders[indexPath.row];
	[self performSegueWithIdentifier:@"embed_order_info" sender:model];
}

#pragma mark - function
- (void)orderListWithPage:(NSInteger)page {
	@weakify(self);
	[XPProgressHUD showWithStatus:@"加载中"];
	self.viewModel = [[MyOrderViewModel alloc] init];
	[[self.viewModel orderListWithID:[ProfileModel singleton].model.id orderType:self.model.baseTransfer.integerValue page:self.page]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (1 == page) {
	        self.orders = x;
		}
	    else {
	        NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.orders];
	        [buffer addObjectsFromArray:x];
	        self.orders = buffer;
		}

	    [self.tableView headerEndRefreshing];
	    [self.tableView footerEndRefreshing];
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

@end
