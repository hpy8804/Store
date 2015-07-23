//
//  AlipayInfoModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "JSONModel.h"

@interface AlipayInfoModel : JSONModel

@property NSString *aliPublicKey;
@property NSString *notifyUrl;
@property NSString *partner;
@property NSString *privateKey;
@property NSString *timeOut;
@property NSString *userID;


@end
