//
//  XPADView.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseView.h"

@interface XPADView : BaseView

@property (weak, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

/**
 *  更新UI根据数组
 *
 *  @param items 数组
 */
- (void)uploadUI:(NSArray *)items;

@end
