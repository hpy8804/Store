//
//  ProductInfoMoreTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 4/6/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProductInfoMoreTableViewCell.h"
#import "UILabel+MarkupExtensions.h"
#import <Masonry/Masonry.h>

@interface ProductInfoMoreTableViewCell () <UIWebViewDelegate>


@end

@implementation ProductInfoMoreTableViewCell

- (void)awakeFromNib {
	self.infoWebView.delegate = self;
	self.infoWebView.hidden = YES;
	[self.infoLabel setText:@"点击查看详情"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

#pragma mark - UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[webView scalesPageToFit];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// 获取网页宽度
	CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"] floatValue];
	// 计算缩放后的系数
	CGFloat radio = webView.bounds.size.width / width;
	// 计算缩放后的高度
	self.height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue] * radio;

	//Disable bouncing in webview
	for (id subview in webView.subviews) {
		if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
			[subview setBounces:NO];
		}
	}
	[webView setUserInteractionEnabled:NO];
}

- (void)updateUIWithContent:(NSString *)htmlString {
	[self.infoWebView loadHTMLString:htmlString baseURL:nil];
}

- (void)expandUI {
	self.infoLabel.hidden = YES;
	self.infoWebView.hidden = NO;
}

@end
