//
//  OrderInfoViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderInfoViewController.h"

#import <LASIImageView/LASIImageView.h>
#import "NSString+imageurl.h"

#import "MyOrderViewModel.h"
#import "OrderInfoModel.h"
#import "OrderCreateModel.h"
#import "ProductOrderAddressView.h"
#import "AddressModel.h"

#import "Order.h"
#import "base64.h"
#import "DataSigner.h"
#import "../alipay/AlipaySDK.framework/Headers/AlipaySDK.h"


#import "RuntimeCacheModel.h"
#import "UIAlertView+XPKit.h"
#import "XPProgressHUD.h"
#import <XPKit/XPKit.h>
#import "OrderDetailNew.h"
#import "OrderDetailCell.h"

@interface OrderInfoViewController () <UITextViewDelegate, UITableViewDataSource>
{
    OrderDetailNew *orderDetailnew;
    NSMutableArray *mutProducts;
}

@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet MyOrderViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OrderInfoModel *infoModel;
@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];
    self.tableView.hidden = YES;

//	@weakify(self);
//	[[[[[self.controlButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
//	    [XPProgressHUD showWithStatus:@"加载中"];
//	}] map: ^id (id value) {
//	    @strongify(self);
//	    if ([self.controlButton.currentTitle isEqualToString:@"立即支付"]) {
//	        return @(1);
//		}
//	    else if ([self.controlButton.currentTitle isEqualToString:@"已支付，等待商家发货中"]) {
//	        return @(2);
//		}
//	    else if ([self.controlButton.currentTitle isEqualToString:@"确认收货"]) {
//	        return @(3);
//		}
//	    else if ([self.controlButton.currentTitle isEqualToString:@"待评价"]) {
//	        return @(4);
//		}
//	    else if ([self.controlButton.currentTitle isEqualToString:@"本次交易已完成"]) {
//	        return @(5);
//		}
//	    return value;
//	}] ignore:@(0)]
//	 subscribeNext: ^(NSNumber *x) {
//	    @strongify(self);
//	    if (x.integerValue == 1) { // 立即支付
//	        [[self.viewModel alipayInfoWithOrderID:self.infoModel.id]
//	         subscribeNext: ^(id x) {
//	            [XPProgressHUD dismiss];
//	            @strongify(self);
//	            [self wakeAlipay:x];
//			}];
//		}
//	    else if (x.integerValue == 3) { // 确认收货
//	        [[self.viewModel orderConfirmFinishWithOrderID:self.infoModel.id]
//	         subscribeNext: ^(id x) {
//	            [XPProgressHUD dismiss];
//	            [UIAlertView alertViewWithTitle:nil message:@"确认收货成功" block: ^(NSInteger buttonIndex) {
//	                [self.navigationController popViewControllerAnimated:YES];
//				} buttonTitle:@"确定"];
//			}];
//		}
//	    else if (x.integerValue == 4) { // 待评价
//	        [XPProgressHUD dismiss];
//	        [self performSegueWithIdentifier:@"embed_score" sender:self.infoModel];
//		}
//	}];
    
}
- (IBAction)enterOrderCenter:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[XPProgressHUD showWithStatus:@"加载中"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/order_detail" parameters:@{@"order_id":self.orderListModel.id,
                                                                            @"order_type":self.orderListModel.order_type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
        
        NSDictionary *carsList = responseObject[@"data"];
        orderDetailnew = [[OrderDetailNew alloc] init];
        orderDetailnew.name = carsList[@"name"];
        orderDetailnew.phone = carsList[@"phone"];
        orderDetailnew.ship_province = carsList[@"ship_province"];
        orderDetailnew.ship_city = carsList[@"ship_city"];
        orderDetailnew.ship_district = carsList[@"ship_district"];
        orderDetailnew.ship_address = carsList[@"ship_address"];
        orderDetailnew.ship_notes = carsList[@"shipping_notes"];
        orderDetailnew.total = carsList[@"total"];
                                                                                
//        for (int i = 0; i < carsList.count; i++) {
//            ProductModel *model = [[ProductModel alloc] init];
//            model.proId = carsList[i][@"id"];
//            model.en_name = carsList[i][@"en_name"];
//            model.cas = carsList[i][@"cas"];
//            model.formula = carsList[i][@"formula"];
//            model.name = carsList[i][@"name"];
//            [self.mutListMore addObject:model];
//        }
//        
//
        NSArray *contentsArr = carsList[@"contents"];
        mutProducts = [NSMutableArray array];
        for (NSDictionary *subDic in contentsArr) {
            OrderDetailModel *model = [[OrderDetailModel alloc] init];
            model.mingcheng = subDic[@"product_name"];
            model.huohao = subDic[@"good_number"];
            model.cundu = subDic[@"pure"];
            model.jiage = subDic[@"good_price"];
            model.chandi = subDic[@"pro_address"];
            model.guige = subDic[@"norms"];
            model.kucun = subDic[@"stock"];
            model.shuliang = subDic[@"quantity"];
            
            [mutProducts addObject:model];
        }
        self.tableView.hidden = NO;
        [XPProgressHUD dismiss];
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
    
    /*
	@weakify(self);
	[[self.viewModel orderInfoWithOrderID:self.model.baseTransfer]
	 subscribeNext: ^(OrderInfoModel *x) {
	    @strongify(self);
	    self.infoModel = x;
	    [self.tableView reloadData];

	    NSInteger orderStatus = self.infoModel.orderType.integerValue;
	    switch (orderStatus) {
			case 1:  // 立即支付
				[self.controlButton setTitle:@"立即支付" forState:UIControlStateNormal];
				[self.controlButton setEnabled:YES];
				break;

			case 2:  // 已支付，等待商家发货中(不可点击)
				[self.controlButton setTitle:@"已支付，等待商家发货中" forState:UIControlStateNormal];
				[self.controlButton setEnabled:NO];
				break;

			case 3:  // 确认收货
				[self.controlButton setTitle:@"确认收货" forState:UIControlStateNormal];
				[self.controlButton setEnabled:YES];
				break;

			case 4:  // 待评价
				[self.controlButton setTitle:@"待评价" forState:UIControlStateNormal];
				[self.controlButton setEnabled:YES];
				break;

			case 5:  // 本次交易已完成（不可点击）
				[self.controlButton setTitle:@"本次交易已完成" forState:UIControlStateNormal];
				[self.controlButton setEnabled:NO];
				break;

			default:
				break;
		}
	    [XPProgressHUD dismiss];
	}];    */
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return mutProducts.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 115;
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"orderInfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"收货人";
                cell.detailTextLabel.text = orderDetailnew.name;
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"联系方式";
                cell.detailTextLabel.text = orderDetailnew.phone;
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"所在区域";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", orderDetailnew.ship_province, orderDetailnew.ship_city, orderDetailnew.ship_district];
                cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"详细地址";
                cell.detailTextLabel.text = orderDetailnew.ship_address;
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        OrderDetailCell *cell = (OrderDetailCell *)[self.tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
        [cell updateWithModel:mutProducts[indexPath.row]];
    } else if (indexPath.section == 2){
        cell.textLabel.text = @"发票信息";
        cell.detailTextLabel.text = @"个人发票";
    }else if (indexPath.section == 3){
        cell.textLabel.text = @"订单备注";
        cell.detailTextLabel.text = orderDetailnew.ship_notes;
    }else if (indexPath.section == 4){
        cell.textLabel.text = @"商品金额";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%@", orderDetailnew.total];
    }else{
        cell.textLabel.text = @"管理员备注";
        cell.detailTextLabel.text = @"无";
    }
	return cell;
}

