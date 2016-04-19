//
//  FormatHelper.m
//  Youth_Hostel
//
//  Created by Anton Borev on 10/20/15.
//  Copyright © 2015 Anton. All rights reserved.
//

#import "FormatHelper.h"

@implementation FormatHelper
+(NSString*) getDayFromDate:(NSDate*) date
{
    NSString* strDay;
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    strDay =[df stringFromDate:date];
    return  strDay;
}
+(NSString*) getMonthFromDate:(NSDate*) date
{
    NSString* strMonth;
    NSDateFormatter *df =[[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM"];
    strMonth =[df stringFromDate:date];
    return  strMonth;
}
+(NSString*) getWeekDayFromDate:(NSDate*) date
{
    NSArray* arrWeekDay=@[@"Sunday",@"Monday",@"TuesDay",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];

    NSCalendar* cal =[NSCalendar currentCalendar];
    NSDateComponents* comp =[cal components:NSCalendarUnitWeekday fromDate:date];
    int nWeekday =(int)[comp weekday]-1;
    return arrWeekDay[nWeekday];
}
+(NSNumber*) getDaysWithFirstDate:(NSDate*) firstDate SecondDate:(NSDate*) secondDate
{
    NSDate *firstTime;
    NSDate *secondTime;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&firstTime interval:NULL forDate:firstDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&secondTime interval:NULL forDate:secondDate];
    NSDateComponents *difference =[calendar components:NSCalendarUnitDay fromDate:firstTime toDate:secondTime options:0];
    NSNumber *numNights =[NSNumber numberWithInteger:[difference day]];
    return numNights;
}
+ (NSString *)stringByRemovingQuotationMarks:(NSString *)inputStr
{
    NSString *newStr = inputStr;
    if (newStr.length > 0) {
        // Start quotation mark
        if ([newStr characterAtIndex:0] == '"')
        {
            newStr = [newStr substringFromIndex:1];
        }
        // End quotation mark
        if ([newStr characterAtIndex:(newStr.length - 1)] == '"') {
            newStr = [newStr substringToIndex:(newStr.length - 1)];
        }
    }
    return newStr;
}

+(BOOL) validateEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
//    if([emailString containsString:@"+"])
//        return NO;
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}
+(BOOL) validateDigit:(NSString*) digitString
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:digitString];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}
+(NSDate*) getDateFromString:(NSString*) strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:strDate];
    return dateFromString;
}
+(NSNumber*) getNumberFromString:(NSString*) strNumber
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:strNumber];
    return myNumber;
}
+(NSString*) getStringFromDate:(NSDate*) date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * strDate =[formatter stringFromDate:date];
    return strDate;
}
+(NSString*) getLocalizedString:(NSString*) strKey
{
    return [[NSBundle mainBundle] localizedStringForKey:(strKey) value:@"" table:nil];
}
+(NSString*) changeFirstLetterByUpcase:(NSString*) originalString
{
    NSString *capitalisedSentence = nil;
    
    //Does the string live in memory and does it have at least one letter?
    if (originalString && originalString.length > 0) {
        // Yes, it does.
        capitalisedSentence = [originalString stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                  withString:[[originalString substringToIndex:1] capitalizedString]];
    } else {
        capitalisedSentence = originalString;
        // No, it doesn't.
    }
    return capitalisedSentence;
}
@end
