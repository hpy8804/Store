//
//  ReportStoreViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportStoreViewController.h"
#import "ReportViewModel.h"

#import <MJRefresh/MJRefresh.h>
#import <XPKit/XPKit.h>
#import <XPToast/XPToast.h>
#import <CSNNotificationObserver/CSNNotificationObserver.h>
#import <DOPDropDownMenu/DOPDropDownMenu.h>


#import "XPProgressHUD.h"
#import "ReportCategoriesModel.h"
#import "ProfileModel.h"
#import "ReportStoreTableViewCell.h"
#import "ReportStoreModel.h"
#import "EditAddressViewController.h"
#import "AddressModel.h"

@interface ReportStoreViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet ReportViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSString *category;

@property (nonatomic, strong) NSArray *kinds;

@property (nonatomic, strong) AddressModel *orderAddressModel;
@property (nonatomic, strong) CSNNotificationObserver *observer;

@end

@implementation ReportStoreViewController

#pragma mark - Life circle
- (void)viewDidLoad {
	[super viewDidLoad];
	[self fetchAllCategories];

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

	[[self.reportButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (self.orderAddressModel) {
	        [self reportProdouctWithAddressID:nil];
		}
	    else {
	        NSString *defaultAddressId = [ProfileModel singleton].model.defaultAddressId;
	        if (![ProfileModel singleton].wasLogin) {  // 未登陆
	            [self presentLogin];
			}
	        else if (!defaultAddressId || [defaultAddressId isEqualToString:@"nil"]) {
	            [self addDefaultAddress];
			}
	        else {
	            [self reportProdouctWithAddressID:defaultAddressId];
			}
		}
	}];

	[[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (self.orderAddressModel) {
	        [self reportProdouctWithAddressID:nil];
		}
	    else {
	        NSString *defaultAddressId = [ProfileModel singleton].model.defaultAddressId;
	        if (![ProfileModel singleton].wasLogin) {  // 未登陆
	            [self presentLogin];
			}
	        else if (!defaultAddressId || [defaultAddressId isEqualToString:@"nil"]) {
	            [self addDefaultAddress];
			}
	        else {
	            [self addReportCenterWithAddressID:defaultAddressId];
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
	ReportStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.tag = indexPath.row;
	ReportStoreModel *model = self.products[indexPath.row];
	[cell updateWithModel:model];
	return cell;
}

#pragma mark - DOPDropMenu
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
	return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
	return self.kinds.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
	ReportCategoriesModel *model = self.kinds[indexPath.row];
	return model.cName;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
	ReportCategoriesModel *model = self.kinds[indexPath.row];
	self.category = model.cId;
	[self fetchWithPage:self.page];
}

#pragma mark - Custom action
- (void)fetchAllCategories {
	@weakify(self);
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel categories]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.kinds = [[NSMutableArray arrayWithArray:x] tap: ^(NSMutableArray *x) {
	        [x insertObject:[[[ReportCategoriesModel alloc] init] tap: ^(ReportCategoriesModel *x) {
	            x.cId = @"0";
	            x.cName = @"全部";
			}]  atIndex:0];
		}];
	    {
	        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
	        menu.dataSource = self;
	        menu.delegate = self;
	        [self.view addSubview:menu];
		}
	    [XPProgressHUD dismiss];

	    self.category = @"0";
	    [self.tableView headerBeginRefreshing];
	}];
}

- (void)fetchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel reportProductsWithID:[ProfileModel singleton].model.id categoryID:self.category page:self.page] subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.tableView headerEndRefreshing];
	    [self.tableView footerEndRefreshing];
	    if (0 == page) {
	        self.products = x;
	        [self.bottomView setHidden:NO];
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

- (void)reportProdouctWithAddressID:(NSString *)addressID {
	NSMutableArray *reports = [NSMutableArray array];
	for (NSInteger i = 0; i < self.products.count; i++) {
		ReportStoreTableViewCell *cell = (ReportStoreTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.number) {
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
	[[self.viewModel createReportWithID:[ProfileModel singleton].model.id addressID:self.orderAddressModel.id ? self.orderAddressModel.id : addressID type:@"1" reports:reports]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.navigationController popViewControllerAnimated:YES];
	    [XPToast showWithText:@"报单成功"];
	    [XPProgressHUD dismiss];
	}];
}

- (void)addReportCenterWithAddressID:(NSString *)addressID {
	NSMutableArray *reports = [NSMutableArray array];
	for (NSInteger i = 0; i < self.products.count; i++) {
		ReportStoreTableViewCell *cell = (ReportStoreTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.number) {
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
	[[self.viewModel addReportCartWithID:[ProfileModel singleton].model.id addressID:self.orderAddressModel.id ? self.orderAddressModel.id : addressID type:@"1" reports:reports]
	 subscribeNext: ^(id x) {
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
