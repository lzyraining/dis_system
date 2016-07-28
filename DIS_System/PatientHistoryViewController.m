//
//  PatientHistoryViewController.m
//  DIS_System
//
//  Created by conandi on 16/7/28.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "PatientHistoryViewController.h"
#import "CaseDetailsViewController.h"

@interface PatientHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myHistoryTbView;
@property (strong, nonatomic) NSArray *historyArr;
@end

@implementation PatientHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchMyHistory];
}

-(void)fetchMyHistory {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    PFQuery *query = [PFQuery queryWithClassName:@"PHistory"];
    [query whereKey:@"PMobile" equalTo:appdelegate.customerMobile];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _historyArr = [[NSArray alloc] initWithArray:objects];
                [self.myHistoryTbView reloadData];
            });
        }
    }];
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

#pragma mark- TableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.historyArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHistoryCell" ];
    NSDictionary *dict = [_historyArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict valueForKey:@"CaseName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"createdAt"]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"My illnewss history";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [_historyArr objectAtIndex:indexPath.row];
    CaseDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CaseDetailsViewController"];
    controller.pCaseId = [dict valueForKey:@"objectId"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
