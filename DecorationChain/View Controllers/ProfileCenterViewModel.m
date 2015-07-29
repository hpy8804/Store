//
//  ProfileCenterViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProfileCenterViewModel.h"

#import <XPToast/XPToast.h>
#import "NSDictionary+fill_deviceinfo.h"
#import "ProfileModel.h"

@implementation ProfileCenterViewModel


- (RACSignal *)updateProfileWithID:(NSString *)identifier name:(NSString *)name email:(NSString *)email telephone:(NSString *)telephone avatarURL:(NSString *)avatarURL {
	NSMutableDictionary *parameters = [@{ @"id":identifier } mutableCopy];
	if (name) {
		[parameters setObject:name forKey:@"name"];
	}
	if (email) {
		[parameters setObject:email forKey:@"email"];
	}
	if (telephone) {
		[parameters setObject:telephone forKey:@"telephone"];
	}
	if (avatarURL && ![avatarURL isEqualToString:@""]) {
		[parameters setObject:avatarURL forKey:@"person_pic"];
	}
	return [[[self rac_GET:@"http://122.114.61.234/app/api/account_edit"
	            parameters  :[parameters fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)updateAvatarWithID:(NSString *)identifier image:(UIImage *)image {
	return [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
	    NSData *data = UIImageJPEGRepresentation(image, 0.5f);
	    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	    [manager POST:@"http://122.114.61.234/app /api/video_upload" parameters:nil constructingBodyWithBlock: ^(id formData) {
	        [formData appendPartWithFileData:data name:@"loadfile" fileName:@"1.jpg" mimeType:@"image/jpeg"];
		} success: ^(AFHTTPRequestOperation *operation, id responseObject) {
	        [ProfileModel singleton].model.personPic = responseObject[@"data"][@"filepath"];
	        [subscriber sendNext:@(1)];
	        [subscriber sendCompleted];
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	        [XPToast showWithText:@"头像上传失败"];
	        [subscriber sendNext:@(0)];
	        [subscriber sendCompleted];
	        NSLog(@"%@", error);
		}];
	    return [RACDisposable disposableWithBlock: ^{
		}];
	}];
}

@end
