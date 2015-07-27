//
//  RootTopTableViewCell.m
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "RootTopTableViewCell.h"

@implementation RootTopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handleShowCategory:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择类型" delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"CAS", @"中文", @"英文", @"分子式", nil];
    [actionSheet showInView:self];
}

- (IBAction)handleSearchAction:(id)sender {
    NSString *strCategory = self.categoryButton.titleLabel.text;
    NSString *strKeyWord = self.keyWordTextField.text;
    if (_showSearchResult) {
        _showSearchResult(strCategory, strKeyWord);
    }
}

- (IBAction)handleShowMore:(id)sender {
    if (_showMoreProduct) {
        _showMoreProduct();
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self.categoryButton setTitle:@"CAS" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [self.categoryButton setTitle:@"中文" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            [self.categoryButton setTitle:@"英文" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [self.categoryButton setTitle:@"分子式" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

@end
