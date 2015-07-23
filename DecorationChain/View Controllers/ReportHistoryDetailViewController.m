//
//  ReportHistoryDetailViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/29.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportHistoryDetailViewController.h"
#import "ReportViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import <XPKit/XPKit.h>

#import "XPProgressHUD.h"
#import "ProfileModel.h"
#import "ReportMyTableViewCell.h"
#import "ReportStoreModel.h"
#import "ReportStoreTableViewCell.h"

@interface ReportHistoryDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic) IBOutlet ReportViewModel *viewModel;

@end

@implementation ReportHistoryDetailViewController

#pragma mark - LifeCircle
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
	[self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - UITableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ReportStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	ReportStoreModel *model = self.products[indexPath.row];
	[cell updateWithModel:model];
	return cell;
}

#pragma mark - CustomAction
- (void)fetchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel reportDetailWithID:[ProfileModel singleton].model.id analysisID:self.analysisID]
	 subscribeNext: ^(id x) {
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
