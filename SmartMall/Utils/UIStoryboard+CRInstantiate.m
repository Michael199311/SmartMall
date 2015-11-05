//
//  UIStoryboard+CRInstantiate.m
//  CarRental
//
//  Created by 王健功 on 15/7/6.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "UIStoryboard+CRInstantiate.h"

@implementation UIStoryboard (CRInstantiate)

+ (instancetype)instantiateViewControllerWithIdentifier:(NSString *)identifier
								andStroyBoardNameString:(NSString *)nameString
{
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:nameString bundle:nil];
	return [storyBoard instantiateViewControllerWithIdentifier:identifier];
}

@end
