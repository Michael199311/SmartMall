//
//  CRTextFieldEffects.m
//  CRTextField
//
//  Created by 王健功 on 15/8/6.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "CRTextFieldFormat.h"
#import <Foundation/Foundation.h>
/**
 *  错误提示消息默认颜色
 */
#define Default_Error_COLOR [UIColor colorWithRed:242.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.000]
#define Default_Error_Font []

@interface CRTextFieldFormat ()

/**
 *  验证不通过提示Label,默认不显示，用户输入错误后，在textfield下方动画显示
 *  用户输入是，不显示，用户停止编辑时显示
 */
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) NSString *errorText;/**<错误提示文本*/

@end

@implementation CRTextFieldFormat

- (void)dealloc
{
	NSLog(@"dealloc------>%@",[self class]);
	_errorLabel = nil;
	_errorMessage = nil;
	_errorText = nil;
	_isValidate = nil;
	_pattern = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self configureDefault];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self configureDefault];
	}
	return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	if (newSuperview != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self];
	}else{
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	self.errorLabel.frame = rect;
}

#pragma mark - Edit Notification
- (void)textFieldDidBeginEditing:(CRTextFieldFormat *)textField;
{
	[self removeErrorAlert];
	[self animateViewsForTextEntry];
}

- (void)textFieldDidEndEditing:(CRTextFieldFormat *)textField
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self animateViewsForTextDisplay];
	});
	[self textValidate];
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
	UITextField *textField = (UITextField *)obj.object;
	//长度输入限制
	if (self.maxLength > 0) {
		NSString *toBeString = self.text;
		//记录当前光标位置
		NSRange currentRange = [self selectedRange];
		//用于标记是否有被选择的关联文字(比如中文输入)
		UITextRange *selectedRange = [self markedTextRange];
		//获取高亮文字部分
		UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
		if (position == nil) {
			//根据最大输入长度maxLength截取文本
			textField.text = [self calculateTextNumber:toBeString];
			//如果location已经大于当前文本的长度，说明此时已经达到输入上限,设置光标始终位于末尾。
			//如果不做设置，光标会直接跑到开头
			if (currentRange.location > textField.text.length) {
				currentRange.location = textField.text.length;
			}
			//需要设置焦点位置，保证焦点在当前位置。否则每次value chang后焦点都会在最后显示
			[self setSelectedRange:currentRange];
		}
	}
	if (self.validateOnChange) {
		[self textValidate];//实时验证输入格式
	}
}

#pragma mark - publick method
- (void)animateViewsForTextEntry
{
	NSAssert([self respondsToSelector:@selector(animateViewsForTextEntry)], @"/%s必须被重用/",__FUNCTION__);
}

- (void)animateViewsForTextDisplay
{
	NSAssert([self respondsToSelector:@selector(animateViewsForTextDisplay)], @"/%s必须被重用/",__FUNCTION__);
}

- (void)showErrorAlert
{
	self.errorText = self.errorMessage;
}

- (void)removeErrorAlert
{
	self.errorText = nil;
}

#pragma mark - private method
- (void)configureDefault
{
	self.isValidate = @"NO";
	self.validateOnChange = NO;
	self.isMandatory = NO;
}
/**
 *  根据当前view的bound计算错误提示框的rect
 */
- (void)layoutErrorLabelInTextRect
{
	if (self.errorText && self.errorText.length > 0) {
		//有错误,显示
		if (self.errorLabel.superview == nil) {
			CGRect textRect = [self textRectForBounds:self.bounds];//获取当前文本Bounds
			CGFloat orignX = textRect.origin.x;
			self.errorLabel.frame = CGRectMake(orignX + CGRectGetMinX(self.frame),
											   CGRectGetMaxY(self.frame) - 20.0f,
											   CGRectGetWidth(textRect),
											   20.0f);
			[self.superview insertSubview:self.errorLabel aboveSubview:self];
			
			[UIView animateWithDuration:0.3 animations:^{
				//下移10PS
				self.errorLabel.alpha = 1;
				CGAffineTransform translate = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.errorLabel.frame));
				self.errorLabel.transform = translate;
			} completion:nil];
		}
	}else{
		if (self.errorLabel.superview != nil) {
			self.errorLabel.transform = CGAffineTransformIdentity;//恢复所以的transform
			[UIView animateWithDuration:0.3 animations:^{
				self.errorLabel.alpha = 0;
			} completion:^(BOOL finished) {
				//没有错误，不显示
				[self.errorLabel removeFromSuperview];
			}];
		}
	}
}

