//
//  BaseTableViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/2/2.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseTableViewController.h"
#import <Masonry/Masonry.h>

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource =  self;
	[self.view addSubview:self.tableView];

	[self.tableView mas_remakeConstraints: ^(MASConstraintMaker *make) {
	    make.top.equalTo(self.view.mas_top).with.offset(0);
	    make.left.equalTo(self.view.mas_left).with.offset(0);
	    make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
	    make.right.equalTo(self.view.mas_right).with.offset(0);
	}];
	self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Dynamic TableHekoer
- (AFDynamicTableHelper *)tableHelper {
	if (!_tableHelper) {
		_tableHelper = [[AFDynamicTableHelper alloc] init];
		_tableHelper.delegate = self;
	}
	return _tableHelper;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	[_tableHelper invalidateAllCellHeights];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.tableHelper tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [self.tableHelper tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
