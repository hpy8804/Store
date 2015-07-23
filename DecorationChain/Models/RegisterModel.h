//
//  RegisterModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface RegisterAndSendModel : BaseObject

@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *code;

@end

@interface RegisterAndValidateModel : BaseObject

@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *code;

@end

@interface RegisterModel : BaseObject

@property (nonatomic, strong) NSString <Optional> *birthday;
@property (nonatomic, strong) NSString *businessCertificatePic;
@property (nonatomic, strong) NSString <Optional> *comEnviromentPic;
@property (nonatomic, strong) NSString <Optional> *comScale;
@property (nonatomic, strong) NSString <Optional> *comUrl;
@property (nonatomic, strong) NSString <Optional> *defaultAddressId;
@property (nonatomic, strong) NSString <Optional> *email;
@property (nonatomic, strong) NSString <Optional> *homephone;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString <Optional> *lastloginTime;
@property (nonatomic, strong) NSString <Optional> *msn;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString <Optional> *officephone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *payedMoney;
@property (nonatomic, strong) NSString *payedPoints;
@property (nonatomic, strong) NSString <Optional> *personPic;
@property (nonatomic, strong) NSString <Optional> *qq;
@property (nonatomic, strong) NSString *rankPoints;
@property (nonatomic, strong) NSString <Optional> *registerTime;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString <Optional> *type;
@property (nonatomic, strong) NSString <Optional> *updateTime;
@property (nonatomic, strong) NSString *userMoney;
@property (nonatomic, strong) NSString *userPoints;
@property (nonatomic, strong) NSString <Optional> *username;
@property (nonatomic, strong) NSString <Optional> *vipEndTime;
@property (nonatomic, strong) NSString <Optional> *vipStartTime;

@end
