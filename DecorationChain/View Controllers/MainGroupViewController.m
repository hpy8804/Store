//
//  MainGroupViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MainGroupViewController.h"
#import "MainGroupViewModel.h"
#import "ProductItemCollectionViewCell.h"

#import <MJRefresh/MJRefresh.h>

#import <DOPDropDownMenu/DOPDropDownMenu.h>
#import "XPProgressHUD.h"

@interface MainGroupViewController () <UICollectionViewDelegate, UICollectionViewDataSource, DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (strong, nonatomic) IBOutlet MainGroupViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSArray *saleSort;
@property (nonatomic, strong) NSArray *priceSort;
@property (nonatomic, strong) NSArray *oldSort;

/**
 *  请求参数
 */
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *saleNum;
@property (nonatomic, strong) NSString *smallPrice;
@property (nonatomic, strong) NSString *bigPrice;

@end

@implementation MainGroupViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.saleSort = @[@"全部销量", @"销量靠后", @"销量靠前"];
	self.priceSort = @[@"全部价格", @"100以内", @"100-200", @"200-400", @"400-800", @"800-1000", @"1000以上"];
	self.oldSort = @[@"全部分类", @"新品", @"旧货"];
	self.saleNum = nil;
	self.smallPrice = nil;
	self.bigPrice = nil;
	self.createTime = nil;
	DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
	menu.dataSource = self;
	menu.delegate = self;
	[self.view addSubview:menu];


	NSInteger type = self.model.baseTransfer.integerValue;
	switch (type) {
		case 0:
			self.title = @"今日特价";
			break;

		case 1:
			self.title = @"团购专区";
			break;

		case 2:
			self.title = @"热卖商品";
			break;

		case 3:
			self.title = @"精品推荐";
			break;

		case 4:
			self.title = @"天天免单";
			break;

		default:
			break;
	}

	@weakify(self);
	[self.collectionView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self fetchWithPage:self.page];
	}];
	[self.collectionView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self fetchWithPage:self.page];
	}];
	[self.collectionView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - DOPDropMenu
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
	return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
	switch (column) {
		case 0: return self.saleSort.count;
			break;

		case 1: return self.priceSort.count;
			break;

		case 2: return self.oldSort.count;
			break;

		default:
			return 0;
			break;
	}
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
	switch (indexPath.column) {
		case 0: return self.saleSort[indexPath.row];
			break;

		case 1: return self.priceSort[indexPath.row];
			break;

		case 2: return self.oldSort[indexPath.row];
			break;

		default:
			return nil;
			break;
	}
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
	NSString *title = [menu titleForRowAtIndexPath:indexPath];
	switch (indexPath.column) {
		case 0: // 销量
		{
			switch (indexPath.row) {
				case 0:
					self.saleNum = nil;
					break;

				case 1:
					self.saleNum = @"asc";
					break;

				case 2:
					self.saleNum = @"desc";
					break;

				default:
					break;
			}
			break;
		}

		case 1:// 价格区间
		{
			switch (indexPath.row) {
				case 0:
					self.smallPrice = nil;
					self.bigPrice = nil;
					break;

				case 1:
					self.smallPrice = @"0";
					self.bigPrice = @"100";
					break;

				case 2:
					self.smallPrice = @"100";
					self.bigPrice = @"200";
					break;

				case 3:
					self.smallPrice = @"200";
					self.bigPrice = @"400";
					break;

				case 4:
					self.smallPrice = @"400";
					self.bigPrice = @"800";
					break;

				case 5:
					self.smallPrice = @"800";
					self.bigPrice = @"1000";
					break;

				default:
					break;
			}
			break;
		}

		case 2:// 新品或旧品排序
		{
			switch (indexPath.row) {
				case 0:
					self.createTime = nil;

					break;

				case 1:
					self.createTime = @"desc";

					break;

				case 2:
					self.createTime = @"asc";
					break;

				default:
					break;
			}
			break;
		}

		default:
			break;
	}
	NSLog(@"%@", title);
	[self fetchWithPage:self.page];
}

#pragma mark - collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ProductItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
	ProductItemModel *model = self.products[indexPath.row];
	[cell setItemModel:model];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	ProductItemModel *itemModel = self.products[indexPath.row];
	BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
	viewController.model = [BaseObject new];
	viewController.model.identifier = itemModel.id;
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - request
- (void)fetchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel fetchDataWithType:self.model.baseTransfer.integerValue page:self.page saleSort:self.saleNum priceSmall:self.smallPrice priceBig:self.bigPrice createSort:self.createTime]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.collectionView headerEndRefreshing];
	    [self.collectionView footerEndRefreshing];
	    if (1 == page) {
	        self.products = x;
		}
	    else {
	        NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.products];
	        [buffer addObjectsFromArray:x];
	        self.products = buffer;
		}
	    [self.collectionView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

@end
