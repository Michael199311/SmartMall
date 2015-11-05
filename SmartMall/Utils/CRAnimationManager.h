//
//  CRAnimationManager.h
//  CarRental
//
//  Created by 王健功 on 15/7/7.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//
//  这里管理当前app所有动画，可以给一个view或者多个view同上添加动画
//  如果需要添加一个新的东西，需要在CRAnimationType中添加动画类型，并在.m中的 #pragma mark - private method 中添加方法的实现
//  和在- (void)animationWithDuration:(NSTimeInterval)duration completion:(void (^)())completion方法中添加动画的调用

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 动画类型，
 */
typedef enum CRAnimationType{
	CRAnimationManagerShake,
	CRAnimationManagerSpring,//弹簧动画
}CRAnimationType;

@interface CRAnimationManager : NSObject
/**
 *  动画的类型，默认是shake
 */
@property (assign, nonatomic) CRAnimationType type;

/**
 *  动画执行的时间,默认0.5秒
 */
@property (assign, nonatomic) NSTimeInterval animationDuration;

/**
 *  给view添加一个默认动画
 *
 *  @param view 需要添加动画的View
 *
 *  @return 返回CRAnimationManager对象
 */
- (instancetype)initWithView:(UIView *)view;
/**
 *  给多个view添加默认动画
 *
 *  @param viewsArray 存放所有动画view
 *
 *  @return 返回CRAnimationManager对象
 */
- (instancetype)initWithViewsArray:(NSArray *)viewsArray;
/**
 *  类方法，对animationView执行动画
 *
 *  @param animationView 需要执行动画的view
 *  @param type          动画类型
 */
+ (void)doAnimationWithView:(UIView *)animationView andType:(CRAnimationType)type;
/**
 *  执行动画
 */
- (void)doAnimation;

@end
