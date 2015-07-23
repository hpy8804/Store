//
//  SplashViewController.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "SplashViewController.h"
#import "SplashViewModel.h"

#import "NSString+imageurl.h"

@interface SplashViewController ()

@property (strong, nonatomic) IBOutlet SplashViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *welcomImageView;

@end

@implementation SplashViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	NSString *localPath = [[NSFileManager documentsDirectory] stringByAppendingPathComponent:@"/welcome.jpg"];
	if ([NSFileManager fileExistsAtPath:localPath]) {
		self.welcomImageView.image = [UIImage imageWithContentsOfFile:localPath];
	}

	@weakify(self);
	[[self.viewModel welcome]
	 subscribeNext: ^(id x) {
	    dispatch_async(dispatch_get_main_queue(), ^{
			NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[x fullImageURL]]];
			[data writeToFile:localPath atomically:YES];
		});
	}];

	[NSTimer scheduledTimerWithTimeInterval:1 block: ^{
	    @strongify(self);
	    [self performSegueWithIdentifier:@"embed_root" sender:self];
	} repeats:NO];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
