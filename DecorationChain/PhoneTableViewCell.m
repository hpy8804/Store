//
//  PhoneTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "PhoneTableViewCell.h"
#import "ProfileModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PhoneTableViewCell

- (void)awakeFromNib {
	LoginModel *model = [ProfileModel singleton].model;
	RAC(self.phoneTextField, text) = RACObserve(model, telephone);
}

@end
