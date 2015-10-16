//
//  NSDate+Additions.h
//  CarRentalClient
//
//  Created by 王健功 on 15/6/12.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

/**
 *  date transform to string
 */
- (NSString *)dateToStringWithFormat:(NSString *)dateFormat;
/**
 *  get hour
 */
- (NSInteger)getHour;
/**
 *  get miniter
 */
- (NSInteger)getMinite;
@end
