//
//  ProfileViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "ProfileModel.h"
#import "LoginViewController.h"
#import "ProfileView.h"

#import "NSString+imageurl.h"

#import <LASIImageView/LASIImageView.h>
#import <XPKit/XPKit.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  未登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/**
 *  跳转到个人资料按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
/**
 *  个人资料面板
 */
@property (weak, nonatomic) IBOutlet ProfileView *profileView;

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet LASIImageView *avatarImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];

	@weakify(self);
	[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id x) {
	    @strongify(self);
	    [self presentLogin];
	}];

	[[self.profileButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    UIViewController *viewController = [self instantiateViewControllerWithStoryboardName:@"ProfileSub" identifier:@"Profile"];
	    [self.navigationController pushViewController:viewController animated:YES];
	}];
	RAC(self.loginButton, hidden) = RACObserve([ProfileModel singleton], wasLogin);
	RAC(self.profileButton, hidden) = [RACObserve(self.loginButton, hidden) map: ^id (NSNumber *value) {
	    if ([value integerValue] == 1) {
	        return @(0);
		}
	    return @(1);
	}];

	[[RACObserve([ProfileModel singleton], wasLogin) distinctUntilChanged]
	 subscribeNext: ^(NSNumber *x) {
	    @strongify(self);
	    if (x.boolValue) { // 登陆成功
	        [self.profileView setHidden:NO];
	        [self.avatarImageView setImageUrl:[[ProfileModel singleton].model.personPic fullImageURL]];
	        [self.avatarImageView setCornerRadius:40];
	        self.avatarImageView.failedBlock = ^(LASIImageView *imageView, ASIHTTPRequest *request) {
	            @strongify(self);
	            self.avatarImageView.image = [UIImage imageNamed:@"my_defaultavatar"];
			};
		}
	    else { // 注销了
	        [self.profileView setHidden:YES];
	        self.avatarImageView.image = [UIImage imageNamed:@"my_defaultavatar"];
		}
	    [self.tableView reloadData];
	}];
	[[RACObserve([ProfileModel singleton].model, personPic) distinctUntilChanged]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (x) {
	        [self.avatarImageView setImageUrl:[[ProfileModel singleton].model.personPic fullImageURL]];
		}
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return (section == 0 || section == 1) ? 3 : 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([ProfileModel singleton].wasLogin) {
		return 4;
	}
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return section == 0 ? 0 : 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
		ProfileTableViewCell *_cell = (ProfileTableViewCell *)cell;
		switch (indexPath.row) {
			case 0:
				_cell.nameLabel.text = @"报单商城";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_batch_shop_icon"];
				break;

			case 1:
				_cell.nameLabel.text = @"报单购物车";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_batch_cart_icon"];
				break;

			case 2:
				_cell.nameLabel.text = @"报单历史记录";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_batch_his_icon"];
				break;

			default:
				break;
		}
	}
	else if (indexPath.section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
		ProfileTableViewCell *_cell = (ProfileTableViewCell *)cell;
		switch (indexPath.row) {
			case 0:
				_cell.nameLabel.text = @"我的收藏";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_collection_icon"];
				break;

			case 1:
				_cell.nameLabel.text = @"我的订单";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_bill_icon"];
				break;

			case 2:
				_cell.nameLabel.text = @"收货地址";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_location_icon"];
				break;

			default:
				break;
		}
	}
	else if (indexPath.section == 2) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
		ProfileTableViewCell *_cell = (ProfileTableViewCell *)cell;

		switch (indexPath.row) {
			case 0:
				_cell.nameLabel.text = @"设置";
				_cell.iconImageView.image = [UIImage imageNamed:@"my_setting_icon"];
				break;

			default:
				break;
		}
	}
	else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_bottom" forIndexPath:indexPath];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
			{
				UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Report"];
				[self.navigationController pushViewController:viewController animated:YES];
				break;
			}

			case 1:
			{
				if (![ProfileModel singleton].wasLogin) {// 未登陆
					[self presentLogin];
				}
				else {
					UIViewController *viewController = [self instantiateViewControllerWithStoryboardName:@"Report" identifier:@"my"];
					[self.navigationController pushViewController:viewController animated:YES];
				}

				break;
			}

			case 2:
			{
				if (![ProfileModel singleton].wasLogin) {// 未登陆
					[self presentLogin];
				}
				else {
					UIViewController *viewController = [self instantiateViewControllerWithStoryboardName:@"Report" identifier:@"history"];
					[self.navigationController pushViewController:viewController animated:YES];
				}

				break;
			}

			default:
				break;
		}
	}
	else if (indexPath.section ==  1) {
		switch (indexPath.row) {
			case 0:
			{
				if (![ProfileModel singleton].wasLogin) {// 未登陆
					[self presentLogin];
				}
				else {
					UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Collection"];
					[self.navigationController pushViewController:viewController animated:YES];
				}
			}
			break;

			case 1:
			{
				if (![ProfileModel singleton].wasLogin) {// 未登陆
					[self presentLogin];
				}
				else {
					UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"MyOrder"];
					[self.navigationController pushViewController:viewController animated:YES];
				}
			}
			break;

			case 2:
			{
				if (![ProfileModel singleton].wasLogin) {// 未登陆
					[self presentLogin];
				}
				else {
					UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"MyAddress"];
					[self.navigationController pushViewController:viewController animated:YES];
				}
			}
			break;

			default:
				break;
		}
	}
	else if (indexPath.section == 2) {
		switch (indexPath.row) {
			case 0:
			{
				UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Setting"];
				[self.navigationController pushViewController:viewController animated:YES];
			}
			break;

			default:
				break;
		}
	}
	else {
		[UIAlertView alertViewWithTitle:nil message:@"是否确定注销" block: ^(NSInteger buttonIndex) {
		    if (1 == buttonIndex) {
		        [ProfileModel singleton].phone = nil;
		        [ProfileModel singleton].password = nil;
		        [ProfileModel singleton].model = nil;
		        [ProfileModel singleton].wasLogin = NO;
		        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id"];
		        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passwd"];
		        [[NSUserDefaults standardUserDefaults] synchronize];
			}
		} cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	}
}

@end
