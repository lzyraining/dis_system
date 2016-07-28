//
//  RecordsViewController.m
//  DIS_System
//
//  Created by Zebin Yang on 5/19/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "RecordsViewController.h"

@interface RecordsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *patientTbView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmentBtn;

@property (strong, nonatomic) NSMutableArray *patientList;
@property (strong, nonatomic) NSMutableArray *patientData;
@end

@implementation RecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Patients List";
    // Do any additional setup after loading the view.
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

-(void)fetchPatientHistory: (NSString*)queryString {
    PFQuery *query = [PFQuery queryWithClassName:@"PHistory"];
    if (_sgmentBtn.selectedSegmentIndex == 0) {
        [query whereKey:@"PName" equalTo:_searchBar.text];
    }
    else if(_sgmentBtn.selectedSegmentIndex == 1) {
        [query whereKey:@"PMobile" equalTo:_searchBar.text];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _patientData = [[NSMutableArray alloc] init];
                _patientList = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in objects) {
                    if (![_patientList containsObject:[dict valueForKey:@"PMobile"]]) {
                        [_patientList addObject:[dict valueForKey:@"PMobile"]];
                        [_patientData addObject:[dict valueForKey:@"PName"]];
                    }
                }
                [self.patientTbView reloadData];
            });
        }
    }];
}


#pragma mark- TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.patientList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientCell" ];
    NSString *pMobile = [_patientList objectAtIndex:indexPath.row];
    NSString *pName = [_patientData objectAtIndex:indexPath.row];
    cell.textLabel.text = pName;
    cell.detailTextLabel.text = pMobile;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Patients illnewss history";
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = [_patientCase objectAtIndex:indexPath.row];
//    AddPCaseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPCaseViewController"];
//    controller.pCaseId = [dict valueForKey:@"objectId"];
//    [self.navigationController pushViewController:controller animated:YES];
//}

#pragma mark- SearchBar Delegate Method 
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchPatientHistory:searchBar.text];
}// called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED {
    
}// called when cancel button pressed

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
}

@end
