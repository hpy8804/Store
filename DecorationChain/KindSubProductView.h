//
//  KindSubProductView.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseView.h"
#import <LASIImageView/LASIImageView.h>
#import "KindSubModel.h"

@interface KindSubProductView : BaseView

@property (weak, nonatomic) IBOutlet LASIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)updateWithModel:(KindSubProductModel *)model;

@end
