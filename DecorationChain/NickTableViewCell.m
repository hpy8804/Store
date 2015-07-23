//
//  NickTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "NickTableViewCell.h"
#import "ProfileModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation NickTableViewCell

- (void)awakeFromNib {
	LoginModel *model = [ProfileModel singleton].model;
	RAC(self.nickTextField, text) = RACObserve(model, name);
}

@end
