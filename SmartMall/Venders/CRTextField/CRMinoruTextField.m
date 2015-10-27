//
//  CRMinoruTextField.m
//  CarRental
//
//  Created by 王健功 on 15/9/23.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "CRMinoruTextField.h"

@interface CRMinoruTextField ()

@property (strong, nonatomic) CALayer *activeBorderLayer;/**< 编辑状态边框 */
@property (strong, nonatomic) UIImageView *textBackgroundImageView;/**<文本输入部分的图片背景*/
@end

@implementation CRMinoruTextField

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	[self updateBorder];
	[self updateTextBackgroundImageView];
	[self.layer addSublayer:self.activeBorderLayer];
}

#pragma mark - public method
- (void)animateViewsForTextEntry
{
	//编辑时，是为活跃状态
	if (self.textBackgroundImage) {
		CALayer *imageViewLayer = self.textBackgroundImageView.layer;
		imageViewLayer.borderColor = self.borderActiveColor.CGColor;
		imageViewLayer.shadowOffset = CGSizeZero;
		imageViewLayer.borderWidth = 1.0f;
	}else{
		self.activeBorderLayer.borderColor = self.borderActiveColor.CGColor;
		self.activeBorderLayer.shadowOffset = CGSizeZero;
		self.activeBorderLayer.borderWidth = 1.0f;
	}
}

- (void)animateViewsForTextDisplay
{
	//停止编辑时
	if (self.textBackgroundImage) {
		CALayer *imageViewLayer = self.textBackgroundImageView.layer;
		imageViewLayer.borderColor = self.textBackground.CGColor;
		imageViewLayer.shadowOffset = CGSizeZero;
		imageViewLayer.borderWidth = 1.0f;
	}else{
		self.activeBorderLayer.borderColor = self.backgroundColor.CGColor;
		self.activeBorderLayer.shadowOffset = CGSizeZero;
		self.activeBorderLayer.borderWidth = 1.0f;
	}
}

#pragma mark - private method
/**
 *  更新边框颜色
 */
- (void)updateBorder
{
	//设置默认显示非活跃状态
	self.activeBorderLayer.frame = [self rectForBorder];
}

- (void)updateTextBackgroundImageView
{
	if (self.textBackgroundImage) {
		self.textBackgroundImageView.frame = [self rectForBorder];
	}
}

/**
 *  计算border的rect,围绕整个可编辑输入的边框
 */
- (CGRect)rectForBorder
{
	NSLog(@"%@",NSStringFromCGRect(self.bounds));
	CGRect rect = [self textRectForBounds:self.bounds];
	rect.origin.x -= 5;
	rect.size.width += 5;
	return rect;
}

#pragma mark - getters and setters
- (CALayer *)activeBorderLayer
{
	if (!_activeBorderLayer) {
		_activeBorderLayer = [CALayer layer];
		_activeBorderLayer.cornerRadius = 5.0f;
		_activeBorderLayer.masksToBounds = YES;
	}
	return _activeBorderLayer;
}

- (UIImageView *)textBackgroundImageView
{
	if (_textBackgroundImageView == nil) {
		_textBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_textBackgroundImageView.backgroundColor = [UIColor clearColor];
	}
	return _textBackgroundImageView;
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor
{
	_borderActiveColor = borderActiveColor;
}

- (void)setTextBackground:(UIColor *)textBackground
{
	_textBackground = textBackground;
	self.activeBorderLayer.backgroundColor = _textBackground.CGColor;
}

- (void)setTextBackgroundImage:(UIImage *)textBackgroundImage
{
	_textBackgroundImage = textBackgroundImage;
	if (_textBackgroundImage == nil) {
		if (_textBackgroundImageView.superview != nil) {
			[self.textBackgroundImageView removeFromSuperview];
		}
	}else{
		if (_textBackgroundImageView.superview == nil) {
			[self addSubview:self.textBackgroundImageView];
		}
		self.textBackgroundImageView.image = _textBackgroundImage;
	}
}

@end
