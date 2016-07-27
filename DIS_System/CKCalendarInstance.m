//
//  CKCalendarInstance.m
//  DIS_System
//
//  Created by Zebin Yang on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "CKCalendarInstance.h"
#import "NSCalendarCategories.h"
#import "NSDate+Components.h"

@interface CKCalendarInstance () <CKCalendarViewDelegate, CKCalendarViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSString *patientName;

@end

@implementation CKCalendarInstance

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [[NSMutableDictionary alloc] init];
    [self setDataSource:self];
    [self setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCalendarData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)loadCalendarData {
//    [self.data removeAllObjects];
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    PFQuery *pwdQuery = [PFQuery queryWithClassName:@"Billboard"];
//    [pwdQuery whereKey:@"DocMob" equalTo:app.doctorMobile];
//    [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//        if (!error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            for (PFObject *obj in objects) {
//                PFQuery *pwdQuery2 = [PFQuery queryWithClassName:@"Patients"];
//                [pwdQuery2 whereKey:@"Mobile" equalTo:[obj objectForKey:@"PatMob"]];
//                [pwdQuery2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    
//                    if (!error) {
//                        NSString *title;
//                        NSString *dateString = [obj objectForKey:@"Date"];
//                        NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
//                        NSDate *date = [NSDate dateWithDay:[[dateArray objectAtIndex:2] integerValue] month:[[dateArray objectAtIndex:1] integerValue] year:[[dateArray objectAtIndex:0] integerValue]];
//                         _patientName = [[objects lastObject] objectForKey:@"Name"];
//                        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:obj.objectId, @"objectId", [obj objectForKey:@"Check"], @"Check", _patientName, @"PatName", dateString, @"Date", [obj objectForKey:@"Time"], @"Time",nil];
//                       
//                        if ([[obj objectForKey:@"Check"] isEqualToString:@"0"]) {
//                            title = [NSString stringWithFormat:@"With:%@,Time:%@(Unconfirmed)", _patientName, [obj objectForKey:@"Time"]];
//                        } else {
//                            title = [NSString stringWithFormat:@"With:%@,Time:%@(Confirmed)", _patientName, [obj objectForKey:@"Time"]];
//                        }
//                        
//                        CKCalendarEvent *event = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:infoDict];
//                        if (self.data[date]) {
//                            [self.data[date] addObject:event];
//                        } else {
//                            self.data[date] = [NSMutableArray arrayWithObject:event];
//                        }
//                       
//                        [self.calendarView reload];
//                    }
//                }];
//            }
//            
//            
//        }else
//            NSLog(@"Error:%@", [error description]);
//    }];
//}

- (void)loadCalendarData {
    
    [self.data removeAllObjects];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PFQuery *pwdQuery = [PFQuery queryWithClassName:@"Billboard"];
    [pwdQuery whereKey:@"DocMob" equalTo:app.doctorMobile];
    
    // Start the first service
    [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // Create the dispatch group
            dispatch_group_t serviceGroup = dispatch_group_create();

            for (PFObject *obj in objects) {
                PFQuery *pwdQuery2 = [PFQuery queryWithClassName:@"Patients"];
                [pwdQuery2 whereKey:@"Mobile" equalTo:[obj objectForKey:@"PatMob"]];
                dispatch_group_enter(serviceGroup);
                [pwdQuery2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (!error) {
                        NSString *title;
                        NSString *dateString = [obj objectForKey:@"Date"];
                        NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
                        NSDate *date = [NSDate dateWithDay:[[dateArray objectAtIndex:2] integerValue] month:[[dateArray objectAtIndex:1] integerValue] year:[[dateArray objectAtIndex:0] integerValue]];
                        _patientName = [[objects lastObject] objectForKey:@"Name"];
                        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:obj.objectId, @"objectId", [obj objectForKey:@"Check"], @"Check", _patientName, @"PatName", dateString, @"Date", [obj objectForKey:@"Time"], @"Time",nil];
                        
                        if ([[obj objectForKey:@"Check"] isEqualToString:@"0"]) {
                            title = [NSString stringWithFormat:@"W/:%@,Time:%@(Unconfirmed)", _patientName, [obj objectForKey:@"Time"]];
                        } else {
                            title = [NSString stringWithFormat:@"W/:%@,Time:%@(Confirmed)", _patientName, [obj objectForKey:@"Time"]];
                        }
                        
                        CKCalendarEvent *event = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:infoDict];
                        if (self.data[date]) {
                            [self.data[date] addObject:event];
                        } else {
                            self.data[date] = [NSMutableArray arrayWithObject:event];
                        }
                    }
                    dispatch_group_leave(serviceGroup);
                }];
            }
            
            dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
                [self.calendarView reload];
            });
        }else
            NSLog(@"Error:%@", [error description]);
    }];

}

#pragma mark - CKCalendarViewDataSource
- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date {
    return [self data][date];
}

#pragma mark - CKCalendarViewDelegate

// Called after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date {
    
}

//  A row is selected in the events table. (Use to push a detail view.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event {
    
    PFQuery *pwdQuery = [PFQuery queryWithClassName:@"Billboard"];
    [pwdQuery whereKey:@"objectId" equalTo:[event.info objectForKey:@"objectId"]];
    [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            PFObject *object = [objects lastObject];
            if ([[object objectForKey:@"Check"] isEqualToString:@"0"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Appointment" message:[NSString stringWithFormat:@"Do you want to accept this new appointment with %@ at %@:%@?", [event.info objectForKey:@"PatName"], [event.info objectForKey:@"Date"], [event.info objectForKey:@"Time"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                    [object setObject:@"1" forKey:@"Check"];
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    [self loadCalendarData];
                    [self.calendarView reload];
                }];
                UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    [self loadCalendarData];
                    [self.calendarView reload];
                }];
                
                [alert addAction:accept];
                [alert addAction:decline];
                [self presentViewController:alert animated:YES completion:nil];
            }
 
        }else
            NSLog(@"Error:%@", [error description]);
    }];

}


@end
