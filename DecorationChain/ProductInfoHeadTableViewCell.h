//
//  ProductInfoHeadTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPADView.h"
#import "ProductInfoModel.h"

@interface ProductInfoHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCAS;
@property (weak, nonatomic) IBOutlet UILabel *labelName2;
@property (weak, nonatomic) IBOutlet UILabel *labelEnName;
@property (weak, nonatomic) IBOutlet UILabel *labelFormula;
@property (weak, nonatomic) IBOutlet UILabel *labelMolecular;
@property (weak, nonatomic) IBOutlet UILabel *labelBoil;
@property (weak, nonatomic) IBOutlet UILabel *labelFlash;
@property (weak, nonatomic) IBOutlet UILabel *labelPhysical;

- (void)updateUIWithModel:(ProductInfoModel*)infoModel;

@end
