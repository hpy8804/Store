//
//  ReportHistoryViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportHistoryViewController.h"
#import "ReportViewModel.h"
#import "ReportHistoryListTableViewController.h"

@interface ReportHistoryViewController () <ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation ReportHistoryViewController

#pragma mark - LifeCircle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.dataSource = self;
	self.delegate = self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - ViewPager
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
	return 3;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
	NSArray *buffer = @[@"全部", @"未确认", @"已确认"];
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
	ReportHistoryListTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"list"];
	if (index == 0) {
		viewController.type = @"0";
	}
	else if (index == 1) {
		viewController.type = @"2";
	}
	else {
		viewController.type = @"1";
	}
	return viewController;
}

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
			return 320 / 3.0;

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
