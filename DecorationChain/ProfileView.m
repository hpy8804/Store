//
//  ProfileView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProfileView.h"
#import "ProfileModel.h"

@implementation ProfileView

- (void)awakeFromNib {
	@weakify(self);
	[RACObserve([ProfileModel singleton], wasLogin)
	 subscribeNext: ^(NSNumber *x) {
	    @strongify(self);
	    if (x.boolValue) {  // 登陆成功
	        LoginModel *model = [ProfileModel singleton].model;
	        self.nickLabel.text = model.name;
	        self.scoreLabel.text = model.userPoints;
		}
	}];
}

@end
