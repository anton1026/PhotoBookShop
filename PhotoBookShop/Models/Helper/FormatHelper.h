//
//  FormatHelper.h
//  Created by Anton Borev on 10/20/15.
//  Copyright © 2015 Anton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FormatHelper : NSObject
+(NSString*) getDayFromDate:(NSDate*) date;
+(NSString*) getMonthFromDate:(NSDate*) date;
+(NSString*) getWeekDayFromDate:(NSDate*) date;
+(NSNumber*) getDaysWithFirstDate:(NSDate*) firstDate SecondDate:(NSDate*) secondDate;
+(NSString*) stringByRemovingQuotationMarks:(NSString*) inputStr;
+(BOOL) validateEmail:(NSString*) emailString;
+(BOOL) validateDigit:(NSString*) digitString;
+(NSDate*) getDateFromString:(NSString*) strDate;
+(NSNumber*) getNumberFromString:(NSString*) strNumber;
+(NSString*) getStringFromDate:(NSDate*) date;
+(NSString*) getLocalizedString:(NSString*) strKey;
+(NSString*) changeFirstLetterByUpcase:(NSString*) originalString;
@end

