//
//  ProductOrderInfoViewController.m
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProductOrderInfoViewController.h"
#import "OrderCreateModel.h"
#import "RuntimeCacheModel.h"
#import "ProductOrderAddressView.h"
#import "LASIImageView.h"
#import "NSString+imageurl.h"
#import "ProductOrderInfoViewModel.h"
#import "XPProgressHUD.h"
#import "AlipayInfoModel.h"


#import "Order.h"
#import "base64.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MyOrderViewController.h"

@interface ProductOrderInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) OrderCreateModel *orderModel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet ProductOrderInfoViewModel *viewModel;

@end

@implementation ProductOrderInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];
	self.orderModel = (OrderCreateModel *)self.model;
	[self.tableView reloadData];

	@weakify(self);
	[[[[[self.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	}] map: ^id (id value) {
	    [XPProgressHUD showWithStatus:@"加载中"];
	    return value;
	}] ignore:@(0)]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [[self.viewModel alipayInfoWithOrderID:self.orderModel.id]
	     subscribeNext: ^(id x) {
	        [XPProgressHUD dismiss];
	        @strongify(self);
	        [self wakeAlipay:x];
		}];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 70;
			break;

		case 1:
			return 140;
			break;

		case 2:
			return 55;
			break;

		case 3:
			return 35;
			break;

		case 4:
			return 65;
			break;

		default:
			break;
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.orderModel.contents.count;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld", (long)indexPath.section] forIndexPath:indexPath];
	switch (indexPath.section) {
		case 0: // 购物清单
		{
			OrderCreateContentModel *infoModel = (OrderCreateContentModel *)[self.orderModel.contents objectAtIndex:indexPath.row];
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
				priceLabel.text = [NSString stringWithFormat:@"￥%@", infoModel.price];
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
			model.accountId = self.orderModel.accountId;
			model.recipientsName = self.orderModel.shipCompany;
			model.telephone = self.orderModel.shipPhone;
			model.province = self.orderModel.shipProvince;
			model.city = self.orderModel.shipCity;
			model.district = self.orderModel.shipDistrict;
			model.address = self.orderModel.shipAddress;
			[addressView updateWithModel:model];
			break;
		}

		case 2: // 支付方式及快递方式
		{
			[[cell.contentView viewWithTag:100] setHidden:[[RuntimeCacheModel singleton].payment boolValue]];
			[[cell.contentView viewWithTag:101] setHidden:![[RuntimeCacheModel singleton].payment boolValue]];


			[[cell.contentView viewWithTag:200] setHidden:[[RuntimeCacheModel singleton].shipment boolValue]];
			[[cell.contentView viewWithTag:201] setHidden:![[RuntimeCacheModel singleton].shipment boolValue]];
			break;
		}

		case 3: // 实付款
		{
			[(UILabel *)[cell.contentView viewWithTag:100] setText:[NSString stringWithFormat:@"￥%@", self.orderModel.total]];
			break;
		}

		default:
			break;
	}
	return cell;
}

#pragma mark - alipay
- (void)wakeAlipay:(NSDictionary *)alipayInfoModel {
    
    UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"MyOrder"];
    [self.navigationController pushViewController:viewController animated:YES];
    
//	Order *order = [[Order alloc] init];
//	order.partner = alipayInfoModel[@"partner"];
//	order.seller = alipayInfoModel[@"userID"];
//	order.tradeNO = self.orderModel.id; //订单ID（由商家自行制定）
//	order.productName = @"ZJB"; //商品标题
//	order.productDescription = @"ZJB"; //商品描述
//	order.amount = self.orderModel.total; //商品价格
//	order.notifyURL = alipayInfoModel[@"notify_url"]; //回调URL
//
//	order.service = @"mobile.securitypay.pay";
//	order.paymentType = @"1";
//	order.inputCharset = @"utf-8";
//	order.itBPay = [NSString stringWithFormat:@"%@m", alipayInfoModel[@"time_out"]];
//	order.showUrl = @"m.alipay.com";
//
//	NSString *appScheme = @"DecorationChain";
//
//	//将商品信息拼接成字符串
//	NSString *orderSpec = [order description];
//	NSLog(@"orderSpec = %@", orderSpec);
//
//	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//	id <DataSigner> signer = CreateRSADataSigner(alipayInfoModel[@"private_key"]);
//	NSString *signedString = [signer signString:orderSpec];
//	//将签名成功字符串格式化为订单字符串,请严格按照该格式
//	NSString *orderString = nil;
//	if (signedString != nil) {
//		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
//		[RuntimeCacheModel singleton].tradeNO = self.orderModel.id;
//		[RuntimeCacheModel singleton].payTimes = @"second";
//		[[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback: ^(NSDictionary *resultDic) {
//		    NSString *statues = resultDic[@"resultStatus"];
//		    if ([statues isEqualToString:@"9000"]) {
//		        [UIAlertView alertViewWithTitle:nil message:@"支付成功" block: ^(NSInteger buttonIndex) {
//		            [self.navigationController popViewControllerAnimated:YES];
//				} buttonTitle:@"确定"];
//			}
//		    else {
//		        [UIAlertView alertViewWithTitle:nil message:@"支付失败" block: ^(NSInteger buttonIndex) {
//		            [self.navigationController popViewControllerAnimated:YES];
//				} buttonTitle:@"确定"];
//			}
//		}];
//	}
//	else {
//		[UIAlertView alertViewWithTitle:nil message:@"支付失败" block: ^(NSInteger buttonIndex) {
//		    [self.navigationController popViewControllerAnimated:YES];
//		} buttonTitle:@"确定"];
//	}
}

@end
