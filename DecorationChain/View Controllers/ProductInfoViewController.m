//
//  ProductInfoViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductInfoHeadTableViewCell.h"
#import "ProductInfoNumberTableViewCell.h"
#import "ProductInfoSendTableViewCell.h"
#import "ProductInfoPromptTableViewCell.h"
#import "ProductInfoEvaluationTableViewCell.h"
#import "ProductInfoRatingTableViewCell.h"
#import "ProductInfoViewModel.h"
#import "ProductInfoModel.h"
#import "AdsItemModel.h"
#import "ProfileModel.h"

#import "NSString+imageurl.h"

#import <NSString-HTML/NSString+HTML.h>

#import "ProductCommentViewController.h"

#import <AFDynamicTableHelper/AFDynamicTableHelper.h>
#import <XPKit/UITableView+XPKit.h>
#import <MarkupLabel/UILabel+MarkupExtensions.h>
#import <MJRefresh/MJRefresh.h>
#import <UIView+MGBadgeView/UIView+MGBadgeView.h>
#import "XPToast.h"
#import "ProductInfoMoreTableViewCell.h"
#import "ProductOrderViewController.h"
#import "XPProgressHUD.h"
#import "ProductInfoAttributeTableViewCell.h"

@interface ProductInfoViewController () <UITableViewDelegate, UITableViewDataSource, AFDynamicTableHelperDelegate>

//@property (nonatomic, strong) AFDynamicTableHelper *tableHeadHelper;
//@property (nonatomic, strong) AFDynamicTableHelper *tableMoreHelper;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ProductInfoViewModel *viewModel;
@property (strong, nonatomic) ProductInfoModel *infoModel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *addCarButton;
@property (weak, nonatomic) IBOutlet UIButton *carButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;

@property (nonatomic, assign) BOOL watchMore; // 查看详情
@property (nonatomic, weak) UITableViewCell *moreTableViewCell;

@property (nonatomic, assign) NSInteger buyNumber;

@end

@implementation ProductInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	self.tableHeadHelper = [[AFDynamicTableHelper alloc] init];
//	self.tableHeadHelper.delegate = self;
//	self.tableHeadHelper.reusableCellIdentifier = @"Cell_head";
//	self.tableMoreHelper = [[AFDynamicTableHelper alloc] init];
//	self.tableMoreHelper.delegate = self;
//	self.tableMoreHelper.reusableCellIdentifier = @"Cell_more";

//	[self.tableView hideEmptySeparators];
	@weakify(self);
	[self.tableView addHeaderWithCallback: ^{
	    @strongify(self);
	    [self fetchProductInfo];
	}];
	[self.tableView headerBeginRefreshing];

	[[[[self.buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	}] flattenMap: ^RACStream *(id value) {
	    if (![ProfileModel singleton].wasLogin) {
	        [self presentLogin];
	        return [RACSignal empty];
		}
	    return [RACSignal return :value];
	}] subscribeNext: ^(id value) {
	    @strongify(self);
	    NSInteger productAttrCount = self.infoModel.product_attrs.count;
	    ProductOrderViewController *viewController = (ProductOrderViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductOrder"];
	    ProductInfoNumberTableViewCell *cell = (ProductInfoNumberTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1 + productAttrCount]];
	    ProductInfoModel *infoModel = [self.infoModel copy];
	    if (cell) {
	        infoModel.quantity = [NSString stringWithFormat:@"%ld", (long)cell.number];
		}
	    else {
	        infoModel.quantity = @"1";
		}


	    NSMutableArray *attribute = [NSMutableArray array];
	    {// 提取选择属性项
	        if (productAttrCount > 0) {
	            for (NSInteger i = 0; i < productAttrCount; i++) {
	                ProductInfoAttributeTableViewCell *cell = (ProductInfoAttributeTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i + 1]];
	                if (!cell.set || !cell.set.count) {
	                    [attribute removeAllObjects]; // 强制清理一次，保证第一行有选中，但是第二行有未选中的
	                    break;
					}
	                [attribute addObject:cell.set];
				}
			}
		}
	    if (productAttrCount && !attribute.count) {
	        [XPToast showWithText:@"请选择属性!"];
		}
	    else {
	        viewController.orderStyle = 1;
	        [viewController updateUIWithOrders:@[infoModel] andAttribute:attribute];
	        [self.navigationController pushViewController:viewController animated:YES];
		}
	}];

	[[[[[self.addCarButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	}] map: ^id (id value) {
	    @strongify(self);
	    if (![ProfileModel singleton].wasLogin) {
	        [self presentLogin];
	        return @(404);
		}
	    return [RACSignal return :value];
	}] ignore:@(404)] subscribeNext: ^(id value) {
	    @strongify(self);
	    [self addToCart];
	}];

	[[[[self.carButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	}] flattenMap: ^RACStream *(id value) {
	    if (![ProfileModel singleton].wasLogin) {
	        [self presentLogin];
	        return [RACSignal empty];
		}
	    return [RACSignal return :value];
	}] subscribeNext: ^(id value) {
	    @strongify(self);
	    UIViewController *viewController = [self instantiateViewControllerWithStoryboardName:@"Main" identifier:@"cart_list"];
	    [self.navigationController pushViewController:viewController animated:YES];
	}];

	[[[[[self.collectionButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    [XPProgressHUD showWithStatus:@"加载中"];
	}] map: ^id (id value) {
	    if (![ProfileModel singleton].wasLogin) {
	        [self presentLogin];
	        [XPProgressHUD dismiss];
	        return @(0);
		}
	    return value;
	}] ignore:@(0)] subscribeNext: ^(UIButton *x) {
	    @strongify(self);
	    if (!x.selected) {
	        [[self.viewModel addCollectionProductWithID:[ProfileModel singleton].model.id productID:self.model.identifier]
	         subscribeNext: ^(id x) {
	            @strongify(self);
	            if (x) {
	                [self.collectionButton setSelected:YES];
	                [XPToast showWithText:@"收藏商品成功"];
				}
	            [XPProgressHUD dismiss];
			}];
		}
	    else {
	        [[self.viewModel deleteCollectionProductWithID:[ProfileModel singleton].model.id productID:self.model.identifier]
	         subscribeNext: ^(id x) {
	            @strongify(self);
	            if (x) {
	                [self.collectionButton setSelected:NO];
	                [XPToast showWithText:@"取消收藏成功"];
				}
	            [XPProgressHUD dismiss];
			}];
		}
	}];

	self.watchMore = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self carListNumber];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
