//
//  MainSubView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MainSubView.h"
#import "MainSubProductView.h"

@implementation MainSubView

- (CGSize)updateUIWithData:(NSArray *)data {
	NSInteger count = data.count;
	for (NSInteger i = 0; i < count; i++) {
		MainSubProductView *productView = [[NSBundle mainBundle] loadNibNamed:@"Main_sub" owner:self options:nil][1];
		productView.frame = ccr(5 + (i % 2 * 157), 60 + 5 + (i / 2) * 255, 152, 250);
		[self addSubview:productView];
		[productView updateWithModel:data[i]];
	}
	NSInteger line = 0;
	if (count % 2 == 0) {
		line = count / 2;
	}
	else {
		line = count / 2 + 1;
	}
	self.height = 60 + 5 + line * 255;
	return ccs(self.width, self.height);
}

@end
