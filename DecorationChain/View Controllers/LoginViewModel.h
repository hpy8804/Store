//
//  LoginViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel {
}
@property (nonatomic, strong) RACSignal *validUserSignal;
@property (nonatomic, strong) RACSignal *validPasswordSignal;
@property (nonatomic, strong) RACSignal *signInButtonEnableSignal;
@property (nonatomic, strong) RACSignal *usernameBackgroundColorSignal;
@property (nonatomic, strong) RACSignal *passwordBackgroundColorSignal;

- (RACSignal *)signInSignal:(NSString *)userName password:(NSString *)password;

@end
