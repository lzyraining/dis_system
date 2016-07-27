//
//  DoctorRegisterViewController.m
//  DIS_System
//
//  Created by Zebin Yang on 5/13/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "DoctorRegisterViewController.h"

@interface DoctorRegisterViewController () {
    NSData *imgData;
}

@property (assign)NSUInteger scrollTime;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContents;
@property (weak, nonatomic) IBOutlet UITextField *nameTxFd;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxFd;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxFd;
@property (weak, nonatomic) IBOutlet UITextField *emailTxFd;
@property (weak, nonatomic) IBOutlet UITextField *addressTxFd;
@property (weak, nonatomic) IBOutlet UITextField *specializationTxFd;
@property (weak, nonatomic) IBOutlet UITextField *degreeTxFd;
@property (weak, nonatomic) IBOutlet UITextField *hospitalTxFd;
@property (weak, nonatomic) IBOutlet UITextView *detailTxVw;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;

- (IBAction)submitPressed:(id)sender;
- (IBAction)pickPressed:(id)sender;

@end

@implementation DoctorRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollTime = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _scrollTime++;
    [_scrollViewContents setContentOffset:CGPointMake(0,30*_scrollTime) animated:YES];
    [textField resignFirstResponder];
}



- (IBAction)submitPressed:(id)sender {
    if (_nameTxFd.text.length>0 && _passwordTxFd.text.length>0 && _mobileTxFd.text.length>0 && _emailTxFd.text.length>0 && _addressTxFd.text.length>0 && _specializationTxFd.text.length>0 && _degreeTxFd.text.length>0 && _hospitalTxFd.text.length>0 && _detailTxVw.text.length>0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        PFQuery *pwdQuery = [PFQuery queryWithClassName:@"Doctors"];
        [pwdQuery whereKey:@"Mobile" equalTo:_mobileTxFd.text];
        [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if ([objects count]>0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"password" message:[NSString stringWithFormat:@"Customer is already exsist"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                        
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{
                    PFObject *doctors = [PFObject objectWithClassName:@"Doctors"];
                    
                    [doctors setObject:_nameTxFd.text forKey:@"Name"];
                    [doctors setObject:_passwordTxFd.text forKey:@"Password"];
                    [doctors setObject:_specializationTxFd.text forKey:@"Specialization"];
                    [doctors setObject:_degreeTxFd.text forKey:@"Qualification"];
                    [doctors setObject:_emailTxFd.text forKey:@"EmailAddress"];
                    [doctors setObject:_addressTxFd.text forKey:@"Address"];
                    [doctors setObject:_mobileTxFd.text forKey:@"Mobile"];
                    [doctors setObject:_hospitalTxFd.text forKey:@"Hospital"];
                    [doctors setObject:@"N/A" forKey:@"AvailableTime"];
                    [doctors setObject:_detailTxVw.text forKey:@"Detail"];
                    
                    PFFile *imageFile = [PFFile fileWithData:imgData];
                    [doctors setObject:imageFile forKey:@"Image"];
                    
                    [doctors saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"More info needed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

- (IBAction)pickPressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker.sourceType =UIImagePickerControllerSourceTypeCamera;
    }else{
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}







#pragma mark- image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString * ,id> *)info{
    
    UIImage *img = info[UIImagePickerControllerEditedImage];
    _profileImg.image=img;
    imgData = UIImagePNGRepresentation(img);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
