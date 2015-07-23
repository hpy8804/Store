//
//  BaseTabBarController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseTabBarController.h"

#import <XPKit/XPKit.h>
#import "ProfileModel.h"

@interface BaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	if ([viewController.title isEqualToString:@"购物车"]) {
		if (![ProfileModel singleton].wasLogin) {
			UIViewController *loginNavigation = [[UIStoryboard storyboardWithName:@"ProfileSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginNavigation"];
			[self presentViewController:loginNavigation animated:YES completion: ^{
			}];
			return NO;
		}
	}
	return YES;
}

@end
