//
//  AppointmentListTableViewController.m
//  DIS_System
//
//  Created by swt on 5/17/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "AppointmentListTableViewController.h"
#import "AppointmentListTableViewCell.h"

@interface AppointmentListTableViewController () {
    NSMutableArray *confirmedAppts;
    NSMutableArray *unconfirmedAppts;
    NSMutableDictionary *doctors;
    dispatch_group_t serviceGroup;
}

@end

@implementation AppointmentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    doctors = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAppointmentData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchAppointmentData {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // Fetch confirmed appointments
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    PFQuery *query = [PFQuery queryWithClassName:@"Billboard"];
    [query whereKey:@"PatMob" equalTo:appDelegate.customerMobile];
    [query whereKey:@"Check" equalTo:@"1"];
    [query orderByAscending:@"Date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if ([objects count]) {
                confirmedAppts = objects.mutableCopy;
                for (PFObject *appt in confirmedAppts) {
                    NSString *docMob = appt[@"DocMob"];
                    if (![doctors valueForKey:docMob]) {
                        [self fetchDoctorDetails:docMob];
                    }
                }
//                dispatch_async(dispatch_get_main_queue(), ^ {
//                    [self.tableView reloadData];
//                });
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
            dispatch_group_leave(serviceGroup);
    }];
    
    // Fetch unconfirmed appointments
    query = [PFQuery queryWithClassName:@"Billboard"];
    [query whereKey:@"PatMob" equalTo:appDelegate.customerMobile];
    [query whereKey:@"Check" equalTo:@"0"];
    [query orderByAscending:@"Date"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if ([objects count]) {
                unconfirmedAppts = objects.mutableCopy;
                for (PFObject *appt in unconfirmedAppts) {
                    NSString *docMob = appt[@"DocMob"];
                    if (![doctors valueForKey:docMob]) {
                        [self fetchDoctorDetails:docMob];
                    }
                }
//                dispatch_async(dispatch_get_main_queue(), ^ {
//                    [self.tableView reloadData];
//                });
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        dispatch_group_leave(serviceGroup);
    }];
    dispatch_group_notify(serviceGroup,dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });
}

- (void) fetchDoctorDetails: (NSString *) docMob {
    dispatch_group_enter(serviceGroup);
    PFQuery *query = [PFQuery queryWithClassName:@"Doctors"];
    [query whereKey:@"Mobile" equalTo:docMob];
    [query orderByDescending:@"Name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if ([objects count]) {
                dispatch_async(dispatch_get_main_queue(), ^ {
                    PFObject *doctor = [objects lastObject];
                    [doctors setValue:doctor forKey:docMob];
                    [self.tableView reloadData];
                });
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

#pragma mark - Table view data source

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"Confirmed Appointment";
//    }
//    else {
//        return @"Waiting to be confirmed...";
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return confirmedAppts.count;
    }
    else {
        return unconfirmedAppts.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdetifier = @"cell";
    AppointmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    
    PFObject *appointment;
    if (indexPath.section == 0) {
        appointment = confirmedAppts[indexPath.row];
    }
    else {
        appointment = unconfirmedAppts[indexPath.row];
    }
    
    cell.timeLbl.text = [NSString stringWithFormat:@"%@ %@:00", appointment[@"Date"], appointment[@"Time"]];
    
    NSString *docMob = appointment[@"DocMob"];
    PFObject *doctor = doctors[docMob];
    
    cell.nameLbl.text = doctor[@"Name"];
    cell.mobileLbl.text = doctor[@"Mobile"];
    cell.addressLbl.text = doctor[@"Address"];
    
    cell.imgView.layer.cornerRadius = cell.imgView.frame.size.width / 2.0;
    cell.imgView.clipsToBounds = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        UIImage *img = [UIImage imageWithData:[doctor [@"Image"] getData]];
        if(img) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgView.image = img;
            });
        }
        else {
            cell.imgView.image = [UIImage imageNamed:@"unknownavatar.png"];
        }
    });

    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    else {
        return YES;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            PFObject *appointment = unconfirmedAppts[indexPath.row];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Do you want to cancel this appointment?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [appointment deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                [unconfirmedAppts removeObject:appointment];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }];
            UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                [tableView setEditing:NO animated:YES];
            }];
            [alert addAction:yes];
            [alert addAction:no];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width - 10, 30)];
    [headerView addSubview:lbl];
    if (section == 0) {
        lbl.text = @"Confirmed Appointment";
    }
    else {
        lbl.text = @"Waiting to be confirmed...";
    }
    lbl.textColor = [UIColor whiteColor];
    //lbl.backgroundColor = [UIColor whiteColor];
    return  headerView;
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
