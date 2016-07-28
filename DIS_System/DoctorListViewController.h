//
//  DoctorListViewController.h
//  DIS_System
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DoctorListViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) NSString *specialization;

@end
