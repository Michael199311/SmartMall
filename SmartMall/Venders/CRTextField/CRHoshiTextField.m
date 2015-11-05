//
//  CRHoshiTextField.m
//  CRTextField
//
//  Created by 王健功 on 15/8/6.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "CRHoshiTextField.h"
/**
 *  活跃状态和非活跃状态的边框厚度
 */
struct CRBorderThickness {
	CGFloat inactive;
	CGFloat active;
};
typedef struct CRBorderThickness CRBorderThickness;

@interface CRHoshiTextField ()

@property (strong, nonatomic) CALayer *inactiveBorderLayer;/**<未编辑状态边框*/
@property (strong, nonatomic) CALayer *activeBorderLayer;/**<编辑状态边框*/
@property (assign, nonatomic) CRBorderThickness borderThickness;
@end

@implementation CRHoshiTextField

- (void)dealloc
{
	NSLog(@"dealloc------>%@",[self class]);
	_inactiveBorderLayer = nil;
	_activeBorderLayer = nil;
	_borderActiveColor = nil;
	_borderInactiveColor = nil;
}


- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	[self updateBorder];
	[self.layer addSublayer:self.inactiveBorderLayer];
	[self.layer addSublayer:self.activeBorderLayer];
}

#pragma mark - publick method
- (void)animateViewsForTextEntry
{
	//编辑时，是为活跃状态
	self.activeBorderLayer.frame = [self rectForBorder:self.borderThickness.active isFill:true];
}

- (void)animateViewsForTextDisplay
{
	//停止编辑时，如果当前输入为nil，视为非活跃状态，如果有输入文本视为活跃状态
	if (self.text.length == 0 || !self.text) {
		self.activeBorderLayer.frame = [self rectForBorder:self.borderThickness.active isFill:false];//隐藏
	}
}

#pragma mark - private method
/**
 *  更新边框颜色
 */
- (void)updateBorder
{
	//设置默认显示非活跃状态
	self.inactiveBorderLayer.frame = [self rectForBorder:self.borderThickness.inactive isFill:true];
	self.activeBorderLayer.frame = [self rectForBorder:self.borderThickness.active isFill:false];
}


/**
 *  计算border的rect
 *
 *  @param thickness 高度，目前分为活跃和非活跃状态高度
 *  @param isFill    是否铺满，false,宽度为0，不显示
 */
- (CGRect)rectForBorder:(CGFloat)thickness isFill:(BOOL)isFill
{
	NSLog(@"%@",NSStringFromCGRect(self.bounds));
	CGRect rect = [self textRectForBounds:self.bounds];
	if (isFill) {
		return CGRectMake(CGRectGetMinX(rect), CGRectGetHeight(rect) - thickness, CGRectGetWidth(self.frame), thickness);
	}else{
		return CGRectMake(CGRectGetMinX(rect), CGRectGetHeight(rect) - thickness, 0, thickness);
	}
}

#pragma mark - getters and setters
- (CRBorderThickness)borderThickness
{
	_borderThickness.inactive = 0.5;//非活跃状态高度
	_borderThickness.active = 2;//活跃状态
	return _borderThickness;
}

- (CALayer *)inactiveBorderLayer
{
	if (!_inactiveBorderLayer) {
		_inactiveBorderLayer = [CALayer layer];
	}
	return _inactiveBorderLayer;
}

- (CALayer *)activeBorderLayer
{
	if (!_activeBorderLayer) {
		_activeBorderLayer = [CALayer layer];
	}
	return _activeBorderLayer;
}

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor
{
	_borderInactiveColor = borderInactiveColor;
	self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor.CGColor;
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor
{
	_borderActiveColor = borderActiveColor;
	self.activeBorderLayer.backgroundColor = self.borderActiveColor.CGColor;
}

@end
