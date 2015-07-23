//
//  BaseView.h
//  DecorationChain
//
//  Created by huangxinping on 15/1/31.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoaLayout/ReactiveCocoaLayout.h>
#import <Masonry/Masonry.h>
#import <NSObject+AssociatedDictionary/NSObject+AssociatedDictionary.h>

/*

   #import <NSObject+AssociatedDictionary.h>
   :
   UIButton *deleteButton;
   UITextField *accountField;
   :
   deleteButton.properties[@"confirmationMessage"] = @"Are you sure you want to do this?";
   accountField.properties[@"inputMask"] = @"99-99999-9";
   accountField.properties[@"required"]  = @YES;

   if (!accountField.hasText && [accountField.properties[@"required"] boolValue]) {
       accountField.backgroundColor = accountField.properties[@"alertColor"];
       [self alert:accountField.properties[@"alertMessage"]];
   }

   例子：https://github.com/markiv/NSObject-AssociatedDictionary/blob/master/screenshot1.png

 */

@interface BaseView : UIView

@end
