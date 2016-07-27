//
//  CustomerHomeViewController.m
//  DIS_System
//
//  Created by swt on 5/13/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "CustomerHomeViewController.h"
#import "DoctorCategoryCollectionViewCell.h"
#import "DoctorListViewController.h"

@interface CustomerHomeViewController () {
   NSArray *categoryArr;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)apptListBtn_Pressed:(id)sender;


@end

@implementation CustomerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    categoryArr = @[@"Cardiologist", @"Dentist", @"Dermatologist", @"Gynecologist", @"Ophthalmologist", @"Psychologist"];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return categoryArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoctorCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",categoryArr[indexPath.item]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DoctorListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorListViewController"];
    controller.specialization = categoryArr[indexPath.item];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)apptListBtn_Pressed:(id)sender {
    AppointmentListTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AppointmentListTableViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
