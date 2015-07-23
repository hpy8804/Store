//
//  ReportHistoryListTableViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/29.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportHistoryListTableViewController.h"
#import "ReportViewModel.h"
#import "ProfileModel.h"
#import "XPProgressHUD.h"

#import <MJRefresh/MJRefresh.h>
#import <XPKit/XPKit.h>

#import "ReportHistoryTableViewCell.h"
#import "ReportHistoryDetailViewController.h"
#import "ReportHistoryModel.h"

@interface ReportHistoryListTableViewController ()

@property (strong, nonatomic) IBOutlet ReportViewModel *viewModel;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ReportHistoryListTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[self.tableView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 0;
	    [self fetchWithPage:self.page];
	}];
	[self.tableView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self fetchWithPage:self.page];
	}];
	[self.tableView hideEmptySeparators];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ReportHistoryDetailViewController *viewController = segue.destinationViewController;
	viewController.analysisID = sender;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ReportHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	ReportHistoryModel *model = self.products[indexPath.row];
	[cell updateWithModel:model];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	ReportHistoryModel *model = self.products[indexPath.row];
	[self performSegueWithIdentifier:@"detail" sender:model.id];
}

#pragma mark - CustomActions
- (void)fetchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel reportHistoryListWithID:[ProfileModel singleton].model.id type:self.type page:self.page] subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.tableView headerEndRefreshing];
	    [self.tableView footerEndRefreshing];
	    if (0 == page) {
	        self.products = x;
		}
	    else {
	        NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.products];
	        [buffer addObjectsFromArray:x];
	        self.products = buffer;
		}
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

@end
