//
//  MainSubView.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseView.h"

@interface MainSubView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

- (CGSize)updateUIWithData:(NSArray *)data;

@end
