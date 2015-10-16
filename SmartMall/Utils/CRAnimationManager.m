//
//  CRAnimationManager.m
//  CarRental
//
//  Created by 王健功 on 15/7/7.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "CRAnimationManager.h"

static NSTimeInterval const kAFViewShakerDefaultDuration = 0.5;
static NSString * const kAFViewShakerAnimationKey = @"kAFViewAnimationKey";

@interface CRAnimationManager ()
/**
 *  存放所有动画view的数组
 */
@property (nonatomic, strong) NSArray * views;
/**
 *  完成的动画数量
 */
@property (nonatomic, assign) NSUInteger completedAnimations;
/**
 *  动画完成后调用的block
 */
@property (nonatomic, copy) void (^completionBlock)();

@end

@implementation CRAnimationManager

#pragma mark - life cycle
- (void)dealloc
{
	NSLog(@"dealloc------>%@",[self class]);
	_completionBlock = nil;
}

- (instancetype)initWithView:(UIView *)view {
	return [self initWithViewsArray:@[ view ]];
}

- (instancetype)initWithViewsArray:(NSArray *)viewsArray {
	self = [super init];
	if ( self ) {
		self.views = viewsArray;
		self.type = CRAnimationManagerShake;
		self.animationDuration = kAFViewShakerDefaultDuration;
	}
	return self;
}

#pragma mark - public method
+ (void)doAnimationWithView:(UIView *)animationView andType:(CRAnimationType)type
{
	CRAnimationManager *manager = [[CRAnimationManager alloc] initWithView:animationView];
	manager.type = type;
	[manager doAnimation];
}

- (void)doAnimation {
	[self animationWithDuration:kAFViewShakerDefaultDuration completion:nil];
}

- (void)animationWithDuration:(NSTimeInterval)duration completion:(void (^)())completion {
	switch (_type) {
		case CRAnimationManagerShake:
			for (UIView * view in self.views) {
				[self addShakeAnimationForView:view withDuration:duration];
			}
			break;
		case CRAnimationManagerSpring:
			for (UIView * view in self.views) {
				[self addSpringAnimatkonForView:view withDuration:duration];
			}
			break;
		default:
			break;
	}
}


#pragma mark - private method
/**
 *  执行抖动动画
 *
 *  @param view     执行shake动画的view
 *  @param duration 执行动画的时间
 */
- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration {
	CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
	CGFloat currentTx = view.transform.tx;
	
	animation.delegate = self;
	animation.duration = duration;
	animation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
	animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
	animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[view.layer addAnimation:animation forKey:kAFViewShakerAnimationKey];
}

- (void)addSpringAnimatkonForView:(UIView *)view withDuration:(NSTimeInterval)duration
{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.spring"];
	animation.duration = duration;
	animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
							[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
							[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
							[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.0f, 1.1f)],
							[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
							[NSValue valueWithCATransform3D:CATransform3DIdentity]];
	animation.keyTimes = @[@0.0f, @0.4f, @0.7f, @0.85f, @0.95f ,@1];
	animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
									 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[view.layer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
	self.completedAnimations += 1;
	if ( self.completedAnimations >= self.views.count ) {
		self.completedAnimations = 0;
		if ( self.completionBlock ) {
			self.completionBlock();
		}
	}
}

#pragma mark - getters and setters
- (void)setType:(CRAnimationType)type
{
	_type = type;
}

@end
