//
//  RepasswordCodeViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/7/22.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RepasswordCodeViewController.h"
#import "RepasswordViewModel.h"
#import "XPProgressHUD.h"


@interface RepasswordCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet RepasswordViewModel *viewModel;

@end

@implementation RepasswordCodeViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"忘记密码";

	self.viewModel.codeSignal = self.codeTextField.rac_textSignal;
	RAC(self.submitButton, enabled) = self.viewModel.validSubmitCodeButtonSignal;

	@weakify(self);
	[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    self.submitButton.enabled = NO;
	    [XPProgressHUD showWithStatus:@"加载中"];
	}] subscribeNext: ^(id x) {
	    @strongify(self);
	    [[self.viewModel validateCodeWithPhone:self.model.baseTransfer code:self.codeTextField.text]
	     subscribeNext: ^(id x) {
	        self.submitButton.enabled = YES;
	        if (x) {
	            [self performSegueWithIdentifier:@"embed_register" sender:self];
			}
	        [XPProgressHUD dismiss];
		}];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_register"]) {
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
		viewController.model = [BaseObject new];
		viewController.model.baseTransfer = self.model.baseTransfer;
	}
}

@end
