//
//  DoctorListViewController.m
//  DIS_System
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "DoctorListViewController.h"
#import "DoctorListTableViewCell.h"
#import "DoctorDetailViewController.h"

@interface DoctorListViewController () {
    NSArray *doctorArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation DoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchDoctorList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchDoctorList{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Doctors"];
    [query whereKey:@"Specialization" equalTo:_specialization];
    [query orderByDescending:@"Name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (![objects count]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"No doctors"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                    
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                doctorArr = objects;
                [_tblView reloadData];
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return doctorArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdetifier = @"cell";
    DoctorListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    
    NSDictionary *doctor = doctorArr[indexPath.row];
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorDetailViewController"];
    controller.doctor = doctorArr[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)apptListBtn_Pressed:(id)sender {
    AppointmentListTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentListTableViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
