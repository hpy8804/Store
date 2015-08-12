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
#import "GoodsCarTableViewCell.h"
#import "Model.h"
#import "ProductInfoModelSV.h"


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

@property (nonatomic, strong) NSMutableArray *selectedSet;

@property (nonatomic, strong) NSNumber *vipDiscount; // vip折扣

@property (nonatomic, strong) NSMutableArray *mutCarList;


@end

@implementation OrderViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.orderTabelView hideEmptySeparators];
	self.selectedSet = [NSMutableArray array];

	@weakify(self);
//	[[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//	 subscribeNext: ^(UIButton *x) {
//	    @strongify(self);
//	    x.selected = !x.selected;
//	    if (x.selected) {
//	        self.finishButton.hidden = NO;
//	        self.payButton.hidden = YES;
//	        [self.editButton setTitle:@"取消" forState:UIControlStateNormal];
//		}
//	    else {
//	        self.finishButton.hidden = YES;
//	        self.payButton.hidden = NO;
//	        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
//		}
//	    [self.orderTabelView reloadData];
//	}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(handleEditOrNot:)];

	[[[[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] map: ^id (id value) {
	    if (self.selectedSet.count == 0) {
	        [XPToast showWithText:@"未选择任何列表"];
	        return @(0);
		}
	    return value;
	}] ignore:@(0)] subscribeNext: ^(id x) {
//	    @strongify(self);
//	    __block NSMutableArray *orderList = [NSMutableArray array];
//	    [self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
//	        @strongify(self);
//	        OrderModel *model = self.products[obj.integerValue];
//	        ProductInfoModel *infoModel = [[ProductInfoModel alloc] init];
//	        infoModel.id = model.productId;
//	        infoModel.quantity = model.quantity;
//	        infoModel.saleprice = model.detail.saleprice;
////	        infoModel.images = model.detail.images;
//	        infoModel.name = model.detail.name;
//	        [orderList addObject:infoModel];
//		}];
	    ProductOrderViewController *viewController = (ProductOrderViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductOrder"];
	    //TODO: 未考虑购物车的属性，应该是对方没有考虑到这个点
        NSMutableArray *mutRelaty = [NSMutableArray array];
        for (int m = 0; m < self.selectedSet.count; m++) {
            [mutRelaty addObject:self.mutCarList[[self.selectedSet[m] integerValue]]];
        }
        NSMutableArray *supArr = [NSMutableArray array];
        for (int i = 0; i < mutRelaty.count; i++) {
            CarlistCellModel *model = mutRelaty[i];
//            [supArr addObject:model.name];
            NSLog(@"modelName:%@, count:%d", model.name, model.product_items.count);
            
            NSMutableArray *mutDataArr = [NSMutableArray array];
            for (int j = 0; j < model.product_items.count; j++) {
                subCarList *subCar = model.product_items[j];
                
                ProductInfoModelSV *model = [[ProductInfoModelSV alloc] init];
                model.good_brand_id = subCar.strId;
                model.good_number = subCar.good_number;
                model.good_price = subCar.good_price;
                model.strID = subCar.strId;
                model.norms = subCar.norms;
                model.pro_address = subCar.pro_address;
                model.product_id = subCar.strId;
                model.pure = subCar.pure;
                model.refractive = @"";
                model.stock = subCar.stock;
                model.quantity = subCar.quantity;
                
                [mutDataArr addObject:model];
            }
            
            if (mutDataArr.count != 0) {
                NSDictionary *dic = @{model.name:mutDataArr};
                [supArr addObject:dic];
            }
            
        }
	    viewController.orderStyle = 2;
//	    [viewController updateUIWithOrders:orderList andAttribute:[NSArray array]];
        [viewController updateUIWithOrders:supArr];
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
	        for (NSInteger i = 0; i < self.mutCarList.count; i++) {
	            [self.selectedSet addObject:[NSString stringWithFormat:@"%d", i]];
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

- (void)handleEditOrNot:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        [self.orderTabelView setEditing:YES];
        item.title =  @"取消";
    }else{
        [self.orderTabelView setEditing:NO];
        item.title = @"编辑";
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	@weakify(self);
	[[self.viewModel vipDiscountWithID:[ProfileModel singleton].model.id]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.vipDiscount = x;
	    [self.orderTabelView headerBeginRefreshing];
         [self updateUIWithSelected];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mutCarList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CarlistCellModel *model = self.mutCarList[section];
	return model.product_items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIButton *btnSelected = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSelected setFrame:CGRectMake(7, 7, 30, 30)];
    [btnSelected setImage:[UIImage imageNamed:@"common_checkbox_normal"] forState:UIControlStateNormal];
    [btnSelected setImage:[UIImage imageNamed:@"common_checkbox_checked"] forState:UIControlStateSelected];
    [btnSelected addTarget:self action:@selector(handleSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.selectedSet containsObject:[NSString stringWithFormat:@"%d", section]]) {
        btnSelected.selected = YES;
    }else{
        btnSelected.selected = NO;
    }
    btnSelected.tag = section;
    [backView addSubview:btnSelected];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(44, 7, self.view.frame.size.width-44, 30)];
    if (self.mutCarList.count != 0) {
        CarlistCellModel *model = self.mutCarList[section];
        labelName.text = model.name;
    }
    [backView addSubview:labelName];
    backView.backgroundColor = [UIColor whiteColor];
    return backView;
}

- (void)handleSelectedAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.selectedSet addObject:[NSString stringWithFormat:@"%d", btn.tag]];
    }else{
        [self.selectedSet removeObject:[NSString stringWithFormat:@"%d", btn.tag]];
    }
    [self updateUIWithSelected];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_car_list"];
    if (self.mutCarList.count != 0) {
        CarlistCellModel *model = self.mutCarList[indexPath.section];
        subCarList *subCar = model.product_items[indexPath.row];
        [cell updateUIWithModel:subCar];
    }
    
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//	CartEditTableViewCell *_cell = (CartEditTableViewCell *)cell;
//	[_cell.selectedButton setSelected:NO];
//	[self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
//	    if (indexPath.row == obj.integerValue) {
//	        [_cell.selectedButton setSelected:YES];
//		}
//	}];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	OrderModel *model = self.products[indexPath.row];
//	BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
//	viewController.model = [BaseObject new];
//	viewController.model.identifier = model.productId;
//	[self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        CarlistCellModel *model = self.mutCarList[indexPath.section];
		[self deleteCartListWithID:model.account_id productID:model.proID];
	}
}