#pragma mark - confirm

#pragma mark - alipay
- (void)wakeAlipay:(NSDictionary *)alipayInfoModel {
	Order *order = [[Order alloc] init];
	order.partner = alipayInfoModel[@"partner"];
	order.seller = alipayInfoModel[@"userID"];
	order.tradeNO = self.infoModel.id; //订单ID（由商家自行制定）
	order.productName = @"o2o"; //商品标题
	order.productDescription = @"o2o"; //商品描述
	order.amount = self.infoModel.total; //商品价格
	order.notifyURL = alipayInfoModel[@"notify_url"]; //回调URL

	order.service = @"mobile.securitypay.pay";
	order.paymentType = @"1";
	order.inputCharset = @"utf-8";
	order.itBPay = [NSString stringWithFormat:@"%@m", alipayInfoModel[@"time_out"]];
	order.showUrl = @"m.alipay.com";

	NSString *appScheme = @"DecorationChain";

	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@", orderSpec);

	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id <DataSigner> signer = CreateRSADataSigner(alipayInfoModel[@"private_key"]);
	NSString *signedString = [signer signString:orderSpec];
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
		[RuntimeCacheModel singleton].tradeNO = self.infoModel.id;
		[RuntimeCacheModel singleton].payTimes = @"second";
		[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback: ^(NSDictionary *resultDic) {
		    NSString *statues = resultDic[@"resultStatus"];
		    if ([statues isEqualToString:@"9000"]) {
		        [UIAlertView alertViewWithTitle:nil message:@"支付成功" block: ^(NSInteger buttonIndex) {
		            [self.navigationController popViewControllerAnimated:YES];
				} buttonTitle:@"确定"];
			}
		    else {
		        [UIAlertView alertViewWithTitle:nil message:@"支付失败" block: ^(NSInteger buttonIndex) {
		            [self.navigationController popViewControllerAnimated:YES];
				} buttonTitle:@"确定"];
			}
		}];
	}
	else {
		[UIAlertView alertViewWithTitle:nil message:@"支付失败" block: ^(NSInteger buttonIndex) {
		    [self.navigationController popViewControllerAnimated:YES];
		} buttonTitle:@"确定"];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_score"]) {
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
		viewController.model = self.infoModel;
	}
}

@end
