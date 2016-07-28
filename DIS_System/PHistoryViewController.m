//
//  PHistoryViewController.m
//  DIS_System
//
//  Created by Zhuoyu Li on 7/28/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "PHistoryViewController.h"
#import "AddPCaseViewController.h"

@interface PHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *pHistoryTbView;
@property (strong, nonatomic) NSArray *patientArr;
@end

@implementation PHistoryViewController

@synthesize pName = _pName;
@synthesize pMobile = _pMobile;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPatientHistory];
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

-(void)fetchPatientHistory {
    PFQuery *query = [PFQuery queryWithClassName:@"PHistory"];
    [query whereKey:@"PMobile" equalTo:_pMobile];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _patientArr = [[NSArray alloc] initWithArray:objects];
                [self.pHistoryTbView reloadData];
            });
        }
    }];
}

#pragma mark- TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.patientArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phistroyCell" ];
    NSDictionary *dict = [_patientArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict valueForKey:@"CaseName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"createdAt"]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Patients illnewss history";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_patientArr objectAtIndex:indexPath.row];
    AddPCaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPCaseViewController"];
    controller.pCaseId = [dict valueForKey:@"objectId"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
