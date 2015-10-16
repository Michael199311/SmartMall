//
//  NSString+Additions.h
//  CarRentalStaff
//
//  Created by Nathan on 11/29/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (Additions)

/**
 *  string transform date
 *
 */
- (NSDate *)stringToDateWithFormat:(NSString *)dateFormat;
/**
 *  NSString UTF-8转码
 *
 *  @return 转成UTF-8的NSString 对象
 */
- (NSString *)encodeUrlString;
/**
 *  非空字符串
 *
 *  @param string string
 *
 *  @return 是否为空
 */
+ (BOOL) isNotEmptyString:(NSString *)string;
/**
 *  将null,nil的string转换成@""，这个主要是对后台返回的数据进行NULL检测
 *  如果检测NULL,有可能会crash
 */
+ (NSString *)validateString:(NSString *)string;
/**
 *  根据宽度，字体获取字符串对应显示的高度
 *
 *  @param value 需要显示的内容
 *  @param font  字体font
 *  @param width 指定宽度
 *
 *  @return 高度
 */
+ (CGFloat)heightForString:(NSString *)value font:(UIFont*)font andWidth:(float)width;
@end
