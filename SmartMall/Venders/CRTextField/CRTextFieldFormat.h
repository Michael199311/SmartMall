//
//  CRTextFieldEffects.h
//  CRTextField
//
//  Created by 王健功 on 15/8/6.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//  封装了UITextField，增加了自动验证功能，预先用正则表达式输入需要认证的格式。
//  如果用户输入不符合正则表达式，提示输入错误

#import "CRTextField.h"

@interface CRTextFieldFormat : CRTextField


@property (strong, nonatomic) IBInspectable NSString *errorMessage;/**<错误提示消息*/
@property (strong, nonatomic) NSString *isValidate;/**<YES,表示当前用户输入符合要求*/
@property (assign, nonatomic) BOOL validateOnChange;/**<是否需要实时认证,YES表示输入过程中就需要认证。默认NO*/
@property (assign, nonatomic) IBInspectable BOOL isMandatory;/**<是否强制输入，YES，表示内容不能为空。默认NO*/

@property (assign, nonatomic) IBInspectable NSInteger maxLength;/**<设置最大输入文本长度.默认无限大*/
@property (strong, nonatomic) IBInspectable NSString *pattern;/**<正则表达式字符串，记录用户输入需要遵循的格式。如果格式不正确,isValidate返回NO.默认为nil*/

/**
 *  编辑开始时执行的一些动画,需要在子类中重写
 */
- (void)animateViewsForTextEntry;
/**
 *  编辑结束是执行的一些动画,需要在子类中重写
 */
- (void)animateViewsForTextDisplay;
/**
 *  显示/移除错误提示
 */
- (void)showErrorAlert;
- (void)removeErrorAlert;
@end
