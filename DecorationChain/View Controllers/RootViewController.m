//
//  ViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RootViewController.h"
#import "RootViewModel.h"
#import "XPADView.h"
#import <Masonry/Masonry.h>
#import "MainSubView.h"
#import "LoginViewModel.h"
#import "ProfileModel.h"
#import "XPProgressHUD.h"
#import "NSDate+XPKit.h"
#import "RootTopTableViewCell.h"
#include "ProductModel.h"
#import "ProductProfileTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "ShowMoreProductController.h"
#import "ResultViewController.h"

#define TEST 0

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet ProductModel *productModel;
@property (strong, nonatomic) NSMutableArray *mutArrProducts;
@property (assign, nonatomic) NSInteger page;


#if TEST
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) UIAlertView *alertView;
#endif

@end

@implementation RootViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	{ // 导航栏右边按钮
		UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[phoneButton setFrame:ccr(0, 0, 30, 30)];
		[phoneButton setBackgroundImage:[UIImage imageNamed:@"ic_call"] forState:UIControlStateNormal];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:phoneButton];
		[[phoneButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006990298"]];
		}];
        
        UIButton *phoneButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneButton2 setFrame:ccr(155, 7, 120, 30)];
        phoneButton2.tag = 999;
        [phoneButton2 setTitle:@"400-699-0298" forState:UIControlStateNormal];
        [self.navigationController.navigationBar addSubview:phoneButton2];
        [[phoneButton2 rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext: ^(id x) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006990298"]];
         }];
	}

	{ // 导航栏左边
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:ccr(0, 7, 120, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.text = @"华威锐科";
        nameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nameLabel];
	}

#if TEST
	self.startTime = [NSDate date];
#endif
    [XPProgressHUD showWithStatus:@"请稍候..."];
    [self obtainProducts];
    
    [self.listTableView addHeaderWithCallback:^{
        [self obtainProducts];
    }];
    
    [self.listTableView addFooterWithCallback:^{
        [self obtainMoreProducts];
    }];
    
}

- (void)obtainProducts
{
    self.mutArrProducts = [NSMutableArray array];
    self.page = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/home" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
        
        NSArray *carsList = responseObject[@"data"];
        for (int i = 0; i < carsList.count; i++) {
            ProductModel *model = [[ProductModel alloc] init];
            model.proId = carsList[i][@"id"];
            model.en_name = carsList[i][@"en_name"];
            model.cas = carsList[i][@"cas"];
            model.formula = carsList[i][@"formula"];
            model.name = carsList[i][@"name"];
            [self.mutArrProducts addObject:model];
        }
        
        [XPProgressHUD dismiss];
        [self.listTableView headerEndRefreshing];
        [self.listTableView reloadData];
        
        
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
}

- (void)obtainMoreProducts
{
    self.page++;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/home" parameters:@{@"page":@(self.page)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
        
        NSArray *carsList = responseObject[@"data"];
        for (int i = 0; i < carsList.count; i++) {
            ProductModel *model = [[ProductModel alloc] init];
            model.proId = carsList[i][@"id"];
            model.en_name = carsList[i][@"en_name"];
            model.cas = carsList[i][@"cas"];
            model.formula = carsList[i][@"formula"];
            model.name = carsList[i][@"name"];
            [self.mutArrProducts addObject:model];
        }
        
        [XPProgressHUD dismiss];
        [self.listTableView footerEndRefreshing];
        [self.listTableView reloadData];
        
        
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
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[self.navigationController.navigationBar viewWithTag:999] setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[self.navigationController.navigationBar viewWithTag:999] setHidden:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - title
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_ad_info"]) {
		BaseViewController *viewController = segue.destinationViewController;
		viewController.model = [BaseObject new];
		viewController.model.baseTransfer = sender;
		viewController.model.identifier = segue.context;
	}
}

#pragma mark - auto login
- (void)autoLogin {
	if ([ProfileModel singleton].phone && [ProfileModel singleton].password) {
		LoginViewModel *loginViewModel = [[LoginViewModel alloc] init];
		[XPProgressHUD showWithStatus:@"自动登陆中..."];
		[[loginViewModel signInSignal:[ProfileModel singleton].phone password:[ProfileModel singleton].password]
		 subscribeNext: ^(id x) {
		    if (x) {
		        [ProfileModel singleton].model = [x copy];
		        [ProfileModel singleton].wasLogin = YES;
			}
		    [XPProgressHUD dismiss];
#if TEST
		    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
#endif
		}];
	}
#if TEST
	else {
		[self.alertView dismissWithClickedButtonIndex:0 animated:YES];
	}
#endif
}

#pragma mark - tableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 155.0f;
    }else{
        return 129.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutArrProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *strIndentifier = @"rowIndexZero";
        RootTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIndentifier];
        if (cell == nil) {
            cell = [[RootTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIndentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showMoreProduct = ^{
            ShowMoreProductController *vcShowMore = [[ShowMoreProductController alloc] initWithNibName:@"ShowMoreProductController" bundle:nil];
            vcShowMore.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcShowMore animated:YES];
        };
        cell.showSearchResult = ^(NSString *category, NSString *keyWord){
            ResultViewController *vcResult = [[ResultViewController alloc] initWithCategory:category keyWord:keyWord];
            vcResult.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vcResult animated:YES];
        };
        
        return cell;
    }else{
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
    viewController.model = [BaseObject new];
    
    ProductModel *model = self.mutArrProducts[indexPath.row];
    viewController.model.identifier = model.proId;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