#pragma mark - request
- (void)cartListWithPage:(NSInteger)page {
//	[XPProgressHUD showWithStatus:@"加载中"];
//	[[self.viewModel cartListWithID:[ProfileModel singleton].model.id page:page]
//	 subscribeNext: ^(id x) {
//	    if (x) {
//	        if (1 == page) {
//	            self.products = x;
//			}
//	        else {
//	            NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.products];
//	            [buffer addObjectsFromArray:x];
//	            self.products = buffer;
//			}
//		}
//	    else {
//	        if (1 == page) {
//	            self.products = nil;
//			}
//		}
//	    [self.orderTabelView headerEndRefreshing];
//	    [self.orderTabelView footerEndRefreshing];
//	    [self.orderTabelView reloadData];
//	    [XPProgressHUD dismiss];
//	}];
    
    
    if (page == 1) {
        self.mutCarList = [NSMutableArray array];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *strReq = [NSString stringWithFormat:@"http://122.114.61.234/app/api/cart_lists?id=%@&page=%d", [ProfileModel singleton].model.id, page];
    [manager GET:strReq parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
        
        NSArray *carsList = responseObject[@"data"];
        for (int i = 0; i < carsList.count; i++) {
            NSDictionary *dicInfo = carsList[i];
            CarlistCellModel *model = [[CarlistCellModel alloc] init];
            model.account_id = dicInfo[@"account_id"];
            model.proID = dicInfo[@"id"];
            if (dicInfo[@"detail"] != [NSNull null]) {
                model.name = dicInfo[@"detail"][@"name"];
                NSArray *arrItems = dicInfo[@"detail"][@"product_items"];
                NSMutableArray *mutItemsArr = [NSMutableArray array];
                for (int i = 0; i < arrItems.count; i++) {
                    NSDictionary *subDicInfo = arrItems[i];
                    subCarList *sub = [[subCarList alloc] init];
                    sub.strId = subDicInfo[@"id"];
                    sub.good_number = subDicInfo[@"good_number"];
                    sub.pure = subDicInfo[@"pure"];
                    sub.norms = subDicInfo[@"norms"];
                    sub.pro_address = subDicInfo[@"pro_address"];
                    sub.good_price = subDicInfo[@"good_price"];
                    sub.stock = subDicInfo[@"stock"];
                    sub.quantity = subDicInfo[@"quantity"];
                    
                    [mutItemsArr addObject:sub];
                }
                model.product_items = [NSArray arrayWithArray:mutItemsArr];
            }
            
            
            [self.mutCarList addObject:model];
        }
        
        [self.orderTabelView headerEndRefreshing];
        [self.orderTabelView footerEndRefreshing];
        [self.orderTabelView reloadData];
        [XPProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
}

#pragma mark - update
- (void)updateUIWithSelected {
	[self.payButton setTitle:[NSString stringWithFormat:@"结算(%ld)", (unsigned long)self.selectedSet.count] forState:UIControlStateNormal];
	[self.finishButton setTitle:[NSString stringWithFormat:@"删除(%ld)", (unsigned long)self.selectedSet.count] forState:UIControlStateNormal];
	__block CGFloat price = 0;
//	@weakify(self);
//	[self.selectedSet enumerateObjectsUsingBlock: ^(NSNumber *obj, BOOL *stop) {
//	    @strongify(self);
//	    CarlistCellModel *model = self.mutCarList[obj.integerValue];
//        NSArray *arrItems = model.product_items;
//        for (subCarList *subCar in arrItems) {
//            CGFloat singlePrice = [subCar.good_price floatValue];
//            price += singlePrice*[subCar.quantity integerValue];
//        }
////	    CGFloat singlePrice = model.detail.saleprice.floatValue;
////	    price += (singlePrice * model.quantity.integerValue);
//	}];
    
    for (int i = 0; i < self.selectedSet.count; i++) {
        int index = [self.selectedSet[i] intValue];
        CarlistCellModel *model = self.mutCarList[index];
        NSArray *arrItems = model.product_items;
        for (subCarList *subCar in arrItems) {
            CGFloat singlePrice = [subCar.good_price floatValue];
            price += singlePrice*[subCar.quantity integerValue];
        }
    }
//    CGFloat price = 0;
//    for (int i = 0; i < self.selectedSet.count; i++) {
//        NSString *strSection = (NSString *)[self.selectedSet obje]];
//        CarlistCellModel *model = self.mutCarList[indexPath.section];
//        subCarList *subCar = model.product_items[indexPath.row];
//    }
    
    
	self.allPriceLabel.text = [NSString stringWithFormat:@"总计：￥%.2f", price *[self.vipDiscount floatValue]];
	self.oldAllPriceLabel.text = [NSString stringWithFormat:@"商品原价：￥%.2f", price];
	if (self.selectedSet.count != self.mutCarList.count || self.selectedSet.count == 0) {
		[self.allSelectButton setSelected:NO];
	}
	else {
		[self.allSelectButton setSelected:YES];
	}
}

- (void)deleteCartListWithID:(NSString *)account productID:(NSString *)proID {
	@weakify(self);
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel deledateCartListWithID:account productID:proID]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [XPToast showWithText:@"删除成功"];
	    [XPProgressHUD dismiss];
	    [self.orderTabelView headerBeginRefreshing];
	}];
}

@end
