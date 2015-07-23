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

@interface OrderInfoViewController () <UITextViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet MyOrderViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OrderInfoModel *infoModel;
@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];

	@weakify(self);
	[[[[[self.controlButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    [XPProgressHUD showWithStatus:@"加载中"];
	}] map: ^id (id value) {
	    @strongify(self);
	    if ([self.controlButton.currentTitle isEqualToString:@"立即支付"]) {
	        return @(1);
		}
	    else if ([self.controlButton.currentTitle isEqualToString:@"已支付，等待商家发货中"]) {
	        return @(2);
		}
	    else if ([self.controlButton.currentTitle isEqualToString:@"确认收货"]) {
	        return @(3);
		}
	    else if ([self.controlButton.currentTitle isEqualToString:@"待评价"]) {
	        return @(4);
		}
	    else if ([self.controlButton.currentTitle isEqualToString:@"本次交易已完成"]) {
	        return @(5);
		}
	    return value;
	}] ignore:@(0)]
	 subscribeNext: ^(NSNumber *x) {
	    @strongify(self);
	    if (x.integerValue == 1) { // 立即支付
	        [[self.viewModel alipayInfoWithOrderID:self.infoModel.id]
	         subscribeNext: ^(id x) {
	            [XPProgressHUD dismiss];
	            @strongify(self);
	            [self wakeAlipay:x];
			}];
		}
	    else if (x.integerValue == 3) { // 确认收货
	        [[self.viewModel orderConfirmFinishWithOrderID:self.infoModel.id]
	         subscribeNext: ^(id x) {
	            [XPProgressHUD dismiss];
	            [UIAlertView alertViewWithTitle:nil message:@"确认收货成功" block: ^(NSInteger buttonIndex) {
	                [self.navigationController popViewControllerAnimated:YES];
				} buttonTitle:@"确定"];
			}];
		}
	    else if (x.integerValue == 4) { // 待评价
	        [XPProgressHUD dismiss];
	        [self performSegueWithIdentifier:@"embed_score" sender:self.infoModel];
		}
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[XPProgressHUD showWithStatus:@"加载中"];
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
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 0 ? self.infoModel.contents.count : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 70;
			break;

		case 1:
			return 140;
			break;

		default:
			break;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld", (long)indexPath.section] forIndexPath:indexPath];
	switch (indexPath.section) {
		case 0: // 购物清单
		{
			OrderInfoContentModel *infoModel = (OrderInfoContentModel *)[self.infoModel.contents objectAtIndex:indexPath.row];
			UIView *subView = [cell.contentView viewWithTag:100];
			{
				LASIImageView *logoImageView = (LASIImageView *)[subView viewWithTag:0];
				[logoImageView setImageUrl:[infoModel.images fullImageURL]];
			}
			{
				UILabel *titleLabel = (UILabel *)[subView viewWithTag:1];
				titleLabel.text = infoModel.name;
			}
			{
				UILabel *priceLabel = (UILabel *)[subView viewWithTag:2];
				priceLabel.text = [NSString stringWithFormat:@"￥%@", infoModel.saleprice];
			}
			{
				UILabel *numberLabel = (UILabel *)[subView viewWithTag:3];
				numberLabel.text = [NSString stringWithFormat:@"数量 %@", infoModel.quantity];
			}
			break;
		}

		case 1: // 收货地址
		{
			ProductOrderAddressView *addressView = (ProductOrderAddressView *)[cell.contentView viewWithTag:100];
			AddressModel *model = [[AddressModel alloc] init];
			model.accountId = self.infoModel.accountId;
			model.recipientsName = self.infoModel.shipCompany;
			model.telephone = self.infoModel.shipPhone;
			model.province = self.infoModel.shipProvince;
			model.city = self.infoModel.shipCity;
			model.district = self.infoModel.shipDistrict;
			model.address = self.infoModel.shipAddress;
			[addressView updateWithModel:model];
			break;
		}

		default:
			break;
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
