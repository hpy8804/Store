//
//  ProductCommentViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductCommentViewController.h"
#import "ProductCommentViewModel.h"
#import "ProductInfoRatingTableViewCell.h"

#import "ProductCommentModel.h"

#import <MJRefresh/MJRefresh.h>
#import <XPKit/UITableView+XPKit.h>
#import "XPProgressHUD.h"

@interface ProductCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet ProductCommentViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger filterIndex;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIButton *badButton;

@end

@implementation ProductCommentViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];

	@weakify(self);
	[self.tableView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self searchWithPage:self.page];
	}];
	[self.tableView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self searchWithPage:self.page];
	}];


	[[self.allButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id value) {
	    @strongify(self);
	    [self filterDataWithType:0];
	}];
	[[self.goodButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id value) {
	    @strongify(self);
	    [self filterDataWithType:1];
	}];
	[[self.middleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id value) {
	    @strongify(self);
	    [self filterDataWithType:2];
	}];
	[[self.badButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id value) {
	    @strongify(self);
	    [self filterDataWithType:3];
	}];

	self.filterIndex = 0;
	[self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - filter button
- (void)filterDataWithType:(NSInteger)type {
	self.filterIndex = type;
	[self.tableView reloadData];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.filterIndex == 0) {
		return self.products.count;
	}
	__block NSMutableArray *array = [NSMutableArray array];
	[self.products enumerateObjectsUsingBlock: ^(ProductCommentModel *obj, NSUInteger idx, BOOL *stop) {
	    if (obj.commentClass.integerValue == self.filterIndex) {
	        [array addObject:obj];
		}
	}];
	return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ProductInfoRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	ProductCommentModel *model = nil;
	if (self.filterIndex == 0) {
		model = self.products[indexPath.row];
	}
	else {
		__block NSMutableArray *array = [NSMutableArray array];
		[self.products enumerateObjectsUsingBlock: ^(ProductCommentModel *obj, NSUInteger idx, BOOL *stop) {
		    if (obj.commentClass.integerValue == self.filterIndex) {
		        [array addObject:obj];
			}
		}];
		model = array[indexPath.row];
	}

	cell.ratingBar.starNumber = model.score.integerValue;
	cell.contentLabel.text = model.content;
	cell.dateLabel.text = model.postTime;
	cell.nickLabel.text = model.accountName;
	return cell;
}

#pragma mark - request
- (void)searchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel productCommentListWithID:self.model.baseTransfer page:page]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.tableView headerEndRefreshing];
	    [self.tableView footerEndRefreshing];
	    if (1 == page) {
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
