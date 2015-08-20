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
#import "ProductProfileTableViewCell.h"

@interface MyCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectedButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *mutArrProducts;
@property (nonatomic, assign) NSInteger page;
@property (strong, nonatomic) IBOutlet MyCollectionViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
    [self.editButton addTarget:self action:@selector(handleEditAction:) forControlEvents:UIControlEventTouchUpInside];
//	[[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//	 subscribeNext: ^(UIButton *x) {
//	    x.selected = !x.selected;
//	    [UIView animateWithDuration:0.3 animations: ^{
//	        @strongify(self);
//	        self.bottomView.top = self.bottomView.top == 516 ? 568 : 516;
//		} completion: ^(BOOL finished) {
//	        @strongify(self);
//	        self.collectionView.allowsMultipleSelection = self.editButton.selected;
//	        [self.collectionView reloadData];
//	        if (x.selected) {
//	            [self.collectionView removeHeader];
//	            [self.collectionView removeFooter];
//			}
//	        else {
//	            [self.collectionView addHeaderWithCallback: ^{
//	                @strongify(self);
//	                self.page = 1;
//	                [self collectionWithPage:self.page];
//				}];
//	            [self.collectionView addFooterWithCallback: ^{
//	                @strongify(self);
//	                self.page += 1;
//	                [self collectionWithPage:self.page];
//				}];
//			}
//		}];
//	}];

//	[[self.allSelectedButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//	 subscribeNext: ^(UIButton *x) {
//	    x.selected = !x.selected;
//	    @strongify(self);
//	    for (NSInteger i = 0; i < self.products.count; i++) {
//	        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//	        if (x.selected) {
//	            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//			}
//	        else {
//	            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
//			}
//		}
//	}];
//	[[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//	 subscribeNext: ^(id x) {
//	    @strongify(self);
//	    [self deleteCollection];
//	}];

	[self.tableView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self collectionWithPage:self.page];
	}];
	[self.tableView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self collectionWithPage:self.page];
	}];

	[self.tableView headerBeginRefreshing];
}

- (void)handleEditAction:(UIButton *)btn
{
    if ([self.editButton.titleLabel.text isEqualToString:@"编辑"]) {
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
    }else{
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutArrProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"rowIndexProduct";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"ProductProfileTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    ProductProfileTableViewCell *cell = (ProductProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.mutArrProducts.count > 0) {
        cell.productModel = self.mutArrProducts[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel2 *model = self.mutArrProducts[indexPath.row];
    [self deleteCollectionWithProId:model.collectionId];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
    viewController.model = [BaseObject new];
    
    ProductModel *model = self.mutArrProducts[indexPath.row];
    viewController.model.identifier = model.proId;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
#pragma mark - request
- (void)collectionWithPage:(NSInteger)page {
	[XPProgressHUD showWithStatus:@"加载中"];
    
    if (page == 1) {
        self.mutArrProducts = [NSMutableArray array];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/collection_list" parameters:@{@"account_id":[ProfileModel singleton].model.id,
                                                                               @"page":@(page) } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
//    CollectionModel *model = [[CollectionModel alloc] initWithDictionary:responseObject error:nil];
        
        id data = responseObject[@"data"];
       if ([data isKindOfClass:[NSArray class]]) {
           NSArray *carsList = (NSArray *)data;
           for (int i = 0; i < carsList.count; i++) {
               ProductModel2 *model = [[ProductModel2 alloc] init];
               model.proId = carsList[i][@"detail"][@"id"];
               model.en_name = carsList[i][@"detail"][@"en_name"];
               model.cas = carsList[i][@"detail"][@"cas"];
               model.formula = carsList[i][@"detail"][@"formula"];
               model.name = carsList[i][@"detail"][@"name"];
               model.collectionId = carsList[i][@"id"];
               [self.mutArrProducts addObject:model];
           }
       }
       
        
        [XPProgressHUD dismiss];
        [self.tableView footerEndRefreshing];
       [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [XPProgressHUD dismiss];
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
//	@weakify(self);
//	[[self.viewModel collectionList:[ProfileModel singleton].model.id page:page]
//	 subscribeNext: ^(id x) {
//	    @strongify(self);
//	    [self.collectionView headerEndRefreshing];
//	    [self.collectionView footerEndRefreshing];
//	    if (1 == page) {
//	        self.products = x;
//		}
//	    else {
//	        NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.products];
//	        [buffer addObjectsFromArray:x];
//	        self.products = buffer;
//		}
//	    [self.collectionView reloadData];
//	    [XPProgressHUD dismiss];
//	    if (self.products.count) {
//	        [self.editButton setEnabled:YES];
//        } else {
//            [self.editButton setEnabled:NO];
//        }
//	}];
}

#pragma mark - delete
- (void)deleteCollectionWithProId:(NSString *)strId; {
	[XPProgressHUD showWithStatus:@"加载中"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/delete_collection" parameters:@{@"account_id":[ProfileModel singleton].model.id,@"id":strId } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                   
           // 3
           //[self.view setAnimatingWithStateOfOperation:operation];
           //    CollectionModel *model = [[CollectionModel alloc] initWithDictionary:responseObject error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [XPToast showWithText:@"删除收藏成功"];
            [XPProgressHUD dismiss];
            NSLog(@"msg:%@", responseObject[@"msg"]);
            self.page = 1;
            [self collectionWithPage:self.page];
        });
           
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
           [XPProgressHUD dismiss];
           // 4
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:[error localizedDescription]
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
           [alertView show];
       }];

//	@weakify(self);
//	[[self.viewModel deleteCollection:[ProfileModel singleton].model.id ids:strId]
//	 subscribeNext: ^(id x) {
//	    @strongify(self);
//	    if (x) {
//	        [XPToast showWithText:@"删除收藏成功"];
//	        self.page = 1;
//	        [self collectionWithPage:self.page];
//		}
//	    [XPProgressHUD dismiss];
//	}];
}

@end
