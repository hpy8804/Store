//
//  LogisticsRuleViewController.m
//  DecorationChain
//
//  Created by huangxinping on 5/13/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "LogisticsRuleViewController.h"
#import "XPProgressHUD.h"
#import <XPKit/UIWebView+XPKit.h>
#import <BlocksKit/UIWebView+BlocksKit.h>

@interface LogisticsRuleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LogisticsRuleViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[XPProgressHUD showWithStatus:@"加载中"];
	[self.webView loadWebsite:@"http://27.54.252.32/zjb/admin/news/shipment"];
	[self.webView bk_setDidFinishLoadBlock: ^(UIWebView *webView) {
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
