//
//  CRHoshiTextField.h
//  CRTextField
//
//  Created by 王健功 on 15/8/6.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//  封装了CRTextFieldFormat,增加了底部边框。用不同的底部边框颜色提示用户当前操作的状态

#import "CRTextFieldFormat.h"

@interface CRHoshiTextField : CRTextFieldFormat

@property (strong, nonatomic) IBInspectable UIColor *borderInactiveColor;/**<未编辑状态边框颜色*/
@property (strong, nonatomic) IBInspectable UIColor *borderActiveColor;/**<编辑状态边框颜色*/

@end