- (void)updateErrorLabel
{
	self.errorLabel.text = self.errorText;
	[self.errorLabel sizeToFit];
	[self layoutErrorLabelInTextRect];
}
/**
 *  设置错误提示消息的字体大小是textField的字体大小的0.65倍
 *
 *  @param font textField的字体大小
 *
 *  @return 错误提示消息label的字体
 */
- (UIFont *)errorLabelFontFromFont:(UIFont *)font
{
	return [UIFont fontWithName:font.fontName size:0.8 * font.pointSize];
}
/**
 *  获取当前光标位置
 */
- (NSRange)selectedRange
{
	UITextPosition *beginning = self.beginningOfDocument;
	
	UITextRange *selectedRange = self.selectedTextRange;
	UITextPosition *selectionStart = selectedRange.start;
	UITextPosition *selectionEnd = selectedRange.end;
	
	const NSInteger location = [self offsetFromPosition:beginning
											 toPosition:selectionStart];
	const NSInteger length = [self offsetFromPosition:selectionStart
										   toPosition:selectionEnd];
	
	return NSMakeRange(location, length);
}
/**
 *  设置光标位置
 */
- (void)setSelectedRange:(NSRange)range
{
	UITextPosition *begin = self.beginningOfDocument;
	UITextPosition *startPosition = [self positionFromPosition:begin
														offset:range.location];
	UITextPosition *endPosition = [self positionFromPosition:begin
													  offset:range.location + range.length];
	UITextRange *selectionRange = [self textRangeFromPosition:startPosition
												   toPosition:endPosition];
	
	[self setSelectedTextRange:selectionRange];
}

/**
 *  根据最大长度截取字符串，其中中文按3 byte计算，英文数字按1 byte计算，如果长度大于最大字节长度
 *  停止输入。最后返回截取的字符串
 */
- (NSString *)calculateTextNumber:(NSString *)textA
{
	NSString *textString = [NSString string];
	if (self.maxLength > 0) {
		//如果设置了可输入最大长度，按照最大长度截取当前字符串，并将最后的结果返回
		float number = 0.0;
		
		for (int index = 0; index < [textA length]; index++) {
			//遍历字符串，获取截取后的字符串
			NSString *character = [textA substringWithRange:NSMakeRange(index, 1)];
			
			if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
				number = number+2;//中文
			} else {
				number = number+1;
			}
			if (number <= self.maxLength) {
				textString = [textString stringByAppendingString:character];
			}else{
				break;
			}
		}
	}else{
		//如果maxLength为0,不做任何操作
		textString = [textA copy];
	}
	
	return textString;
}

- (void)textValidate
{
	NSString *text = self.text;
	//未输入验证
	if (self.isMandatory && text.length == 0) {
		[self setValue:@"NO" forKey:@"isValidate"];
		self.errorText = @"不能为空";
		return;
	}
	//输入格式验证
	if (self.pattern && self.pattern.length > 0) {
		//表示设置了验证格式
		if ([self validateFormat] == YES) {
			self.isValidate = @"YES";
		}else{
			self.isValidate = @"NO";
			[self showErrorAlert];
		}
	}else{
		//不要求格式输入
		self.isValidate = @"YES";
	}
}

- (BOOL)validateFormat
{
	//根据预先设定的正则表达式(pattern)判断当前输入是否正确
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.pattern];
	return [pred evaluateWithObject:self.text];
}

#pragma mark - getters and getters
- (void)setBounds:(CGRect)bounds
{
	[super setBounds:bounds];
	[self updateErrorLabel];
}

- (void)setErrorText:(NSString *)errorText
{
	_errorText = errorText;
	[self updateErrorLabel];
}

- (UILabel *)errorLabel
{
	if (_errorLabel == nil) {
		_errorLabel = [[UILabel alloc] init];
		_errorLabel.textColor = Default_Error_COLOR;
		_errorLabel.backgroundColor = [UIColor clearColor];
		_errorLabel.alpha = 0;
		self.errorLabel.font = [self errorLabelFontFromFont:self.font];
	}
	return _errorLabel;
}

@end
