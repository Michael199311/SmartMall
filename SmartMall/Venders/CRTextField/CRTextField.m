//
//  CRTextField.m
//  CRTextField
//
//  Created by 王健功 on 15/8/10.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "CRTextField.h"

@implementation CRTextField

- (void)dealloc
{
	NSLog(@"dealloc------>%@",[self class]);
	_titleView = nil;
	_placeholderColor = nil;
	_placeholderFont = nil;
}

- (void)awakeFromNib
{
	[self creatNewClearButton];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self creatNewClearButton];
	}
	return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
	return CGRectMake(0,
					  0,
					  self.titleView.frame.size.width,
					  bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
	CGRect leftRect = [self leftViewRectForBounds:bounds];
	return CGRectMake(CGRectGetWidth(bounds) - 20, 0, 20, CGRectGetHeight(leftRect));
}

/**
 *  设置文本可输入区域，按照当前bound进行缩放
 *
 *  @param bounds 实际BOUND
 *
 *  @return 缩放后显示的bound
 */
- (CGRect)textRectForBounds:(CGRect)bounds
{
	CGRect leftRect = [self leftViewRectForBounds:bounds];
	return CGRectMake(CGRectGetMaxX(leftRect), CGRectGetMinY(leftRect), CGRectGetWidth(self.bounds) - CGRectGetMaxX(leftRect), CGRectGetHeight(leftRect));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return [self textRectForBounds:bounds];
}

- (void)creatNewClearButton
{
	if (self.showCustomClear) {
		self.clearButtonMode = UITextFieldViewModeNever;
		UIImage *image = [UIImage imageNamed:@"login-delete-tool"];
		UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
		[clearButton setImage:image forState:UIControlStateNormal];
		[clearButton addTarget:self action:@selector(clearAllText) forControlEvents:UIControlEventTouchUpInside];
		self.rightView = clearButton;
		self.rightViewMode = UITextFieldViewModeWhileEditing;
	}
}

#pragma mark - events
- (void)clearAllText
{
	self.text = nil;
}

#pragma mark - getters and setters
- (void)setTitleView:(UIView *)titleView
{
	_titleView = nil;
	_titleView = titleView;
	self.leftView = self.titleView;
	self.leftViewMode = UITextFieldViewModeAlways;
	[self setNeedsDisplay];//force reload for updated editing rect for bound to take effect.
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
	_placeholderColor = placeholderColor;
	[self setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
	_placeholderFont = placeholderFont;
	[self setValue:_placeholderFont forKeyPath:@"_placeholderLabel.font"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
