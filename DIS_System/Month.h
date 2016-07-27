//
//  Month.h
//  Calendar
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Month : NSObject

@property(strong, nonatomic) NSDate *monthDate;
@property(strong, nonatomic) NSArray *avaliableTime;

- (NSInteger) weekday: (NSInteger) date;
- (NSInteger) month;
- (NSInteger) year;
- (NSInteger) firstWeekdayInThisMonth;
- (NSInteger) totaldaysInThisMonth;
- (NSInteger) totaldaysInMonth;
- (NSDate *) lastMonth;
- (NSDate *) nextMonth;

@end
