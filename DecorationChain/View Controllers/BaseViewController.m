//
//  BaseViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewController.h"
#import <LASIImageView/LASIImageView.h>
#import "XPProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[[LASIImageView sharedProgressAppearance] setType:LProgressTypeCircle];
	[[LASIImageView sharedProgressAppearance] setSchemeColor:[UIColor colorWithRed:0.984 green:0.341 blue:0.353 alpha:1.000]];
	[[LASIImageView sharedRequestSettings] setSecondsToCache:3600 * 12];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];

	[JSONModel setGlobalKeyMapper:[JSONKeyMapper mapperFromUnderscoreCaseToCamelCase]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[XPProgressHUD dismiss];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	self.viewModel.active = NO;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)presentLogin {
	UIViewController *loginNavigation = [[UIStoryboard storyboardWithName:@"ProfileSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginNavigation"];
	[self presentViewController:loginNavigation animated:YES completion: ^{
	}];
}

- (UIViewController *)instantiateInitialViewControllerWithStoryboardName:(NSString *)storyboardName {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
	UIViewController *viewController = [storyboard instantiateInitialViewController];
	return viewController;
}

- (UIViewController *)instantiateViewControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
	UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
	return viewController;
}

@end
