//
//  DoctorListTableViewCell.h
//  DIS_System
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@end
