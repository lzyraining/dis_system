//
//  DoctorHomeViewController.m
//  DIS_System
//
//  Created by swt on 5/13/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "DoctorHomeViewController.h"
#import "DoctorSetupViewController.h"
#import "ReviewViewController.h"
#import "RecordsViewController.h"

@interface DoctorHomeViewController ()
- (IBAction)setUpPressed:(id)sender;
- (IBAction)calendarPressed:(id)sender;
- (IBAction)reviewPressed:(id)sender;
- (IBAction)recordsPressed:(id)sender;

@end

@implementation DoctorHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)setUpPressed:(id)sender {
    DoctorSetupViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSetupViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)calendarPressed:(id)sender {
    CKCalendarInstance *calendar = [CKCalendarInstance new];
    [self presentViewController:calendar animated:YES completion:nil];
}

- (IBAction)reviewPressed:(id)sender {
    ReviewViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ReviewViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)recordsPressed:(id)sender {
    RecordsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordsViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
