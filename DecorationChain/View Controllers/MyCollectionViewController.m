//
//  MyCollectionViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "ProfileModel.h"
#import "MyCollectionViewModel.h"
#import "CollectionModel.h"

#import "NSString+imageurl.h"

#import <MJRefresh/MJRefresh.h>
#import "ProductItemCollectionViewCell.h"
#import "XPProgressHUD.h"

@interface MyCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic) IBOutlet MyCollectionViewModel *viewModel;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(UIButton *x) {
	    x.selected = !x.selected;
	    [UIView animateWithDuration:0.3 animations: ^{
	        @strongify(self);
	        self.bottomView.top = self.bottomView.top == 516 ? 568 : 516;
		} completion: ^(BOOL finished) {
	        @strongify(self);
	        self.collectionView.allowsMultipleSelection = self.editButton.selected;
	        [self.collectionView reloadData];
	        if (x.selected) {
	            [self.collectionView removeHeader];
	            [self.collectionView removeFooter];
			}
	        else {
	            [self.collectionView addHeaderWithCallback: ^{
	                @strongify(self);
	                self.page = 1;
	                [self collectionWithPage:self.page];
				}];
	            [self.collectionView addFooterWithCallback: ^{
	                @strongify(self);
	                self.page += 1;
	                [self collectionWithPage:self.page];
				}];
			}
		}];
	}];

	[[self.allSelectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(UIButton *x) {
	    x.selected = !x.selected;
	    @strongify(self);
	    for (NSInteger i = 0; i < self.products.count; i++) {
	        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
	        if (x.selected) {
	            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
			}
	        else {
	            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
			}
		}
	}];
	[[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self deleteCollection];
	}];

	[self.collectionView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 0;
	    [self collectionWithPage:self.page];
	}];
	[self.collectionView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self collectionWithPage:self.page];
	}];

	[self.collectionView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ProductItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
	CollectionModel *model = self.products[indexPath.row];
	ProductItemModel *itemModel = [[ProductItemModel alloc] init];
	itemModel.images = model.detail.images;
	itemModel.name = model.detail.name;
	itemModel.saleprice = model.detail.saleprice;
	itemModel.weight = model.detail.weight;
	itemModel.id = model.detail.id;
	itemModel.quantity = model.detail.quantity;
	[cell setItemModel:itemModel];

	@weakify(self);
	cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:ccr(0, 0, cell.width, cell.height)] tap: ^(UIView *x) {
	    @strongify(self);
	    x.backgroundColor = self.editButton.selected ? [UIColor lightGrayColor] : [UIColor clearColor];
	}];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.editButton.selected) {
		CollectionModel *model = self.products[indexPath.row];
		BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
		viewController.model = [BaseObject new];
		viewController.model.identifier = model.productId;
		[self.navigationController pushViewController:viewController animated:YES];
	}
}

#pragma mark - request
- (void)collectionWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel collectionList:[ProfileModel singleton].model.id page:page]
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
	    if (self.products.count) {
	        [self.editButton setEnabled:YES];
        } else {
            [self.editButton setEnabled:NO];
        }
	}];
}

#pragma mark - delete
- (void)deleteCollection {
	[XPProgressHUD showWithStatus:@"加载中"];
	__block NSString *ids = @"";
	NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
	[indexPaths each: ^(NSIndexPath *item) {
	    CollectionModel *model = self.products[item.row];
	    ids = [NSString stringWithFormat:@"%@,%@", ids, model.id];
	}];
	ids = [ids substringFromIndex:1];

	@weakify(self);
	[[self.viewModel deleteCollection:[ProfileModel singleton].model.id ids:ids]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (x) {
	        [XPToast showWithText:@"删除收藏成功"];
	        self.page = 1;
	        [self collectionWithPage:self.page];
		}
	    [XPProgressHUD dismiss];
	}];
}

@end
