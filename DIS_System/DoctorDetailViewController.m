//
//  DoctorDetailViewController.m
//  DIS_System
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "DoctorDetailViewController.h"
#import "AppointmentViewController.h"

@interface DoctorDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *specLbl;
@property (strong, nonatomic) IBOutlet UILabel *worktimeLbl;
@property (strong, nonatomic) IBOutlet UITextView *detailText;

- (IBAction)makeAppointmentBtn_Pressed:(id)sender;

@end

@implementation DoctorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareForView];
}

- (void) prepareForView {
    
    _nameLbl.text = _doctor[@"Name"];
    _specLbl.text = _doctor[@"Specialization"];
    
    _worktimeLbl.text = [[[_doctor[@"AvailableDate"] componentsJoinedByString:@","] stringByAppendingString:@"\n"] stringByAppendingString:_doctor[@"AvailableTime"]];

    _detailText.text = _doctor[@"Detail"];
    
    _imgIcon.layer.cornerRadius = _imgIcon.frame.size.width / 2;
    _imgIcon.clipsToBounds = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        UIImage *img = [UIImage imageWithData:[_doctor[@"Image"] getData]];
        if(img) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _imgIcon.image = img;
            });
        }
        else {
            _imgIcon.image = [UIImage imageNamed:@"unknownavatar.png"];
        }
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)makeAppointmentBtn_Pressed:(id)sender {
    AppointmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentViewController"];
    controller.doctor = _doctor;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)apptListBtn_Pressed:(id)sender {
    AppointmentListTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentListTableViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
