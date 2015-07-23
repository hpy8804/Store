//
//  AdInfoViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "AdInfoViewController.h"
#import <XPKit/UIWebView+XPKit.h>
#import <BlocksKit/UIWebView+BlocksKit.h>
#import "XPProgressHUD.h"

@interface AdInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AdInfoViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = self.model.identifier;

	[XPProgressHUD showWithStatus:@"加载中"];
	[self.webView loadWebsite:self.model.baseTransfer];
	[self.webView bk_setDidFinishLoadBlock: ^(UIWebView *webView) {
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
