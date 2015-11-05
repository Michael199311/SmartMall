//
//  CRBaseViewController.m
//  CarRentalClient
//
//  Created by 王健功 on 15/6/9.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import "CRBaseViewController.h"
#import "UIDevice+CurrentDevice.h"
#import "UIView+CRAdditions.h"

@interface CRBaseViewController ()

@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIImageView *backgroundView;



@end

@implementation CRBaseViewController

#pragma mark - 生命周期
- (void)dealloc{
	NSLog(@"\n%@ -----> dealloc",[self class]);
	_backgroundColor = nil;
	_backgroundImage = nil;
	_backgroundView = nil;
	_navigationLeftButton = nil;
	_leftBarImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//设置导航栏titleView
	//[self setNavigationTitle:[UIImage imageNamed:@"Nav_Logo"]];
    self.navigationItem.titleView.backgroundColor = [UIColor orangeColor];
	//添加整个APP的背景View
	[self.view insertSubview:self.backgroundView atIndex:0];
	//添加背景色/背景图片
    self.backgroundImage = [UIImage imageNamed:@""];
	//添加默认左侧按钮
	self.leftBarImage = [UIImage imageNamed:@"register-back"];
	//隐藏返回按钮
	self.navigationItem.hidesBackButton = YES;

    // Do any additional setup after loading the view.
}

#pragma mark - events
- (void)leftButtonAction
{
	//执行某些方法，可以被子类重用
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction
{
	//执行某些方法，需要被子类重用
}

#pragma mark - getters and setters
- (UIButton *)navigationLeftButton
{
	if (!_navigationLeftButton) {
		_navigationLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_navigationLeftButton.frame = CGRectMake(15.0f, 2, 40.0f, 40.0f);
		[_navigationLeftButton makeCornerRadiusOfRadius:20.0f];
		[_navigationLeftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _navigationLeftButton;
}

- (UIButton *)navigationRightButton
{
	if (!_navigationRightButton) {
		_navigationRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_navigationRightButton.frame = CGRectMake(15.0f, 2, 40.0f, 40.0f);
		[_navigationRightButton makeCornerRadiusOfRadius:20.0f];
		[_navigationRightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _navigationRightButton;
}

- (UIImageView *)backgroundView
{
	if (!_backgroundView) {
		_backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	}
	return _backgroundView;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	if (_backgroundColor) {
		self.backgroundColor = [UIColor clearColor];
	}
	_backgroundImage = backgroundImage;
	self.backgroundView.image = _backgroundImage;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	if (_backgroundImage) {
		self.backgroundImage = nil;
	}
	_backgroundColor = backgroundColor;
	self.backgroundView.backgroundColor = _backgroundColor;
}

- (void)setLeftBarImage:(UIImage *)leftBarImage
{
	_leftBarImage = leftBarImage;
	if (_leftBarImage) {
		//添加左侧自定义按钮
		UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navigationLeftButton];
		self.navigationItem.leftBarButtonItem = barButtonItem;
		[self.navigationLeftButton setImage:_leftBarImage forState:UIControlStateNormal];
	}else{
		self.navigationItem.leftBarButtonItem = nil;
	}
}

- (void)setRightBarImageString:(NSString *)rightBarImageString
{
	_rightBarImageString = rightBarImageString;
	if (_rightBarImageString) {
		[self.navigationRightButton setImage:[UIImage imageNamed:_rightBarImageString] forState:UIControlStateNormal];
		UIBarButtonItem *barButtomItem = [[UIBarButtonItem alloc] initWithCustomView:self.navigationRightButton];
		self.navigationItem.rightBarButtonItem = barButtomItem;
	}else{
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)setNavigationTitle:(id)navigationTitle
{
	if (self.navigationItem.titleView) {
		self.navigationItem.titleView = nil;
	}
	_navigationTitle = navigationTitle;
	if ([_navigationTitle isKindOfClass:[UIImage class]]) {
		
		UIImage *contentImage = (UIImage *)_navigationTitle;
		self.navigationItem.titleView = [[UIImageView alloc] initWithImage:contentImage];
		
	}else if([_navigationTitle isKindOfClass:[NSString class]]){
		
		NSString *contentTitle = (NSString *)navigationTitle;
		UILabel *label = [[UILabel alloc] init];
		label.text = contentTitle;
		label.font = [UIFont systemFontOfSize:18];
		label.textColor = [UIColor whiteColor];
		[label sizeToFit];
		self.navigationItem.titleView = label;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
