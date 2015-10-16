//
//  NSDate+Additions.m
//  CarRentalClient
//
//  Created by 王健功 on 15/6/12.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString *)dateToStringWithFormat:(NSString *)dateFormat
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:dateFormat];
	return [format stringFromDate:self];
}

- (NSInteger)getHour
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags = NSHourCalendarUnit;
	NSDateComponents *component = [calendar components:unitFlags fromDate:self];
	return [component hour];
}

- (NSInteger)getMinite
{
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSInteger unitFlags = NSMinuteCalendarUnit;
	NSDateComponents *component = [calendar components:unitFlags fromDate:self];
	return [component minute];
}

@end
