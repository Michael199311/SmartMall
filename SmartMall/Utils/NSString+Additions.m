//
//  NSString+Additions.m
//  CarRentalStaff
//
//  Created by Nathan on 11/29/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import "NSString+Additions.h"
#import "NSObject+Additions.h"

@implementation NSString (Additions)

- (NSDate *)stringToDateWithFormat:(NSString *)dateFormat
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:dateFormat];
	return [format dateFromString:self];
}

- (NSString *)encodeUrlString {
    NSString *sUrl = (NSString *)CFBridgingRelease
    (CFURLCreateStringByAddingPercentEscapes(
                                             kCFAllocatorDefault,
                                             (CFStringRef)[self copy],
                                             NULL,
                                             NULL,
                                             kCFStringEncodingUTF8)
     );
	return sUrl;
}

+ (BOOL) isNotEmptyString:(NSString *)string
{
	return (string != nil && string.length != 0);
}

+ (NSString *)validateString:(NSString *)string
{
	return [NSObject isNotNull:string];
}

+ (CGFloat)heightForString:(NSString *)value font:(UIFont *)font andWidth:(float)width
{
	
	NSDictionary *attribute = @{NSFontAttributeName:font};
	CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
										   options:NSStringDrawingUsesLineFragmentOrigin
										attributes:attribute
										   context:nil].size;
	return sizeToFit.height;
}
@end
