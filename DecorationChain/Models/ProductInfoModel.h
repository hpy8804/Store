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
@property (nonatomic, strong) NSString <Optional> *boiling_point;
@property (nonatomic, strong) NSString <Optional> *brandId;
@property (nonatomic, strong) NSString <Optional> *cas;
@property (nonatomic, strong) NSString <Optional> *categories_id;
@property (nonatomic, strong) NSString <Optional> *create_time;
@property (nonatomic, strong) NSString <Optional> *delivery_way;
@property (nonatomic, strong) NSString <Optional> *description;
@property (nonatomic, strong) NSString <Optional> *distribution;
@property (nonatomic, strong) NSString <Optional> *en_name;
@property (nonatomic, strong) NSString <Optional> *enable_report;
@property (nonatomic, assign) NSInteger enabled;
@property (nonatomic, strong) NSString <Optional> *exact_package;
@property (nonatomic, strong) NSString <Optional> *excerpt;
@property (nonatomic, strong) NSString <Optional> *fixed_quantity;
@property (nonatomic, strong) NSString <Optional> *flash_point;
@property (nonatomic, strong) NSString <Optional> *formula;
@property (nonatomic, strong) NSString <Optional> *free_shipping;
@property (nonatomic, assign) NSInteger good_comment_nums;
@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *images;
@property (nonatomic, strong) NSString <Optional> *is_feature;
@property (nonatomic, strong) NSString <Optional> *is_free;
@property (nonatomic, strong) NSString <Optional> *is_hot;
@property (nonatomic, strong) NSString <Optional> *is_monthhot;
@property (nonatomic, strong) NSString <Optional> *is_new;
@property (nonatomic, strong) NSString <Optional> *is_recommend;
@property (nonatomic, strong) NSString <Optional> *is_special;
@property (nonatomic, strong) NSString <Optional> *is_tuan;
@property (nonatomic, strong) NSString <Optional> *matter;
@property (nonatomic, strong) NSString <Optional> *melting_point;
@property (nonatomic, strong) NSString <Optional> *meta;
@property (nonatomic, strong) NSString <Optional> *molecular;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *number;
@property (nonatomic, strong) NSString <Optional> *price;
@property (nonatomic, strong) NSArray <Optional> *product_attrs;
@property (nonatomic, strong) NSArray <Optional> *product_comments;
@property (nonatomic, strong) NSString <Optional> *product_detail;
@property (nonatomic, strong) NSString <Optional> *product_minutiae;
@property (nonatomic, strong) NSArray <Optional> *product_pictures;
@property (nonatomic, strong) NSString <Optional> *product_scene;
@property (nonatomic, strong) NSString <Optional> *product_size;
@property (nonatomic, strong) NSString <Optional> *product_type;
@property (nonatomic, strong) NSString <Optional> *quantity;
@property (nonatomic, strong) NSString <Optional> *related_products;
@property (nonatomic, strong) NSString <Optional> *route_id;
@property (nonatomic, assign) NSInteger sale_num;
@property (nonatomic, strong) NSString <Optional> *saleprice;
@property (nonatomic, strong) NSString <Optional> *seo_title;
@property (nonatomic, strong) NSString <Optional> *sequence;
@property (nonatomic, strong) NSString <Optional> *shippable;
@property (nonatomic, strong) NSString <Optional> *sku;
@property (nonatomic, strong) NSString <Optional> *slug;
@property (nonatomic, strong) NSString <Optional> *specification;
@property (nonatomic, strong) NSString <Optional> *stock;
@property (nonatomic, strong) NSString <Optional> *store_id;
@property (nonatomic, strong) NSString <Optional> *tags;
@property (nonatomic, strong) NSString <Optional> *taxable;
@property (nonatomic, strong) NSString <Optional> *thickness;
@property (nonatomic, assign) NSInteger total_comments;
@property (nonatomic, strong) NSString <Optional> *track_stock;
@property (nonatomic, strong) NSString <Optional> *vipprice;
@property (nonatomic, strong) NSString <Optional> *weight;
@property (nonatomic, assign) NSInteger well_comment_nums;
@property (nonatomic, strong) NSArray <Optional> *product_items;
@end
