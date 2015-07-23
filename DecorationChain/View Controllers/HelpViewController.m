//
//  HelpViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.webView loadWebsite:@"http://www.baidu.com"];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
