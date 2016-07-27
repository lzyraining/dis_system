//
//  Month.m
//  Calendar
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import "Month.h"

@implementation Month

@synthesize monthDate;

- (NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:monthDate];
    return [components day];
}

- (NSInteger) weekday: (NSInteger) date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:monthDate];
    components.day = date;
    NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:newDate];
    
    return [components weekday];
}


- (NSInteger)month {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:monthDate];
    return [components month];
}

- (NSInteger)year {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:monthDate];
    return [components year];
}

- (NSInteger)firstWeekdayInThisMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:monthDate];
    [comp setDay:1];
    
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth {
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:monthDate];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth {
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:monthDate];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:monthDate options:0];
    return newDate;
}

- (NSDate*)nextMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:monthDate options:0];
    return newDate;
}



@end
