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

#define TEST 0

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet XPADView *adView;
@property (strong, nonatomic) IBOutlet RootViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *specialButton;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *freeButton;
@property (weak, nonatomic) IBOutlet UIButton *tuanButton;
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
		    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://037153315676"]];
		}];

		UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[searchButton setFrame:ccr(230, 10, 25, 25)];
		[searchButton setBackgroundImage:[UIImage imageNamed:@"search_button"] forState:UIControlStateNormal];
		searchButton.tag = 999;
		[self.navigationController.navigationBar addSubview:searchButton];
		@weakify(self);
		[[searchButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    UIViewController *viewController = [self instantiateInitialViewControllerWithStoryboardName:@"Search"];
		    [self presentViewController:viewController animated:YES completion:nil];
		}];
	}

	{ // 导航栏左边
		UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
		[logoImageView setFrame:ccr(0, 0, 100, 30)];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoImageView];
	}

	@weakify(self);
	[[self.specialButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
	    viewController.model =  [BaseObject new];
	    viewController.model.baseTransfer = @"0";
	    [self.navigationController pushViewController:viewController animated:YES];
	}];
	[[self.recommendButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
	    viewController.model =  [BaseObject new];
	    viewController.model.baseTransfer = @"3";
	    [self.navigationController pushViewController:viewController animated:YES];
	}];
	[[self.hotButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
	    viewController.model =  [BaseObject new];
	    viewController.model.baseTransfer = @"2";
	    [self.navigationController pushViewController:viewController animated:YES];
	}];
	[[self.tuanButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
	    viewController.model =  [BaseObject new];
	    viewController.model.baseTransfer = @"1";
	    [self.navigationController pushViewController:viewController animated:YES];
	}];
	[[self.freeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
	    viewController.model =  [BaseObject new];
	    viewController.model.baseTransfer = @"4";
	    [self.navigationController pushViewController:viewController animated:YES];
	}];

#if TEST
	self.startTime = [NSDate date];
#endif
	[XPProgressHUD showWithStatus:@"正在初始化，请稍候..."];
	[[self.viewModel ads]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.adView uploadUI:x];
	}];

	[[self.viewModel initialIndex]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self reloadBottom:x];

	    {  // 自动登陆
	        [self autoLogin];
		}
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

- (void)reloadBottom:(NSArray *)sender {
	CGSize specialsSize = CGSizeZero;
	CGSize tuansSize = CGSizeZero;
	CGSize hotsSize = CGSizeZero;
	CGSize recommendsSize = CGSizeZero;
	{ // 加载今日特价
		NSArray *specials = sender[0];
		MainSubView *specialView = [[NSBundle mainBundle] loadNibNamed:@"Main_sub" owner:self options:nil][0];
		specialView.frame = ccr(0, 418, self.view.width, 0);
		specialView.titleLabel.text = @"今日特价";
		[self.contentScrollView addSubview:specialView];
		specialsSize = [specialView updateUIWithData:specials];

		@weakify(self);
		[[specialView.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
		    viewController.model =  [BaseObject new];
		    viewController.model.baseTransfer = @"0";
		    [self.navigationController pushViewController:viewController animated:YES];
		}];
	}
	{ // 加载团购
		NSArray *tuans = sender[1];
		MainSubView *tuanView = [[NSBundle mainBundle] loadNibNamed:@"Main_sub" owner:self options:nil][0];
		tuanView.frame = ccr(0, 418 + specialsSize.height + 10, self.view.width, 0);
		tuanView.titleLabel.text = @"团购专区";
		[self.contentScrollView addSubview:tuanView];
		tuansSize = [tuanView updateUIWithData:tuans];

		@weakify(self);
		[[tuanView.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
		    viewController.model =  [BaseObject new];
		    viewController.model.baseTransfer = @"1";
		    [self.navigationController pushViewController:viewController animated:YES];
		}];
	}
	{ // 加载热卖产品
		NSArray *hots = sender[2];
		MainSubView *hotView = [[NSBundle mainBundle] loadNibNamed:@"Main_sub" owner:self options:nil][0];
		hotView.frame = ccr(0, 418 + specialsSize.height + 10 + tuansSize.height + 10, self.view.width, 0);
		hotView.titleLabel.text = @"热卖商品";
		[self.contentScrollView addSubview:hotView];
		hotsSize = [hotView updateUIWithData:hots];

		@weakify(self);
		[[hotView.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
		    viewController.model =  [BaseObject new];
		    viewController.model.baseTransfer = @"2";
		    [self.navigationController pushViewController:viewController animated:YES];
		}];
	}
	{ // 加载推荐产品
		NSArray *recommends = sender[3];
		MainSubView *recommendView = [[NSBundle mainBundle] loadNibNamed:@"Main_sub" owner:self options:nil][0];
		recommendView.frame = ccr(0, 418 + specialsSize.height + 10 + tuansSize.height + hotsSize.height + 10, self.view.width, 0);
		recommendView.titleLabel.text = @"精品推荐";
		[self.contentScrollView addSubview:recommendView];
		recommendsSize = [recommendView updateUIWithData:recommends];

		@weakify(self);
		[[recommendView.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		 subscribeNext: ^(id x) {
		    @strongify(self);
		    BaseViewController *viewController = (BaseViewController *)[self instantiateViewControllerWithStoryboardName:@"MainGroup" identifier:@"group"];
		    viewController.model =  [BaseObject new];
		    viewController.model.baseTransfer = @"3";
		    [self.navigationController pushViewController:viewController animated:YES];
		}];
	}
	[self.contentScrollView setContentSize:ccs(self.view.width, 418 + specialsSize.height + tuansSize.height + hotsSize.height + recommendsSize.height + 20)];

	[XPProgressHUD dismiss];
#if TEST
	NSDate *endTime = [NSDate date];
	double intervalTime = [endTime timeIntervalSinceReferenceDate] - [self.startTime timeIntervalSinceReferenceDate];
	long lTime = (long)intervalTime;
	NSInteger iSeconds = lTime % 60;
	NSInteger iMinutes = (lTime / 60) % 60;
	NSInteger iHours = (lTime / 3600);
	NSInteger iDays = lTime / 60 / 60 / 24;
	NSInteger iMonth = lTime / 60 / 60 / 24 / 12;
	NSInteger iYears = lTime / 60 / 60 / 24 / 384;
	NSString *offset = [NSString stringWithFormat:@"测试：主页初始化接口请求花时%ld分%ld秒（正在自动登陆中，请稍候）", (long)iMinutes, (long)iSeconds];
	self.alertView = [[UIAlertView alloc] initWithTitle:nil message:offset delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
#endif
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

@end
