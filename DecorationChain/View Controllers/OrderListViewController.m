//
//  OrderListViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"

#import "MyOrderViewModel.h"
#import "ProfileModel.h"

#import <XPKit/XPKit.h>
#import "XPProgressHUD.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "OrderInfoViewController.h"

#ifndef REUSE_CELL_IDENTIFIER
#define REUSE_CELL_IDENTIFIER  @"Cell"
#endif
@interface OrderListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet MyOrderViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *orders;
@property (nonatomic, assign) NSInteger page;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:REUSE_CELL_IDENTIFIER];
	[self.tableView hideEmptySeparators];

	@weakify(self);
	[self.tableView addHeaderWithCallback: ^{
	    @strongify(self);
	    self.page = 1;
	    [self orderListWithPage:self.page];
	}];
	[self.tableView addFooterWithCallback: ^{
	    @strongify(self);
	    self.page += 1;
	    [self orderListWithPage:self.page];
	}];
	[self.tableView headerBeginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_order_info"]) {
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
//		viewController.model = [BaseObject new];
		viewController.model = (OrderListModel *)sender;
	}
}

#pragma mark - override
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_CELL_IDENTIFIER forIndexPath:indexPath];
	if (!cell) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil] lastObject];
	}
    if (self.orders.count > 0) {
        OrderListModel *model = self.orders[indexPath.row];
        [cell updateWithModel:model];
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	OrderListModel *model = self.orders[indexPath.row];
//	[self performSegueWithIdentifier:@"embed_order_info" sender:model];
    OrderInfoViewController *viewController = (OrderInfoViewController *)[self instantiateViewControllerWithStoryboardName:@"MyOrder" identifier:@"dingdanxiangqing"];
    viewController.orderListModel = model;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - function
- (void)orderListWithPage:(NSInteger)page {
	@weakify(self);
	[XPProgressHUD showWithStatus:@"加载中"];
    if (page == 1) {
        self.orders = [NSMutableArray array];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/my_order" parameters:@{
                                                                        @"account_id":[ProfileModel singleton].model.id,
                                                                        @"order_type":@(self.model.baseTransfer.integerValue),
                                                                        @"page":@(page)
                                                                        }  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
        
        NSArray *carsList = responseObject[@"data"];
        for (int i = 0; i < carsList.count; i++) {
            OrderListModel *model = [[OrderListModel alloc] init];
            model.accountId = carsList[i][@"account_id"];
            model.items = carsList[i][@"items"];
            model.orderNumber = carsList[i][@"order_number"];
            model.orderedOn = carsList[i][@"ordered_on"];
            model.payStatus = carsList[i][@"pay_status"];
            model.total = carsList[i][@"total"];
            model.id = carsList[i][@"id"];
            model.order_type = carsList[i][@"order_type"];
            [self.orders addObject:model];
        }
        
                                                                            
        [self.tableView headerEndRefreshing];
                                                                            [XPProgressHUD dismiss];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
//	self.viewModel = [[MyOrderViewModel alloc] init];
//	[[self.viewModel orderListWithID:[ProfileModel singleton].model.id orderType:self.model.baseTransfer.integerValue page:self.page]
//	 subscribeNext: ^(id x) {
//	    @strongify(self);
//	    if (1 == page) {
//	        self.orders = x;
//		}
//	    else {
//	        NSMutableArray *buffer = [NSMutableArray arrayWithArray:self.orders];
//	        [buffer addObjectsFromArray:x];
//	        self.orders = buffer;
//		}
//
//	    [self.tableView headerEndRefreshing];
//	    [self.tableView footerEndRefreshing];
//	    [self.tableView reloadData];
//	    [XPProgressHUD dismiss];
//	}];
}

@end
