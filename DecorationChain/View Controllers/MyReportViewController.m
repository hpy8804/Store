//
//  MyReportViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyReportViewController.h"
#import "ReportViewModel.h"

#import <MJRefresh/MJRefresh.h>
#import <XPKit/XPKit.h>
#import <XPToast/XPToast.h>
#import <CSNNotificationObserver/CSNNotificationObserver.h>
#import <DOPDropDownMenu/DOPDropDownMenu.h>

#import "XPProgressHUD.h"
#import "ProfileModel.h"
#import "ReportStoreModel.h"
#import "ReportMyTableViewCell.h"
#import "AddressModel.h"

@interface MyReportViewController ()

@property (strong, nonatomic) IBOutlet ReportViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableSet *selectedSet;
@property (nonatomic, strong) AddressModel *orderAddressModel;
@property (nonatomic, strong) CSNNotificationObserver *observer;

@end

@implementation MyReportViewController

#pragma mark - Life circle
- (void)viewDidLoad {
	[super viewDidLoad];

	self.selectedSet = [NSMutableSet set];
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

	[[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (self.orderAddressModel) {
	        [self reportProdouct];
		}
	    else {
	        NSString *defaultAddressId = [ProfileModel singleton].model.defaultAddressId;
	        if (![ProfileModel singleton].wasLogin) {   // 未登陆
	            [self presentLogin];
			}
	        else if (!defaultAddressId || [defaultAddressId isEqualToString:@"nil"]) {
	            [self addDefaultAddress];
			}
	        else {
	            [self reportProdouct];
			}
		}
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - UITableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ReportMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	ReportStoreModel *model = self.products[indexPath.row];
	[cell updateWithModel:model];

	cell.selectButton.tag = indexPath.row;
	@weakify(self);
	[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(UIButton *x) {
	    @strongify(self);
	    if (x.selected) {
	        [self.selectedSet addObject:@(x.tag)];
		}
	    else {
	        [self.selectedSet removeObject:@(x.tag)];
		}
	}];
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	ReportMyTableViewCell *_cell = (ReportMyTableViewCell *)cell;
	[_cell.selectButton setSelected:NO];
	[self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
	    if (indexPath.row == obj.integerValue) {
	        [_cell.selectButton setSelected:YES];
		}
	}];
}

#pragma mark - custom action
- (void)fetchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel myReportsWithID:[ProfileModel singleton].model.id page:self.page]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.tableView headerEndRefreshing];
	    [self.tableView footerEndRefreshing];
	    if (0 == page) {
	        self.products = x;
	        [self.reportButton setHidden:NO];
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

- (void)reportProdouct {
	NSMutableArray *reports = [NSMutableArray array];
	for (NSInteger i = 0; i < self.products.count; i++) {
		ReportMyTableViewCell *cell = (ReportMyTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.selectedReport && cell.number) {
			ReportStoreModel *model = self.products[i];
			[reports addObject:@{
			     @"id":model.id,
			     @"num":@(cell.number)
			 }];
		}
	}
	if (!reports.count) {
		[XPToast showWithText:@"当前未选择报单"];
		return;
	}

	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel createReportWithID:[ProfileModel singleton].model.id addressID:self.orderAddressModel.id type:@"2" reports:reports]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.navigationController popViewControllerAnimated:YES];
	    [XPToast showWithText:@"报单成功"];
	    [XPProgressHUD dismiss];
	}];
}

- (void)addDefaultAddress {
	@weakify(self);
	self.observer = [[CSNNotificationObserver alloc] initWithName:@"selected_address" object:nil queue:[NSOperationQueue currentQueue] usingBlock: ^(NSNotification *notification) {
	    @strongify(self);
	    self.orderAddressModel = [notification object];
	}];
	BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"MyAddress"];
	viewController.model = [BaseObject new];
	viewController.model.baseTransfer = @"joined_product_order";
	[self.navigationController pushViewController:viewController animated:YES];
}

@end
