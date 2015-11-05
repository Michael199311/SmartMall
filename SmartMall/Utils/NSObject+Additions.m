//
//  NSObject+Additions.m
//  CarRentalClient
//
//  Created by 王健功 on 15/6/11.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (Additions)

+ (id)isNotNull:(id)object
{
	return (((object) == nil || [(object) isEqual:[NSNull null]])?@"":(object));
}

@end
