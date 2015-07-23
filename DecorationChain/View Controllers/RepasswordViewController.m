//
//  RepasswordViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/7/22.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RepasswordViewController.h"
#import "RepasswordViewModel.h"

#import <JKCountDownButton/JKCountDownButton.h>

@interface RepasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeButton;
@property (strong, nonatomic) IBOutlet RepasswordViewModel *viewModel;

@end

@implementation RepasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"忘记密码";

	self.viewModel.mobileSignal = self.mobileTextField.rac_textSignal;
	RAC(self.getCodeButton, enabled) = self.viewModel.validCodeButtonSignal;
	@weakify(self);
	[[[self.getCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    self.getCodeButton.enabled = NO;
	    [self.getCodeButton startWithSecond:5];
	    [self.getCodeButton didChange: ^NSString *(JKCountDownButton *countDownButton, int second) {
	        NSString *title = [NSString stringWithFormat:@"剩余%d秒", second];
	        return title;
		}];
	    [self.getCodeButton didFinished: ^NSString *(JKCountDownButton *countDownButton, int second) {
	        countDownButton.enabled = YES;
	        return @"获取验证码";
		}];
	}] subscribeNext: ^(id x) {
	    @strongify(self);
	    [[self.viewModel sendCodeWithPhone:self.mobileTextField.text] subscribeNext: ^(id x) {
	        [XPToast showWithText:@"请注意查收短信"];
		}];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_validate"]) {
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
		viewController.model = [BaseObject new];
		viewController.model.baseTransfer = self.mobileTextField.text;
	}
}

@end