//	[self.tableHeadHelper invalidateAllCellHeights];
//	[self.tableMoreHelper invalidateAllCellHeights];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 4 + self.infoModel.productAttrs.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	NSInteger productAttrCount = self.infoModel.productAttrs.count;
//	if (section <= productAttrCount) {
//		return 1;
//	}
//	else if (section == (1 + productAttrCount)) {
//		return 2;
//	}
//	else if (section == (2 + productAttrCount)) {
//		return self.infoModel.productComments.count + 1;
//	}
//	else if (section == (3 + productAttrCount)) {
//		return 1;
//	}
//	return 0;
    
    return self.infoModel.product_items.count + 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	if (section == 0) {
//		return 0;
//	}
//	return 15;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	NSInteger productAttrCount = self.infoModel.productAttrs.count;
//	if (indexPath.section == 0) {
//		return [self.tableHeadHelper tableView:tableView cellForRowAtIndexPath:indexPath];
//	}
//	else if (indexPath.section <= productAttrCount) {
//		ProductInfoAttributeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_attr" forIndexPath:indexPath];
//		[cell configWithModel:self.infoModel.productAttrs[indexPath.section - 1]];
//		return cell;
//	}
//	else if (indexPath.section == (1 + productAttrCount)) {
//		if (indexPath.row == 0) {
//			ProductInfoNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%d_%d", 1, 0] forIndexPath:indexPath];
//			return cell;
//		}
//		else if (indexPath.row == 1) {
//			ProductInfoSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%d_%d", 1, 1] forIndexPath:indexPath];
//			return cell;
//		}
//		else if (indexPath.row == 2) {
//			ProductInfoPromptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%d_%d", 1, 2] forIndexPath:indexPath];
//			return cell;
//		}
//	}
//	else if (indexPath.section == (2 + productAttrCount)) {
//		if (indexPath.row == 0) {
//			ProductInfoEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%d_%d", 2, 0] forIndexPath:indexPath];
//			cell.evaluationLabel.text = [NSString stringWithFormat:@"评价晒单(%ld人评价)", (long)self.infoModel.totalComments];
//			cell.evaluationPercentLabel.text = [NSString stringWithFormat:@"%ld%%", (long)self.infoModel.goodCommentNums];
//			return cell;
//		}
//		else {
//			ProductInfoRatingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%d_%d", 2, 1] forIndexPath:indexPath];
//			[cell updateWithModel:self.infoModel.productComments[indexPath.row - 1]];
//			return cell;
//		}
//	}
//	else if (indexPath.section == (3 + productAttrCount)) {
//		ProductInfoMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_more" forIndexPath:indexPath];
//		if (self.watchMore) {
//			[cell expandUI];
//		}
//		else {
//			[cell updateUIWithContent:self.infoModel.self_description];
//		}
//		self.moreTableViewCell = cell;
//		return cell;
//	}
    
    if (indexPath.row == 0) {
        ProductInfoHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_head"];
        [cell updateUIWithModel:self.infoModel];
        return cell;
    }else{
        ProductInfoNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1_0"];
        [cell updateUIWithModel:self.infoModel.product_items[indexPath.row-1]];
        return cell;
    }
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	NSInteger productAttrCount = self.infoModel.productAttrs.count;
//	if (indexPath.section == 0) {
//		return [self.tableHeadHelper tableView:tableView heightForRowAtIndexPath:indexPath];
//	}
//	else if (indexPath.section <= productAttrCount) {
//		return 51;
//	}
//	else if (indexPath.section == (1 + productAttrCount)) {
//		return 30;
//	}
//	else if (indexPath.section == (2 + productAttrCount)) {
//		if (indexPath.row == 0) {
//			return 50;
//		}
//		return 76;
//	}
//	else if (indexPath.section == (3 + productAttrCount)) {
//		if (!self.watchMore) {
//			return 40;
//		}
//		return [(ProductInfoMoreTableViewCell *)self.moreTableViewCell height];
//	}
    if (indexPath.row == 0) {
        return 210;
    }else{
        return 106;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSInteger productAttrCount = self.infoModel.product_attrs.count;
	if (indexPath.section == (3 + productAttrCount)) {
		self.watchMore = YES;
		[self.tableView reloadData];
	}
}

#pragma mark - AFDynamicTableHelper delegate
- (void)dynamicTableHelper:(AFDynamicTableHelper *)tableHelper prepareCell:(UITableViewCell *)_cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView offscreen:(BOOL)offscreen {
//	if (tableHelper == self.tableHeadHelper) {
////		ProductInfoHeadTableViewCell *cell = (ProductInfoHeadTableViewCell *)_cell;
////		cell.titleLabel.text = self.infoModel.name;
////		[cell.descriptionLabel setMarkup:self.infoModel.excerpt];
//
//		NSMutableArray *array = [NSMutableArray array];
//		[self.infoModel.product_pictures enumerateObjectsUsingBlock: ^(ProductInfoPictureModel *obj, NSUInteger idx, BOOL *stop) {
//		    AdsItemModel *adModel = [AdsItemModel new];
//		    adModel.id = obj.id;
//		    adModel.logo = obj.url;
//		    adModel.name = obj.name;
//		    [array addObject:adModel];
//		}];
//		[cell.adView uploadUI:array];
//
//		cell.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.infoModel.saleprice ? self.infoModel.saleprice : @"0"];
//	}
//	else if (tableHelper == self.tableMoreHelper) {
//		ProductInfoMoreTableViewCell *cell = (ProductInfoMoreTableViewCell *)_cell;
//		if (self.watchMore) {
//			[cell updateUIWithContent:self.infoModel.self_description];
//		}
//		else {
//			[cell.infoLabel setText:@"点击查看详情"];
//		}
//	}
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_comment"]) {
		ProductCommentViewController *viewController = segue.destinationViewController;
		viewController.model = [BaseObject new];
		viewController.model.baseTransfer = self.model.identifier;
	}
}

