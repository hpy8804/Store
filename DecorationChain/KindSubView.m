//
//  KindSubView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "KindSubView.h"
#import "KindSubProductView.h"

#import "KindSubModel.h"

#import <XPKit/XPKit.h>

@implementation KindSubView

- (CGSize)updateWithModel:(KindSubModel *)model {
	self.titleView.text = model.name;
	NSInteger count = model.children.count;
	for (NSInteger i = 0; i < count; i++) {
		KindSubProductModel *subModel = model.children[i];
		KindSubProductView *productView = [[[NSBundle mainBundle] loadNibNamed:@"Kind_sub" owner:self options:nil] lastObject];
		productView.frame = ccr(5 + (i % 3 * 105), 37 + (i / 3) * 129, 100, 124);
		[productView updateWithModel:subModel];
		[self addSubview:productView];
	}

	NSInteger line = 0;
	if (count % 3 == 0) {
		line = count / 3;
	}
	else {
		line = count / 3 + 1;
	}
	self.height = 37 + line * 129;
	return ccs(self.width, self.height);
}

@end
