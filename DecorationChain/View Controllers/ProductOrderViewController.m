//
//  ProductOrderViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductOrderViewController.h"
#import "ProductOrderAddressView.h"

#import <XPKit/XPKit.h>
#import <CSNNotificationObserver/CSNNotificationObserver.h>
#import <IQKeyboardManager/IQTextView.h>
#import <LASIImageView/LASIImageView.h>
#import <Masonry/Masonry.h>
#import <XPToast/XPToast.h>

#import "ProductInfoModel.h"
#import "NSString+imageurl.h"
#import "ProductOrderViewModel.h"
#import "RuntimeCacheModel.h"
#import "XPProgressHUD.h"
#import "ProfileModel.h"
#import "AddressModel.h"
#import "ProductInfoNumberTableViewCell.h"
#import "ProInfoTableViewCell.h"
#import "ProductInfoModelSV.h"

@interface ProductOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet ProductOrderViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIView *submitView;
@property (weak, nonatomic) IBOutlet UILabel *truePriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitOrderButton;
@property (nonatomic, strong) CSNNotificationObserver *observer;

@property (nonatomic, assign) BOOL extend;
@property (nonatomic, strong) AddressModel *orderAddressModel;

/**
 *  购物列表
 */
@property (nonatomic, strong) NSArray *willBuyOrders;

/**
 *  属性列表
 */
@property (nonatomic, strong) NSArray *willBuyAttribute;
@property (nonatomic, strong) NSDictionary *dicInfo;
@property (nonatomic, strong) NSArray *arrInfo;
@end

@implementation ProductOrderViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];
	self.extend = NO;

