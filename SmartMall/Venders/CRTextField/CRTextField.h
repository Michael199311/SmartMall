//
//  CRTextField.h
//  CRTextField
//
//  Created by 王健功 on 15/8/10.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//  继承与UITextField，并对其做了一些修改，主要用于修改leftView，placeHoledr颜色，字体等

#import <UIKit/UIKit.h>

IB_DESIGNABLE //让drawView代码体现在IB中

@interface CRTextField : UITextField

/**
 *  标题区域
 */
@property (strong, nonatomic) UIView *titleView;
/**
 *  修改placeholder颜色
 */
@property (strong, nonatomic) IBInspectable UIColor *placeholderColor;
/**
 *  是否显示自定义clear button 默认为NO
 */
@property (assign, nonatomic) IBInspectable BOOL showCustomClear;
/**
 *  修改placeholder的字体
 */
@property (strong, nonatomic) UIFont *placeholderFont;


@end
