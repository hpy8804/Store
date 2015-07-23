//
//  ReportViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/5/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ReportViewModel : BaseViewModel

/**
 *  获取产品分类
 *
 *  @return 信号
 */
- (RACSignal *)categories;

/**
 *  获取报单商城列表
 *
 *  @param identifier 用户ID
 *  @param categoryID 分类ID
 *  @param page       页码
 *
 *  @return 信号
 */
- (RACSignal *)reportProductsWithID:(NSString *)identifier categoryID:(NSString *)categoryID page:(NSInteger)page;

/**
 *  生成报单
 *
 *  @param identifier 用户ID
 *  @param addressID  地址ID
 *  @param type       类型  1-直接报单  2-报道中心报单
 *  @param reports    报单数组
 *
 *  @return 信号
 */
- (RACSignal *)createReportWithID:(NSString *)identifier addressID:(NSString *)addressID type:(NSString *)type reports:(NSArray *)reports;

/**
 *  加入报单中心
 *
 *  @param identifier 用户ID
 *  @param addressID  地址ID
 *  @param type       类型  1-直接报单  2-报道中心报单
 *  @param reports    报单数组
 *
 *  @return 信号
 */
- (RACSignal *)addReportCartWithID:(NSString *)identifier addressID:(NSString *)addressID type:(NSString *)type reports:(NSArray *)reports;

/**
 *  我的报单
 *
 *  @param identifier 用户ID
 *  @param page       页码
 *
 *  @return 信号
 */
- (RACSignal *)myReportsWithID:(NSString *)identifier page:(NSInteger)page;

/**
 *  获取历史报单列表
 *
 *  @param type 类型（0-全部、1-已确认、2-未确认）
 *
 *  @return 信号
 */
- (RACSignal *)reportHistoryListWithID:(NSString *)identifier type:(NSString *)type page:(NSInteger)page;

/**
 *  获取报单详情
 *
 *  @param identifier 用户ID
 *  @param analysisID 报单ID
 *
 *  @return 信号
 */
- (RACSignal *)reportDetailWithID:(NSString *)identifier analysisID:(NSString *)analysisID;

@end
