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
#import "DoctorListTableViewCell.h"
#import "DoctorDetailViewController.h"
#import "PatientHistoryViewController.h"
@interface CustomerHomeViewController () {
   NSArray *categoryArr;
    NSArray *doctorArr;
   CLGeocoder *geocoder;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)apptListBtn_Pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *presentView;
@property (weak, nonatomic) IBOutlet UITabBarItem *filterBtn_Tapped;
@property (strong, nonatomic) IBOutlet UIView *backMapView;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UIView *frontCollectionView;
@property (strong, nonatomic) IBOutlet UIView *listView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)mastBtn_Tapped:(UIButton *)sender;
- (IBAction)doctorBtn_Tapped:(UIButton *)sender;
- (IBAction)CardioBtn_Tapped:(UIButton *)sender;
- (IBAction)DentistBtn_Tapped:(UIButton *)sender;
- (IBAction)DermaBtn_Tapped:(UIButton *)sender;
- (IBAction)GynecoBtn_Tapped:(UIButton *)sender;
- (IBAction)OphthBtn_Tapped:(UIButton *)sender;
- (IBAction)PsychBtn_Tapped:(UIButton *)sender;
- (IBAction)MonBtn_Tapped:(UIButton *)sender;
- (IBAction)TuesBtn_Tapped:(UIButton *)sender;
- (IBAction)WednBtn_Tapped:(UIButton *)sender;
- (IBAction)ThurBtn_Tapped:(UIButton *)sender;
- (IBAction)FirBtn_Tapped:(UIButton *)sender;
- (IBAction)OKBtn_Tapped:(UIButton *)sender;

@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) NSMutableArray *specializationArray;
@property (strong, nonatomic) NSMutableArray *DayArray;
@property (strong, nonatomic) NSString *qualification;

@end

@implementation CustomerHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareData];
}

-(void)prepareData{
    _specializationArray = [[NSMutableArray alloc]init];
    _DayArray = [[NSMutableArray alloc]init];
    categoryArr = @[@"Cardiologist", @"Dentist", @"Dermatologist", @"Gynecologist", @"Ophthalmologist", @"Psychologist"];
    _frontCollectionView.frame = CGRectMake(0, 0, self.frontCollectionView.frame.size.width, self.frontCollectionView.frame.size.height);
    [_presentView addSubview:_frontCollectionView];
}

#pragma mark - API

-(void)fetchDataWithFilterInfo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Doctors"];
    [query whereKey:@"Specialization" equalTo:_specializationArray];
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
                NSLog(@"%@",objects);
                doctorArr = objects;
                [_tableView reloadData];
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

