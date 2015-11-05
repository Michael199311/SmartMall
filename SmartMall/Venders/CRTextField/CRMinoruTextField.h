//
//  CRMinoruTextField.h
//  CarRental
//
//  Created by 王健功 on 15/9/23.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//  编辑时，整个textField的边框变色

#import "CRTextFieldFormat.h"

@interface CRMinoruTextField : CRTextFieldFormat

@property (strong, nonatomic) IBInspectable UIColor *borderActiveColor;/**<编辑状态边框颜色*/
@property (strong, nonatomic) IBInspectable UIColor *textBackground;/**<文字输入部分的背景色*/
@property (strong, nonatomic) IBInspectable UIImage *textBackgroundImage;/**<文字输入部分背景图片*/

@end
