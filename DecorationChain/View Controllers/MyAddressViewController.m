//
//  MyAddressViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyAddressViewController.h"
#import "AddressCellBottomView.h"

#import "MyAddressViewModel.h"
#import "ProfileModel.h"
#import "AddressModel.h"
#import "AddressTableViewCell.h"

#import <UIFolderTableView/UIFolderTableView.h>
#import <MJRefresh/MJRefresh.h>
#import <CSNNotificationObserver/CSNNotificationObserver.h>
#import "XPProgressHUD.h"

@interface MyAddressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIFolderTableView *addressTableView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@property (strong, nonatomic) IBOutlet MyAddressViewModel *viewModel;
@property (nonatomic, strong) CSNNotificationObserver *observer;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[self.addressTableView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self addressListWithPage:self.page];
	}];
	[self.addressTableView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self addressListWithPage:self.page];
	}];



	[[self.createButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self performSegueWithIdentifier:@"embed_edit" sender:nil];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.addressTableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.products.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 182;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	AddressModel *model = self.products[indexPath.section];
	[cell updateWithModel:model];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ([self.model.baseTransfer isEqualToString:@"joined_product_order"]) {
		[self.navigationController popViewControllerAnimated:YES];

		AddressModel *model = self.products[indexPath.section];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"selected_address" object:model];
		return;
	}

	@weakify(self);
	AddressCellBottomView *cellBottomView = [[[NSBundle mainBundle] loadNibNamed:@"AddressCellBottom" owner:self options:nil] lastObject];
	[[cellBottomView.setDefaultButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self setDefaultClicked:indexPath.section];
	}];
	[[cellBottomView.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self deleteClicked:indexPath.section];
	}];
	[[cellBottomView.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id x) {
	    @strongify(self);
	    [self editClicked:indexPath.section];
	}];
	AddressModel *model = self.products[indexPath.section];
	if ([model.isDefault boolValue]) {
		[cellBottomView.setDefaultButton setEnabled:NO];
		[cellBottomView.setDefaultButton setTitle:@"默认地址" forState:UIControlStateNormal];
		[cellBottomView.setDefaultButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	}
	else {
		[cellBottomView.setDefaultButton setEnabled:YES];
		[cellBottomView.setDefaultButton setTitle:@"设为默认" forState:UIControlStateNormal];
		[cellBottomView.setDefaultButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}

	self.addressTableView.scrollEnabled = NO;
	UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
	[folderTableView openFolderAtIndexPath:indexPath
	                       WithContentView:cellBottomView
	                             openBlock: ^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
	    // opening actions
	}
	                            closeBlock: ^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction) {
	    // closing actions
	}
	                       completionBlock: ^{
	    // completed actions
	    self.addressTableView.scrollEnabled = YES;
	}];
}

#pragma mark - 设为默认
- (void)setDefaultClicked:(NSInteger)index {
	[XPProgressHUD showWithStatus:@"加载中"];
	AddressModel *model = self.products[index];
	[[self.viewModel setDefaultAddressWithID:[ProfileModel singleton].model.id addressID:model.id]
	 subscribeNext: ^(id x) {
	    if (x) {
	        [XPToast showWithText:@"设置默认地址成功"];
		}
	    [XPProgressHUD dismiss];
	}];
	[self.addressTableView performClose:nil];
}

#pragma mark - 删除
- (void)deleteClicked:(NSInteger)index {
	[XPProgressHUD showWithStatus:@"加载中"];
	AddressModel *model = self.products[index];
	@weakify(self);
	[[self.viewModel deleteAddressWithID:[ProfileModel singleton].model.id addressID:model.id]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (x) {
	        [XPToast showWithText:@"删除收货地址成功"];
	        [self.addressTableView headerBeginRefreshing];
	        { // 检查是否删除了【默认地址】
	            AddressModel *model = self.products[index];
	            if ([model.isDefault boolValue]) {
	                [ProfileModel singleton].model.defaultAddressId = nil;
				}
			}
		}
	    [XPProgressHUD dismiss];
	}];
	[self.addressTableView performClose:nil];
}

#pragma mark - 编辑
- (void)editClicked:(NSInteger)index {
	AddressModel *model = self.products[index];
	[self performSegueWithIdentifier:@"embed_edit" sender:model];
	[self.addressTableView performClose:nil];
}

#pragma mark - list
- (void)addressListWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel addressListWithID:[ProfileModel singleton].model.id page:self.page]
	 subscribeNext: ^(id x) {
	    if (x) {
	        [self.addressTableView headerEndRefreshing];
	        [self.addressTableView footerEndRefreshing];
	        if (1 == page) {
	            self.products = x;
			}
	        else {
	            NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.products];
	            [buffer addObjectsFromArray:x];
	            self.products = buffer;
			}
	        [self.addressTableView reloadData];
		}
	    [XPProgressHUD dismiss];
	}];
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_edit"]) {
		if (sender) {
			BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
			[viewController setupWithModel:sender];
		}
	}
}

@end
