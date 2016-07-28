//
//  ReviewViewController.m
//  DIS_System
//
//  Created by Zebin Yang on 5/19/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "ReviewViewController.h"
#import "AddPCaseViewController.h"
#import "AppDelegate.h"

@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSArray *patientCase;
@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Patient Reviews";
    UIBarButtonItem *addCase = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPatientCase:)];
    self.navigationItem.rightBarButtonItem = addCase;
    // Do any additional setup after loading the view.
}

-(void)addPatientCase: (id)sender {
    AddPCaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPCaseViewController"];
    controller.pCaseId = @"";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self fetchMyPatientCase];
}

-(void)fetchMyPatientCase {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *pCaseQuery = [PFQuery queryWithClassName:@"PHistory"];
    [pCaseQuery whereKey:@"DrMobile" equalTo:appdelegate.doctorMobile];
    [pCaseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                _patientCase = [[NSArray alloc] initWithArray:objects];
                [self.tblView reloadData];
            });
        }
    }];
}

#pragma mark- TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.patientCase count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    NSDictionary *pDict = [_patientCase objectAtIndex:indexPath.row];
    cell.textLabel.text = [pDict valueForKey:@"PName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[pDict valueForKey:@"createdAt"]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Consulted Patients";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_patientCase objectAtIndex:indexPath.row];
    AddPCaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPCaseViewController"];
    controller.pCaseId = [dict valueForKey:@"objectId"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
