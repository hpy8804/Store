//
//  KindViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/2/2.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "KindViewController.h"

#import "KindNavigationTitleView.h"
#import "KindViewModel.h"
#import "kindModel.h"
#import "KindSubModel.h"

#import "KindSubView.h"
#import "XPADView.h"

#import <XPKit/XPKit.h>
#import "XPProgressHUD.h"

@interface KindViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) KindNavigationTitleView *titleView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet XPADView *adView;

@property (nonatomic, strong) NSArray *kinds;
@property (strong, nonatomic) IBOutlet KindViewModel *viewModel;

@end

@implementation KindViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	{ // 导航栏右边按钮
		UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[searchButton setFrame:ccr(0, 0, 25, 25)];
		[searchButton setBackgroundImage:[UIImage imageNamed:@"search_button"] forState:UIControlStateNormal];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];

		@weakify(self);
		[[searchButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Search"];
		    [self presentViewController:viewController animated:YES completion:nil];
		}];
	}

	if (self.navigationItem) {
		self.titleView =  [[[NSBundle mainBundle] loadNibNamed:@"KindNavigationTitleView" owner:self options:nil] lastObject];
		self.navigationItem.titleView = self.titleView;
		@weakify(self);
		[[self.titleView.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    [UIView animateWithDuration:0.3 animations: ^{
		        self.contentView.left = (self.contentView.left == -90) ? 0 : -90;
			}];
		}];
	}

	[self.tableView hideEmptySeparators];

	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel kinds] subscribeNext: ^(id x) {
	    @strongify(self);
	    self.kinds = x;
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	    [self performBlock: ^{
	        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
	        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		} afterDelay:0.3 onMainThread:YES];
	}];

	[[self.viewModel ads]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.adView uploadUI:x];
	}];



	self.contentView.frame = ccr(-90, 0, self.contentView.width, self.view.height);
	self.contentScrollView.frame = ccr(90, 0, self.contentScrollView.width, self.view.height);
	self.tableView.frame = ccr(0, 0, self.tableView.width, self.view.height);
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	self.contentScrollView.frame = ccr(90, 0, self.contentScrollView.width, self.view.height);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.kinds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	kindModel *model = self.kinds[indexPath.row];
	cell.textLabel.text = model.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	for (NSInteger i = 0; i < self.kinds.count; i++) {
		NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:_indexPath];
		if (_indexPath.row == indexPath.row) {
			cell.textLabel.textColor = [UIColor colorWithRGBA:@"228,27,58,255"];
		}
		else {
			cell.textLabel.textColor = [UIColor blackColor];
		}
	}

	kindModel *model = self.kinds[indexPath.row];
	self.titleView.titleLabel.text = model.name;
	[UIView animateWithDuration:0.3 animations: ^{
	    self.contentView.left = (self.contentView.left == -90) ? 0 : -90;
	}];

	// 清除掉原来的视图
	[self.contentScrollView.subviews each: ^(UIView *item) {
	    if (item.tag >= 1000) {
	        [item removeFromSuperview];
		}
	}];
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel detailKindWithID:model.id]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (x) {
	        [self updateKindSub:x];
		}
	    [XPProgressHUD dismiss];
	}];
}

#pragma mark - 右滑
- (IBAction)swipRightAction:(id)sender {
	[self.titleView.selectButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)swipLeftAction:(id)sender {
	[self.titleView.selectButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - kindSub
- (void)updateKindSub:(NSArray *)subs {
	CGFloat offset = 160;
	CGFloat offsetHeight = 0;
	for (NSInteger i = 0; i < subs.count; i++) {
		KindSubModel *model = subs[i];
		KindSubView *kindSubView = [[[NSBundle mainBundle] loadNibNamed:@"Kind_sub" owner:self options:nil] objectAtIndex:0];
		kindSubView.frame = ccr(0, offset + offsetHeight, 320, 0);
		CGSize size = [kindSubView updateWithModel:model];
		kindSubView.height = size.height;
		offsetHeight += size.height + 10;
		kindSubView.tag = 1000 + i;
		[self.contentScrollView addSubview:kindSubView];
	}
	[self.contentScrollView setContentSize:ccs(320, offset + offsetHeight)];
	self.contentScrollView.height = self.view.height;
	self.tableView.height = self.view.height;
	[self.contentScrollView scrollToTop];
	NSLog(@"%@", NSStringFromCGRect(self.contentScrollView.frame));
}

@end
