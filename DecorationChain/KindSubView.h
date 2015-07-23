//
//  KindSubView.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseView.h"
#import "KindSubModel.h"

@interface KindSubView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *titleView;

- (CGSize)updateWithModel:(KindSubModel *)model;

@end
