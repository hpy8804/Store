//
//  MyOrderViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderListViewController.h"

@implementation MyOrderBaseViewController


@end

@interface MyOrderViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.dataSource = self;
	self.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
	return 5;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
	NSArray *buffer = @[@"未付款", @"已付款", @"发货中", @"待评价", @"已完成"];
	UILabel *label = [UILabel new];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:12.0];
	label.text = buffer[index];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor blackColor];
	[label sizeToFit];
	return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
	OrderListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"list"];
	viewController.model = [BaseObject new];
	viewController.model.baseTransfer = [NSString stringWithFormat:@"%lu", (unsigned long)index + 1];
	return viewController;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
	switch (option) {
		case ViewPagerOptionStartFromSecondTab:
			return 0.0;

		case ViewPagerOptionCenterCurrentTab:
			return 1.0;

		case ViewPagerOptionTabLocation:
			return 1.0;

		case ViewPagerOptionTabHeight:
			return 49.0;

		case ViewPagerOptionTabOffset:
			return 44.0;

		case ViewPagerOptionTabWidth:
			return 64.0;

		case ViewPagerOptionFixFormerTabsPositions:
			return 0.0;

		case ViewPagerOptionFixLatterTabsPositions:
			return 0.0;

		default:
			return value;
	}
	return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
	switch (component) {
		case ViewPagerIndicator:
			return [[UIColor redColor] colorWithAlphaComponent:0.64];

		case ViewPagerTabsView:
			return [UIColor whiteColor];

		case ViewPagerContent:
			return [UIColor whiteColor];

		default:
			return color;
	}
}

@end
