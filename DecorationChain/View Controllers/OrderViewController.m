//
//  OrderViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderViewModel.h"
#import "ProfileModel.h"

#import "CartTableViewCell.h"

#import <MJRefresh/MJRefresh.h>
#import "CartEditTableViewCell.h"
#import "XPProgressHUD.h"
#import "ProductInfoModel.h"
#import "ProductOrderViewController.h"

@interface OrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *orderTabelView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldAllPriceLabel;
@property (strong, nonatomic) IBOutlet OrderViewModel *viewModel;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableSet *selectedSet;

@property (nonatomic, strong) NSNumber *vipDiscount; // vip折扣

@end

@implementation OrderViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.orderTabelView hideEmptySeparators];
	self.selectedSet = [NSMutableSet set];

	@weakify(self);
	[[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(UIButton *x) {
	    @strongify(self);
	    x.selected = !x.selected;
	    if (x.selected) {
	        self.finishButton.hidden = NO;
	        self.payButton.hidden = YES;
	        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
		}
	    else {
	        self.finishButton.hidden = YES;
	        self.payButton.hidden = NO;
	        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
		}
	    [self.orderTabelView reloadData];
	}];

	[[[[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] map: ^id (id value) {
	    if (self.selectedSet.count == 0) {
	        [XPToast showWithText:@"未选择任何列表"];
	        return @(0);
		}
	    return value;
	}] ignore:@(0)] subscribeNext: ^(id x) {
	    @strongify(self);
	    __block NSMutableArray *orderList = [NSMutableArray array];
	    [self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
	        @strongify(self);
	        OrderModel *model = self.products[obj.integerValue];
	        ProductInfoModel *infoModel = [[ProductInfoModel alloc] init];
	        infoModel.id = model.productId;
	        infoModel.quantity = model.quantity;
	        infoModel.saleprice = model.detail.saleprice;
	        infoModel.images = model.detail.images;
	        infoModel.name = model.detail.name;
	        [orderList addObject:infoModel];
		}];
	    ProductOrderViewController *viewController = (ProductOrderViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductOrder"];
	    //TODO: 未考虑购物车的属性，应该是对方没有考虑到这个点
	    viewController.orderStyle = 2;
	    [viewController updateUIWithOrders:orderList andAttribute:[NSArray array]];
	    [self.navigationController pushViewController:viewController animated:YES];
	}];

	[[self.finishButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	}];

	[[self.allSelectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(UIButton *x) {
	    @strongify(self);
	    x.selected = !x.selected;
	    if (x.selected) {
	        for (NSInteger i = 0; i < self.products.count; i++) {
	            [self.selectedSet addObject:@(i)];
			}
	        [self updateUIWithSelected];
	        [self.orderTabelView reloadData];
		}
	    else {
	        [self.selectedSet removeAllObjects];
	        [self updateUIWithSelected];
	        [self.orderTabelView reloadData];
		}
	}];

	[self.orderTabelView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self.selectedSet removeAllObjects];
	    [self cartListWithPage:self.page];
	}];
	[self.orderTabelView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self cartListWithPage:self.page];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	@weakify(self);
	[[self.viewModel vipDiscountWithID:[ProfileModel singleton].model.id]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.vipDiscount = x;
	    [self.orderTabelView headerBeginRefreshing];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = @"Cell_edit";
	CartEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
	OrderModel *model = self.products[indexPath.row];
	[cell updateWithModel:model];
	cell.selectedButton.tag = indexPath.row;
	@weakify(self);
	[[cell.selectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(UIButton *x) {
	    @strongify(self);
	    if (x.selected) {
	        [self.selectedSet addObject:@(x.tag)];
		}
	    else {
	        [self.selectedSet removeObject:@(x.tag)];
		}
	    [self updateUIWithSelected];
	}];
	[RACObserve(cell, number)
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self updateUIWithSelected];
	}];

	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	CartEditTableViewCell *_cell = (CartEditTableViewCell *)cell;
	[_cell.selectedButton setSelected:NO];
	[self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
	    if (indexPath.row == obj.integerValue) {
	        [_cell.selectedButton setSelected:YES];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	OrderModel *model = self.products[indexPath.row];
	BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
	viewController.model = [BaseObject new];
	viewController.model.identifier = model.productId;
	[self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		OrderModel *model = self.products[indexPath.row];
		[self deleteCartList:model];
	}
}

#pragma mark - request
- (void)cartListWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel cartListWithID:[ProfileModel singleton].model.id page:page]
	 subscribeNext: ^(id x) {
	    if (x) {
	        if (1 == page) {
	            self.products = x;
			}
	        else {
	            NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.products];
	            [buffer addObjectsFromArray:x];
	            self.products = buffer;
			}
		}
	    else {
	        if (1 == page) {
	            self.products = nil;
			}
		}
	    [self.orderTabelView headerEndRefreshing];
	    [self.orderTabelView footerEndRefreshing];
	    [self.orderTabelView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

#pragma mark - update
- (void)updateUIWithSelected {
	[self.payButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (unsigned long)self.selectedSet.count] forState:UIControlStateNormal];
	[self.finishButton setTitle:[NSString stringWithFormat:@"删除(%ld)", (unsigned long)self.selectedSet.count] forState:UIControlStateNormal];
	__block CGFloat price = 0;
	@weakify(self);
	[self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
	    @strongify(self);
	    OrderModel *model = self.products[obj.integerValue];
	    CGFloat singlePrice = model.detail.saleprice.floatValue;
	    price += (singlePrice * model.quantity.integerValue);
	}];
	self.allPriceLabel.text = [NSString stringWithFormat:@"总计：￥%.2f", price *[self.vipDiscount floatValue]];
	self.oldAllPriceLabel.text = [NSString stringWithFormat:@"商品原价：￥%.2f", price];
	if (self.selectedSet.count != self.products.count) {
		[self.allSelectButton setSelected:NO];
	}
	else {
		[self.allSelectButton setSelected:YES];
	}
}

- (void)deleteCartList:(OrderModel *)model {
	@weakify(self);
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel deledateCartListWithID:[ProfileModel singleton].model.id productID:model.id]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [XPToast showWithText:@"删除成功"];
	    [XPProgressHUD dismiss];
	    [self.orderTabelView headerBeginRefreshing];
	}];
}

@end
