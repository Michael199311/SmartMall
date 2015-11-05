//
//  UIStoryboard+CRInstantiate.h
//  CarRental
//
//  Created by 王健功 on 15/7/6.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (CRInstantiate)

/**
 *  获取一个storyBoard中对于的viewController 或者view
 *
 *  @param identifier view和viewcontroll的identifier
 *  @param nameString storyBoard name
 *
 *  @return 返回一个view 或者viewContoller
 */
+ (instancetype)instantiateViewControllerWithIdentifier:(NSString *)identifier
								andStroyBoardNameString:(NSString *)nameString;
@end
