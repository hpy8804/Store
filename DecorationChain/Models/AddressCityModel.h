//
//  AddressCityModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface AddressCityModel : BaseObject

@property NSObject <Optional> *DateCreated;
@property NSObject <Optional> *DateUpdated;
@property NSString *id;
@property NSString *name;
@property NSString *provinceid;
@property NSString *zipcode;

@end