#pragma mark - request
- (void)fetchProductInfo {
	@weakify(self);
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel productDetailWithID:[ProfileModel singleton].model.id productID:self.model.identifier]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.infoModel = x;
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	    [self.tableView headerEndRefreshing];
	}];
    
}

- (void)addToCart {
    NSInteger productAttrCount = self.infoModel.product_items.count;

	NSMutableArray *attribute = [NSMutableArray array];

	{// 提取选择属性项
		if (productAttrCount > 0) {
			for (NSInteger i = 0; i < productAttrCount; i++) {
				ProductInfoNumberTableViewCell *cell = (ProductInfoNumberTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 + i inSection:0]];
//				if (!cell.set || !cell.set.count) {
//					continue;
//				}
//				[attribute addObject:cell.set];
                if (cell.number != 0) {
                    NSDictionary *dicInfo = [NSDictionary dictionaryWithObjectsAndKeys:cell.strId, @"id", [NSNumber numberWithInteger:cell.number], @"quantity" ,nil];
                    [attribute addObject:dicInfo];
                }
                
			}
		}
	}

	if (productAttrCount && !attribute.count) {
		[XPToast showWithText:@"提交不成功，所选的货号不能全为0"];
		return;
	}

	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	ProductInfoNumberTableViewCell *cell = (ProductInfoNumberTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 + productAttrCount inSection:0]];
	[[self.viewModel addProductToCartWithID:[ProfileModel singleton].model.id productID:self.model.identifier quantity:cell.number attribute:attribute]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if ([x integerValue]) {
	        [XPToast showWithText:@"加入购物车成功"];
	        [self carListNumber];
		}
	    [XPProgressHUD dismiss];
	}];
}

- (void)carListNumber {
	@weakify(self);
	if ([ProfileModel singleton].wasLogin) {
		[[self.viewModel cartDataNumberWithID:[ProfileModel singleton].model.id]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    [self.carButton.badgeView setBadgeValue:[x integerValue]];
		    [self.carButton.badgeView setPosition:MGBadgePositionTopRight];
		    [self.carButton.badgeView setBadgeColor:[UIColor redColor]];
		    [self.carButton.badgeView setOutlineColor:[UIColor redColor]];
		    [self.carButton.badgeView setUserInteractionEnabled:NO];
		}];
	}
}

@end
