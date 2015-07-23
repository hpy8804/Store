//
//  EmailTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "EmailTableViewCell.h"
#import "ProfileModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation EmailTableViewCell

- (void)awakeFromNib {
	LoginModel *model = [ProfileModel singleton].model;
	RAC(self.mailTextField, text) = RACObserve(model, email);
}

@end
