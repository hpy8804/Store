//
//  AvatarTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "AvatarTableViewCell.h"
#import "ProfileModel.h"

#import "NSString+imageurl.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <XPKit/XPKit.h>

@implementation AvatarTableViewCell

- (void)awakeFromNib {
	@weakify(self);
	[[RACObserve([ProfileModel singleton].model, personPic) distinctUntilChanged]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    if (x) {
	        LoginModel *model = [ProfileModel singleton].model;
	        [self.avatarImageView setImageUrl:[model.personPic fullImageURL]];
		}
	}];
    [self.avatarImageView setCornerRadius:18];
}

@end
