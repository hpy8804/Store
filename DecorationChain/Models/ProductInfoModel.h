//
//  ProductInfoModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

#pragma mark - 评论
@protocol ProductInfoCommentModel
@end
@interface ProductInfoCommentModel : BaseObject

@property NSString <Optional> *accountId;
@property NSString <Optional> *accountName;
@property NSString <Optional> *commentClass;
@property NSString <Optional> *content;
@property NSString <Optional> *id;
@property NSString <Optional> *ip;
@property NSString <Optional> *isGood;
@property NSString <Optional> *isShow;
@property NSString <Optional> *postTime;
@property NSString <Optional> *productId;
@property NSString <Optional> *score;

@end

#pragma mark - 属性详情
@protocol ProductInfoAttributeDetailModel
@end
@interface ProductInfoAttributeDetailModel : BaseObject

@property (nonatomic, strong) NSString <Optional> *attrPrice;
@property (nonatomic, strong) NSString <Optional> *attrValue;

@end

#pragma mark - 属性
@protocol ProductInfoAttributeModel
@end
@interface ProductInfoAttributeModel : BaseObject

@property (nonatomic, strong) NSArray <ProductInfoAttributeDetailModel, Optional> *attrDetail;
@property (nonatomic, strong) NSString <Optional> *attrId;
@property (nonatomic, strong) NSString <Optional> *attrName;
@property (nonatomic, strong) NSString <Optional> *attrType;
@property (nonatomic, strong) NSString <Optional> *attrTypeName;

@end

#pragma mark - 图片信息
@protocol ProductInfoPictureModel
@end
@interface ProductInfoPictureModel : BaseObject

@property (nonatomic, strong) NSString <Optional> *isPrimary;
@property (nonatomic, strong) NSString <Optional> *productId;
@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *alt;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *url;

@end

#pragma mark - 商品详情
@interface ProductInfoModel : BaseObject <NSCopying>

@property (nonatomic, strong) NSString <Optional> *afterSales;
@property (nonatomic, assign) NSInteger badCommentNums;
@property (nonatomic, strong) NSString <Optional> *baseInfo;
@property (nonatomic, strong) NSString <Optional> *brandId;
@property (nonatomic, strong) NSString <Optional> *categoriesId;
@property (nonatomic, strong) NSString <Optional> *createTime;
@property (nonatomic, strong) NSString <Optional> *deliveryWay;
@property (nonatomic, strong) NSString <Optional> *self_description;
@property (nonatomic, strong) NSString <Optional> *distribution;
@property (nonatomic, strong) NSString <Optional> *enableReport;
@property (nonatomic, strong) NSString <Optional> *enabled;
@property (nonatomic, strong) NSString <Optional> *exactPackage;
@property (nonatomic, strong) NSString <Optional> *excerpt;
@property (nonatomic, strong) NSString <Optional> *fixedQuantity;
@property (nonatomic, strong) NSString <Optional> *freeShipping;
@property (nonatomic, assign) NSInteger goodCommentNums;
@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *images;
@property (nonatomic, strong) NSString <Optional> *isFeature;
@property (nonatomic, strong) NSString <Optional> *isFree;
@property (nonatomic, strong) NSString <Optional> *isHot;
@property (nonatomic, strong) NSString <Optional> *isMonthhot;
@property (nonatomic, strong) NSString <Optional> *isNew;
@property (nonatomic, strong) NSString <Optional> *isRecommend;
@property (nonatomic, strong) NSString <Optional> *isSpecial;
@property (nonatomic, strong) NSString <Optional> *isTuan;
@property (nonatomic, strong) NSString <Optional> *meta;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *number;
@property (nonatomic, strong) NSString <Optional> *price;
@property (nonatomic, strong) NSArray <ProductInfoAttributeModel, Optional> *productAttrs;
@property (nonatomic, strong) NSArray <ProductInfoCommentModel, Optional> *productComments;
@property (nonatomic, strong) NSString <Optional> *productDetail;
@property (nonatomic, strong) NSString <Optional> *productMinutiae;
@property (nonatomic, strong) NSArray <ProductInfoPictureModel, Optional> *productPictures;
@property (nonatomic, strong) NSString <Optional> *productScene;
@property (nonatomic, strong) NSString <Optional> *productSize;
@property (nonatomic, strong) NSString <Optional> *productType;
@property (nonatomic, strong) NSString <Optional> *quantity;
@property (nonatomic, strong) NSString <Optional> *relatedProducts;
@property (nonatomic, strong) NSString <Optional> *routeId;
@property (nonatomic, strong) NSString <Optional> *saleNum;
@property (nonatomic, strong) NSString <Optional> *saleprice;
@property (nonatomic, strong) NSString <Optional> *seoTitle;
@property (nonatomic, strong) NSString <Optional> *sequence;
@property (nonatomic, strong) NSString <Optional> *shippable;
@property (nonatomic, strong) NSString <Optional> *sku;
@property (nonatomic, strong) NSString <Optional> *slug;
@property (nonatomic, strong) NSString <Optional> *specification;
@property (nonatomic, strong) NSString <Optional> *stock;
@property (nonatomic, strong) NSString <Optional> *storeId;
@property (nonatomic, strong) NSString <Optional> *tags;
@property (nonatomic, strong) NSString <Optional> *taxable;
@property (nonatomic, assign) NSInteger totalComments;
@property (nonatomic, strong) NSString <Optional> *trackStock;
@property (nonatomic, strong) NSString <Optional> *vipprice;
@property (nonatomic, strong) NSString <Optional> *weight;
@property (nonatomic, assign) NSInteger wellCommentNums;

@end
