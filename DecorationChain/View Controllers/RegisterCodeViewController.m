//
//  RegisterCodeViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RegisterCodeViewController.h"
#import "RegisterViewModel.h"

@interface RegisterCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet RegisterViewModel *viewModel;

@end

@implementation RegisterCodeViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"注册";

	self.viewModel.codeSignal = self.codeTextField.rac_textSignal;
	RAC(self.submitButton, enabled) = self.viewModel.validSubmitCodeButtonSignal;

	@weakify(self);
	[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    self.submitButton.enabled = NO;
	}] subscribeNext: ^(id x) {
	    @strongify(self);
	    [[self.viewModel validateCodeWithPhone:self.model.baseTransfer code:self.codeTextField.text]
	     subscribeNext: ^(id x) {
	        self.submitButton.enabled = YES;
	        if (x) {
	            [self performSegueWithIdentifier:@"embed_register" sender:self];
			}
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