//	__block CGFloat totalMoney = 0;
//	[self.willBuyOrders each: ^(ProductInfoModel *item) {
//	    totalMoney += (item.saleprice.floatValue * item.quantity.integerValue);
//	}];
//	for (NSInteger i = 0; i < self.willBuyAttribute.count; i++) {
//		NSArray *itemAttribute = self.willBuyAttribute[i]; // 每一行
//		[itemAttribute each: ^(NSDictionary *item) { // 每一列
//		    totalMoney += [item[@"detail_price"] floatValue];
//		}];
//	}
//	self.truePriceLabel.text = [NSString stringWithFormat:@"￥%.2f", totalMoney];

	@weakify(self);
	[[[[[self.submitOrderButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	}] map: ^id (id value) {
	    @strongify(self);
	    if (!self.extend) { // 未选择收货地址
	        [XPToast showWithText:@"请选择收货地址"];
	        return @(0);
		}
	    return value;
	}] ignore:@(0)]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self submitOrder];
	}];

	// 获取折扣率
	[XPProgressHUD showWithStatus:@"加载中"];
	[[self.viewModel vipDiscountWithID:[ProfileModel singleton].model.id]
	 subscribeNext: ^(id x) {
	    @strongify(self);
//	    self.truePriceLabel.text = [NSString stringWithFormat:@"￥%.2f", totalMoney *[x floatValue]];
	    [XPProgressHUD dismiss];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2], [NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - selected address
- (void)respondsNotification:(NSNotification *)notification {
	self.extend = YES;
	self.orderAddressModel = [notification object];
	[self.tableView reloadData];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return self.extend ? 140 : 50;
			break;

		case 1:
            if (indexPath.row == 0) {
                return 34;
            }else{
                return 106;
            }
			break;

		case 2:
		case 3:
			return 34;
			break;

		case 4:
			return 95;
			break;

		case 5:
			return 34;

		case 6:
			return 54;
			break;

		default:
			break;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1) {
		return self.arrInfo.count+1;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = identifier = [NSString stringWithFormat:@"Cell_%ld", (long)indexPath.section];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	switch (indexPath.section) {
		case 0: // 选地址或重设地址
		{
			if (self.extend) {
				ProductOrderAddressView *addressView = (ProductOrderAddressView *)[cell.contentView viewWithTag:100];
				[addressView updateWithModel:self.orderAddressModel];
				addressView.hidden = NO;

				UIButton *button = (UIButton *)[cell.contentView viewWithTag:200];
				button.hidden = YES;
				cell.accessoryType =  UITableViewCellAccessoryNone;
			}
			else {
				ProductOrderAddressView *addressView = (ProductOrderAddressView *)[cell.contentView viewWithTag:100];
				addressView.hidden = YES;

				UIButton *button = (UIButton *)[cell.contentView viewWithTag:200];
				button.hidden = NO;
				cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
			}
			break;
		}

		case 1: // 购物清单
		{
            if (indexPath.row ==0) {
                for (UIView *subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                
                cell.textLabel.text = [self.dicInfo allKeys][0];
            }else{
                ProInfoTableViewCell *cellself = (ProInfoTableViewCell *)cell;
                [cellself updateCellWithInfo:self.arrInfo[indexPath.row-1]];
            }
			break;
		}

		case 2: // 支付与配送
		{
			if ([RuntimeCacheModel singleton].payment &&
			    [RuntimeCacheModel singleton].shipment) {
				UIView *subView = [cell.contentView viewWithTag:100];
				NSString *pay = nil;
				NSString *ship = nil;

				if ([RuntimeCacheModel singleton].payment.integerValue == 1) {
					pay = @"在线支付";
				}
				else {
					pay = @"货到付款";
					[[subView subviews] each: ^(id item) {
					    if ([item isKindOfClass:[UILabel class]]) {
					        [(UILabel *)item setText:@"货到付款"];
						}
					}];
				}
				if ([RuntimeCacheModel singleton].shipment.integerValue == 1) {
					ship = @"普通快递";
				}
				else {
					ship = @"到店自取";
				}

				[[subView subviews] each: ^(id item) {
				    if ([item isKindOfClass:[UILabel class]]) {
				        [(UILabel *)item setText:[NSString stringWithFormat:@"%@ %@", pay, ship]];
					}
				}];
			}
			break;
		}

		case 3: // 发票信息
		{
			if ([RuntimeCacheModel singleton].invoiceName) {
				UIView *subView = [cell.contentView viewWithTag:100];
				[[subView subviews] each: ^(id item) {
				    if ([item isKindOfClass:[UILabel class]]) {
				        [(UILabel *)item setText:[RuntimeCacheModel singleton].invoiceName];
					}
				}];
			}
			break;
		}

		case 4: // 备注
		{
			UIView *subView = [cell.contentView viewWithTag:100];
			{
				IQTextView *remarkTextView = (IQTextView *)[subView viewWithTag:2];
				[remarkTextView setPlaceholder:@"请输入备注信息"];
			}

			break;
		}

		case 5: // 商品总额
		{
//			__block CGFloat totalMoney = 0;
//			[self.willBuyOrders each: ^(ProductInfoModel *item) {
//			    totalMoney += (item.saleprice.floatValue * item.quantity.integerValue);
//			}];
//			for (NSInteger i = 0; i < self.willBuyAttribute.count; i++) {
//				NSArray *itemAttribute = self.willBuyAttribute[i]; // 每一行
//				[itemAttribute each: ^(NSDictionary *item) { // 每一列
//				    totalMoney += [item[@"detail_price"] floatValue];
//				}];
//			}
//
            CGFloat totalMoney = 0;
            
            for (int i = 0; i < self.arrInfo.count; i++) {
                ProductInfoModelSV *model = self.arrInfo[i];
                NSString *price = model.good_price;
                NSString *number = model.quantity;
                totalMoney += [price floatValue]*[number integerValue];
            }
            
            
			UIView *subView = [cell.contentView viewWithTag:100];
			{
				UILabel *priceLabel = (UILabel *)[subView viewWithTag:1];
				NSString *totalPrice = [NSString stringWithFormat:@"￥%.2f", totalMoney];
				[priceLabel setText:totalPrice];
			}
            
            self.truePriceLabel.text = [NSString stringWithFormat:@"￥%.2f", totalMoney];
            

			break;
		}

		case 6: // 运费
		{
			UIView *subView = [cell.contentView viewWithTag:100];
			{
				UILabel *priceLabel = (UILabel *)[subView viewWithTag:1];
				priceLabel.text = @"￥0";
			}

			break;
		}

		default:
			break;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"MyAddress"];
		viewController.model = [BaseObject new];
		viewController.model.baseTransfer = @"joined_product_order";
		[self.navigationController pushViewController:viewController animated:YES];

		@weakify(self);
		self.observer = [[CSNNotificationObserver alloc] initWithName:@"selected_address" object:nil queue:[NSOperationQueue currentQueue] usingBlock: ^(NSNotification *notification) {
		    @strongify(self);
		    [self respondsNotification:notification];
		}];
	}
	else if (indexPath.section == 2) {
		[self performSegueWithIdentifier:@"embed_pay_delivery" sender:self];
	}
	else if (indexPath.section == 3) {
		[self performSegueWithIdentifier:@"embed_invoice" sender:self];
	}
}

#pragma mark - update UI
- (void)updateUIWithOrders:(NSArray *)orders andAttribute:(NSArray *)attribute {
	self.willBuyOrders = orders;
	self.willBuyAttribute = attribute;
	[self.tableView reloadData];
}

- (void)updateUIWithOrders:(NSDictionary *)dicInfo
{
    self.dicInfo = dicInfo;
    self.arrInfo = [dicInfo allValues][0];
    
    CGFloat totalMoney = 0;
    
    for (int i = 0; i < self.arrInfo.count; i++) {
        ProductInfoModelSV *model = self.arrInfo[i];
        NSString *price = model.good_price;
        NSString *number = model.quantity;
        totalMoney += [price floatValue]*[number integerValue];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.truePriceLabel.text = [NSString stringWithFormat:@"￥%.2f", totalMoney];
        [self.truePriceLabel setNeedsDisplay];
    });
    
}

#pragma mark - submit order
- (void)submitOrder {
	[XPProgressHUD showWithStatus:@"加载中"];
	NSMutableArray *products = [NSMutableArray arrayWithArray:self.arrInfo];
//	for (NSInteger i = 0; i < self.willBuyOrders.count; i++) {
//		ProductInfoModel *infoModel = self.willBuyOrders[i];
//		[products addObject:@[infoModel.id, infoModel.quantity]];
//	}
	@weakify(self);
	// 检查是否有选择“支付方式”、“快递方式”、“发票名称”，否则使用默认值
	NSString *payment = [RuntimeCacheModel singleton].payment ? [RuntimeCacheModel singleton].payment : @"1";
	NSString *shipment = [RuntimeCacheModel singleton].shipment ? [RuntimeCacheModel singleton].shipment : @"1";
	NSString *fpName = [RuntimeCacheModel singleton].invoiceName ? [RuntimeCacheModel singleton].invoiceName : @"个人发票";
	[[self.viewModel orderCreateWithID:[ProfileModel singleton].model.id addressID:self.orderAddressModel.id products:products fpType:@"1" fpKind:@"1" fpName:fpName payment:payment shipment:shipment attribute:self.willBuyAttribute orderStyle:self.orderStyle] subscribeNext: ^(id x) {
	    @strongify(self);
	    [self performSegueWithIdentifier:@"embed_order_info" sender:x];
	    [XPProgressHUD dismiss];
	} error: ^(NSError *error) {
	    NSLog(@"%@", error);
	}];
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_order_info"]) {
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
		viewController.model = sender;
	}
}

@end
