//
//  AppointmentViewController.m
//  DIS_System
//
//  Created by swt on 5/17/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "AppointmentViewController.h"
#import "CalendarCell.h"
#import "Month.h"

@interface AppointmentViewController () {
    NSArray *weekdayArr;
    NSMutableDictionary *weekdayInt;
    NSDate *today;
    NSDateComponents *todayComps;
    Month *month;
    NSInteger selectedDay;
    NSArray *avaliableDay;
    NSMutableArray *appointments;
    NSArray *timeSlots;
    
    UIColor *colorBefore;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UILabel *monthLbl;

- (IBAction)previousBtn_Pressed:(id)sender;
- (IBAction)nextBtn_Pressed:(id)sender;

@end

static int pressNum;

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchDataAndInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/************************* Date ***********************/

- (void) fetchDataAndInit {
    weekdayArr = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
    month = [[Month alloc] init];
    today = [NSDate date];
    todayComps = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:today];
    month.monthDate =  today.copy;
    appointments = [[NSMutableArray alloc] init];
    timeSlots = [[NSMutableArray alloc] init];
    

    
    // Avaliable working day of this doctor
    avaliableDay = _doctor[@"AvailableDate"];
    weekdayInt = [[NSMutableDictionary alloc] init];
    for (NSString *weekday in weekdayArr) {
        weekdayInt[weekday] = @([weekdayArr indexOfObject:weekday] + 1);
    }

    // Fetch existing appointments of this doctor
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Billboard"];
    [query whereKey:@"DocMob" equalTo:_doctor[@"Mobile"]];
    [query whereKey:@"Check" equalTo:@"1"];
    [query orderByAscending:@"Date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if ([objects count]) {
                for (PFObject *obj in objects) {
                    NSMutableDictionary *appointment = [NSMutableDictionary dictionaryWithObjectsAndKeys: obj[@"Time"], @"Time",  nil];
                    NSArray *strs = [obj[@"Date"] componentsSeparatedByString:@" "];
                    appointment[@"Year"] = strs[0];
                    appointment[@"Month"] = strs[1];
                    appointment[@"Day"] = strs[2];
                    [appointments addObject:appointment];
                }
            }
            [self refreshCalender];

        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)refreshCalender {
    _monthLbl.text = [NSString stringWithFormat:@"%.2li - %li",(long)[month month],(long)[month year]];
    
    [_collectionView reloadData];
}

- (BOOL) isAvaliableWeekDay: (NSInteger) weekday {
    for (NSString *avaDay in avaliableDay) {
        if ([weekdayInt[avaDay] integerValue] == weekday ) {
            return YES;
        }
    }
    return NO;
}

- (void) getAvaliableTimeOnSelectedDay {
    if ([_doctor[@"AvailableTime"] isEqualToString: @"Morning"]) {
        timeSlots = [NSArray arrayWithObjects:@"9",@"10", @"11", nil];
    }
    else if([_doctor[@"AvailableTime"] isEqualToString: @"Afternoon"]) {
        timeSlots = [NSArray arrayWithObjects:@"2",@"3", @"4", nil];
    }
    else {
        timeSlots = [NSArray arrayWithObjects:@"9",@"10", @"11", @"2",@"3", @"4", nil];
    }
    NSMutableArray *slots = timeSlots.mutableCopy;
    for (NSDictionary *appt in appointments) {

        if ([appt[@"Year"] integerValue] == [month year] && [appt[@"Month"] integerValue] == [month month] && [appt[@"Day"] integerValue] == selectedDay) {
            for (NSString *time in timeSlots) {
                if ([time isEqualToString:appt[@"Time"]]) {
                    [slots removeObject:time];
                }
            }
        }
    }
    timeSlots = [NSArray arrayWithArray:slots];
}


