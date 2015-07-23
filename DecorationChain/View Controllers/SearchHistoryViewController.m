//
//  SearchHistoryViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "SearchHistoryViewController.h"

@interface SearchHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *historyList;
@property (weak, nonatomic) IBOutlet UIView *clearView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation SearchHistoryViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[[self.clearButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [NSFileManager deleteFile:@"history" fromDirectory:DirectoryTypeDocuments];
	    [self loadFromLocal];
	}];

	[self loadFromLocal];
}

- (void)loadFromLocal {
	self.historyList = [NSArray arrayWithContentsOfFile:[[NSFileManager documentsDirectory] stringByAppendingPathComponent:@"history"]];
	if (!self.historyList || !self.historyList.count) {
		self.clearView.hidden = YES;
		self.tableView.hidden = YES;
	}

	[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self loadFromLocal];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	cell.textLabel.text = self.historyList[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - prepare
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"embed_result"]) {
        UITableViewCell *cell = [self.tableView selectedCell];
        NSString *key = cell.textLabel.text;
        BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
        BaseObject *bo = [BaseObject new];
        bo.baseTransfer = key;
        viewController.model = bo;
    }
}

@end
