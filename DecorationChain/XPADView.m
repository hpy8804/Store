//
//  XPADView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "XPADView.h"
#import "AdsItemModel.h"
#import "NSString+imageurl.h"
#import <LASIImageView/LASIImageView.h>
#import <A2StoryboardSegueContext/A2StoryboardSegueContext.h>

@interface XPADView ()
{
	NSArray *Arr;
	int TimeNum;
	BOOL Tend;
}
@end

@implementation XPADView

- (void)awakeFromNib {
}

#pragma mark - 5秒换图片
- (void)handleTimer:(NSTimer *)timer {
	if (TimeNum % 5 == 0) {
		if (!Tend) {
			self.pageControl.currentPage++;
			if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
				Tend = YES;
			}
		}
		else {
			self.pageControl.currentPage--;
			if (self.pageControl.currentPage == 0) {
				Tend = NO;
			}
		}

		[UIView animateWithDuration:0.7 //速度0.7秒
		                 animations: ^{//修改坐标
		    self.adScrollView.contentOffset = CGPointMake(self.pageControl.currentPage * 320, 0);
		}];
	}
	TimeNum++;
}

- (void)Action {
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	self.pageControl.currentPage = scrollView.contentOffset.x / 320;
}

- (void)uploadUI:(NSArray *)items {
	for (NSInteger i = 0; i < items.count; i++) {
		AdsItemModel *model = items[i];
		LASIImageView *imageView = [[LASIImageView alloc] initWithFrame:ccr(0 + i * 320, 0, 320, self.height)];
		[imageView setImageUrl:[model.logo fullImageURL]];
		[self.adScrollView addSubview:imageView];
		@weakify(self);
		[imageView whenTapped: ^{
		    @strongify(self);
		    [self adInfoClicked:model.url name:model.name];
		}];
	}
	[self.adScrollView setContentSize:ccs(320 * items.count, self.height)];

	self.pageControl.numberOfPages = items.count;
	[self.pageControl bringToFront];

	if (items.count > 1) {
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	}
}

#pragma mark - AdInfo
- (void)adInfoClicked:(NSString *)url name:(NSString *)name {
	if (!url || !name) {
		return;
	}
	UIViewController *viewController = [self belongViewController];
	[viewController performSegueWithIdentifier:@"embed_ad_info" sender:url context:name];
}

@end