/******************** CollectionView ******************/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return weekdayArr.count;
    }
    else {
        return 42;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdetifier = @"cell";
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdetifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.dateLbl.text = weekdayArr[indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:15 / 255.0 green:114 / 255.0 blue:169 / 255.0 alpha:1.0];
        cell.dateLbl.textColor = [UIColor whiteColor];
        return cell;
    }
    else {
        NSInteger day = indexPath.row - [month firstWeekdayInThisMonth] + 1;
        if (day <= 0 || day > [month totaldaysInMonth]) {
            [cell.dateLbl setText:@""];
        }
        else {
            [cell.dateLbl setText:[NSString stringWithFormat:@"%li",(long)day]];
            if ((day >= [todayComps day] || [month month] > [todayComps month]) && ([self isAvaliableWeekDay:[month weekday:day]]) ) {
                cell.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:160 / 255.0 blue:0 / 255.0 alpha:1.0];
                cell.dateLbl.textColor = [UIColor whiteColor];
                return cell;
            }
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.dateLbl.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    timeSlots = [[NSArray alloc]init];
    if (indexPath.section == 1) {
        NSInteger day = indexPath.row - [month firstWeekdayInThisMonth] + 1;
        if ((day > 0 && day <= [month totaldaysInMonth]) && (day >= [todayComps day] || [month month] > [todayComps month]) && ([self isAvaliableWeekDay:[month weekday:day]]) ) {
            selectedDay = day;
            [self getAvaliableTimeOnSelectedDay];
            CalendarCell *cell = (CalendarCell *) [collectionView cellForItemAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor redColor];
        }

    }
    [_tblView reloadData];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSInteger day = indexPath.row - [month firstWeekdayInThisMonth] + 1;
        if ((day > 0 && day <= [month totaldaysInMonth]) && (day >= [todayComps day] || [month month] > [todayComps month]) && ([self isAvaliableWeekDay:[month weekday:day]]) ) {
            CalendarCell *cell = (CalendarCell *) [collectionView cellForItemAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:160 / 255.0 blue:0 / 255.0 alpha:1.0];
        }
    }
}

/******************** tableView ******************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return timeSlots.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    
    cell.textLabel.text = timeSlots[indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dateStr = [NSString stringWithFormat:@"%li %.2li %.2li %@", (long)[month year], (long)[month month], (long)selectedDay, weekdayArr[[month weekday:selectedDay] - 1]];
    NSString *msg = [NSString stringWithFormat:@"Do you want to make an appointment with Doctor %@ on %@ at %@:00?", _doctor[@"Name"], dateStr, timeSlots[indexPath.row]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
        
        PFObject *appointment = [PFObject objectWithClassName:@"Billboard"];
        [appointment setValue:@"0" forKey:@"Check"];
        [appointment setValue:_doctor[@"Mobile"] forKey:@"DocMob"];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appointment setValue:appDelegate.customerMobile forKey:@"PatMob"];
        [appointment setObject:dateStr forKey:@"Date"];
        [appointment setObject:timeSlots[indexPath.row] forKey:@"Time"];
        
        [appointment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
        AppointmentListTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentListTableViewController"];
        [self.navigationController pushViewController:controller animated:YES];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];

    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/**************************************************/

- (IBAction)previousBtn_Pressed:(id)sender {
    NSDate *last = [month lastMonth];
    if (last == [last  laterDate:today] || [last isEqualToDate:today]) {
        month.monthDate = [month lastMonth];
        pressNum--;
        [self refreshCalender];
    }
}

- (IBAction)nextBtn_Pressed:(id)sender {
    if (pressNum <= 3) {
        month.monthDate = [month nextMonth];
        pressNum++;
        [self refreshCalender];
    }
    if (pressNum > 3) {
        [self showAlertWithTile:@"Alert" andmessage:@"You cannot make reservation beyond three months"];
    }
    
    
}

- (IBAction)apptListBtn_Pressed:(id)sender {
    AppointmentListTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentListTableViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void) showAlertWithTile:(NSString *)title andmessage:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
