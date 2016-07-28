//
//  DoctorSetupViewController.m
//  DIS_System
//
//  Created by Zebin Yang on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "DoctorSetupViewController.h"

@interface DoctorSetupViewController ()
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSMutableArray *dates;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

@property (weak, nonatomic) IBOutlet UIButton *monOutlet;
@property (weak, nonatomic) IBOutlet UIButton *tueOutlet;
@property (weak, nonatomic) IBOutlet UIButton *wedOutlet;
@property (weak, nonatomic) IBOutlet UIButton *thuOutlet;
@property (weak, nonatomic) IBOutlet UIButton *friOutlet;

- (IBAction)datePressed:(id)sender;
- (IBAction)setupPressed:(id)sender;


@end

@implementation DoctorSetupViewController
bool monFlag = false;
bool tueFlag = false;
bool wedFlag = false;
bool thuFlag = false;
bool friFlag = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    _dates = [[NSMutableArray alloc] init];
    _time = @"AllDay";
    _pickerArray = [NSMutableArray arrayWithObjects:@"AllDay", @"Morning", @"Afternoon", nil];

    // Do any additional setup after loading the view.
    NSLog(@"%d",tueFlag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- Picker dataSource Method

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerArray objectAtIndex:row];
}

#pragma mark- Picker delegate Method

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _time = [_pickerArray objectAtIndex:row];
}

#pragma mark- Button Actions

- (IBAction)datePressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            monFlag = !monFlag;
            if (monFlag)
                [_monOutlet setBackgroundColor:[UIColor grayColor]];
            else
                [_monOutlet setBackgroundColor:[UIColor clearColor]];
            break;
        case 101:
            tueFlag = !tueFlag;
            if (tueFlag)
                [_tueOutlet setBackgroundColor:[UIColor grayColor]];
            else
                [_tueOutlet setBackgroundColor:[UIColor clearColor]];
            break;
        case 102:
            wedFlag = !wedFlag;
            if (wedFlag)
                [_wedOutlet setBackgroundColor:[UIColor grayColor]];
            else
                [_wedOutlet setBackgroundColor:[UIColor clearColor]];
            break;
        case 103:
            thuFlag = !thuFlag;
            if (thuFlag)
                [_thuOutlet setBackgroundColor:[UIColor grayColor]];
            else
                [_thuOutlet setBackgroundColor:[UIColor clearColor]];
            break;
        case 104:
            friFlag = !friFlag;
            if (friFlag)
                [_friOutlet setBackgroundColor:[UIColor grayColor]];
            else
                [_friOutlet setBackgroundColor:[UIColor clearColor]];
            break;
        default:
            break;
    }
    NSLog(@"%d",tueFlag);
}

- (IBAction)setupPressed:(id)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PFQuery *pwdQuery = [PFQuery queryWithClassName:@"Doctors"];
    [pwdQuery whereKey:@"Mobile" equalTo:app.doctorMobile];
    [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            PFObject *doctor = [objects lastObject];
            [_dates removeAllObjects];
            if (monFlag)
                [_dates addObject:@"Mon"];
            if (tueFlag)
                [_dates addObject:@"Tue"];
            if (wedFlag)
                [_dates addObject:@"Wed"];
            if (thuFlag)
                [_dates addObject:@"Thu"];
            if (friFlag)
                [_dates addObject:@"Fri"];
            
            [doctor setObject:_time forKey:@"AvailableTime"];
            [doctor setObject:_dates forKey:@"AvailableDate"];
            [doctor saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
            NSLog(@"Set up availability error:%@", [error description]);
    }];
    
}
@end
