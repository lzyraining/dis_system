//
//  ReviewViewController.m
//  DIS_System
//
//  Created by Zebin Yang on 5/19/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "ReviewViewController.h"

@interface ReviewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Reviews";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" ];
    cell.textLabel.text = @"Patient Name";
    cell.detailTextLabel.text = @"Appointment Date";
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Consulted Patients";
}

@end
