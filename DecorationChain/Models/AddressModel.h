//
//  AddressModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface AddressModel : BaseObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString <Optional> *city;
@property (nonatomic, strong) NSString <Optional> *cityid;
@property (nonatomic, strong) NSString <Optional> *district;
@property (nonatomic, strong) NSString <Optional> *districtid;
@property (nonatomic, strong) NSString <Optional> *email;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *isDefault;
@property (nonatomic, strong) NSString <Optional> *mobTelephone;
@property (nonatomic, strong) NSString <Optional> *province;
@property (nonatomic, strong) NSString <Optional> *provinceid;
@property (nonatomic, strong) NSString *recipientsName;
@property (nonatomic, strong) NSString <Optional> *signBuilding;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString <Optional> *zipcode;

@end
