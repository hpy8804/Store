//
//  SearchResultViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchViewModel.h"
#import "ProductItemCollectionViewCell.h"

#import <MJRefresh/MJRefresh.h>
#import "XPProgressHUD.h"

@interface SearchResultViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet SearchViewModel *viewModel;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationController.navigationBar.hidden = NO;

	self.title = [NSString stringWithFormat:@"搜索-%@", self.model.baseTransfer];

	@weakify(self);
	[self.collectionView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self searchWithPage:self.page];
	}];
	[self.collectionView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self searchWithPage:self.page];
	}];

	[self.collectionView headerBeginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - collectinview
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
- (void)searchWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel searchWithKey:self.model.baseTransfer page:page]
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