-(void)FetchAllData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Doctors"];
    
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
                NSLog(@"%@",objects);
                doctorArr = objects;
                [_tableView reloadData];
            });
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag == 0){
        [UIView transitionWithView:self.presentView duration:1.2 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            
            [self.listView removeFromSuperview];
            [self.backMapView removeFromSuperview];
            [self.frontCollectionView removeFromSuperview];
            [self.presentView addSubview:self.frontCollectionView];
            
        } completion:nil];
    }
    if(item.tag == 1){
        if (_filterView.window) {
            [UIView transitionWithView:self.presentView duration:1.2 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                [self fetchDataWithFilterInfo];
                
                [self.backMapView removeFromSuperview];
                [self.frontCollectionView removeFromSuperview];
                [self.filterView removeFromSuperview];
                [self.presentView addSubview:self.listView];
                _filterBtn_Tapped.title = @"filter";
            } completion:nil];
            
        }else{
            
            [UIView transitionWithView:self.presentView duration:1.2 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                
                [self.frontCollectionView removeFromSuperview];
                [self.backMapView removeFromSuperview];
                [self.listView removeFromSuperview];
                [self.presentView addSubview:self.filterView];
                _filterBtn_Tapped.title = @"list";
            } completion:nil];

        }
    }

    if(item.tag == 2){
        if (_listView.window) {
            [UIView transitionWithView:self.presentView duration:1.2 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                NSLog(@"%lu",(unsigned long)doctorArr.count);
                for (int i = 0; i<[doctorArr count]; i++) {
                    NSDictionary *doctor = [doctorArr objectAtIndex:i];
                    
                    [self revergeocoderWithAddress:doctor[@"Address"]];
                    NSLog(@"%@",[_addressArray objectAtIndex:i]);
                }
                [self.filterView removeFromSuperview];
                [self.frontCollectionView removeFromSuperview];
                [self.listView removeFromSuperview];
                [self.presentView addSubview:self.backMapView];
                _filterBtn_Tapped.title = @"map";
            } completion:nil];
            
        }else{
            
            [UIView transitionWithView:self.presentView duration:1.2 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                
                [self FetchAllData];
                [self.frontCollectionView removeFromSuperview];
                [self.filterView removeFromSuperview];
                [self.backMapView removeFromSuperview];
                [self.presentView addSubview:self.listView];
                _filterBtn_Tapped.title = @"list";
            } completion:nil];
        }
    }
    if(item.tag == 3){
        PatientHistoryViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientHistoryViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)revergeocoderWithAddress:(NSString *)address{
    
    geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks && [placemarks count]>0) {
            CLPlacemark *place = [placemarks lastObject];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:place];
            CLLocationCoordinate2D cordinate = placemark.coordinate;
            NSLog(@"Lat: %f & Long: %f",cordinate.latitude,cordinate.longitude);
            //[self searchLocal:placemark.location];
            
            MKCoordinateRegion regin = self.mapView.region;
            regin.center = [(CLCircularRegion*)placemark.region center];
            regin.span.longitudeDelta/=200.0;
            regin.span.latitudeDelta/=200.0;
            [self.mapView setRegion:regin animated:YES];
            [self.mapView addAnnotation:placemark];
            
        }
        
        
    }];
}

#pragma mark - Button

- (IBAction)mastBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _qualification = @"Master";
    }else{
        _qualification =nil;
    }
}

- (IBAction)doctorBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        _qualification =@"Doctor";
    }else{
        _qualification = nil;
    }
}

- (IBAction)CardioBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_specializationArray addObject:@"Cardiologist"];
    }else{
        [_specializationArray removeObject:@"Cardiologist"];
    }
}

- (IBAction)DentistBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_specializationArray addObject:@"Dentist"];
    }else{
        [_specializationArray removeObject:@"Dentist"];
    }
}

- (IBAction)DermaBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_specializationArray addObject:@"Dermatologist"];
    }else{
        [_specializationArray removeObject:@"Dermatologist"];
    }
}

- (IBAction)GynecoBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_specializationArray addObject:@"Gynecologist"];
    }else{
        [_specializationArray removeObject:@"Gynecologist"];
    }
}

- (IBAction)OphthBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_specializationArray addObject:@"Ophthalmologist"];
    }else{
        [_specializationArray removeObject:@"Ophthalmologist"];
    }
}

- (IBAction)PsychBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_specializationArray addObject:@"Psychologist"];
    }else{
        [_specializationArray removeObject:@"Psychologist"];
    }
}

- (IBAction)MonBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_DayArray addObject:@"Mon"];
    }else{
        [_DayArray removeObject:@"Mon"];
    }
}

- (IBAction)TuesBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_DayArray addObject:@"Tue"];
    }else{
        [_DayArray removeObject:@"Tue"];
    }
}

- (IBAction)WednBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_DayArray addObject:@"Wed"];
    }else{
        [_DayArray removeObject:@"Wed"];
    }
}

- (IBAction)ThurBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_DayArray addObject:@"Thu"];
    }else{
        [_DayArray removeObject:@"Thu"];
    }
}

- (IBAction)FirBtn_Tapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [_DayArray addObject:@"Fir"];
    }else{
        [_DayArray removeObject:@"Fir"];
    }
}

- (IBAction)OKBtn_Tapped:(UIButton *)sender {
    [self fetchDataWithFilterInfo];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)[doctorArr count]);
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

@end
