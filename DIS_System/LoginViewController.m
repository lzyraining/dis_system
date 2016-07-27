//
//  LoginViewController.m
//  DIS_System
//
//  Created by swt on 5/16/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "LoginViewController.h"
#import "DoctorHomeViewController.h"
#import "CustomerHomeViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *mobileText;
@property (strong, nonatomic) IBOutlet UITextField *pwdText;
- (IBAction)loginBtn_Pressed:(id)sender;
- (IBAction)forgotPwdBtn_Pressed:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isDoctor) {
        self.title = @"Doctor";
    }else{
        
        self.title = @"Patient";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _mobileText) {
        [_pwdText becomeFirstResponder];
    }
    else if (textField == _pwdText){
        [_pwdText resignFirstResponder];
    }
    return YES;
}
- (IBAction)forgotPwdBtn_Pressed:(id)sender {

    // Check if mobile is blank
    if ([_mobileText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill in your mobile number" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
            return;
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // get password requests
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *pwdQuery;
    if (_isDoctor) {
        pwdQuery = [PFQuery queryWithClassName:@"Doctors"];
    }
    else {
        pwdQuery = [PFQuery queryWithClassName:@"Patients"];
    }
    [pwdQuery whereKey:@"Mobile" equalTo:_mobileText.text];
    [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (![objects count]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Mobile number not found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                    return ;
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password" message:[NSString stringWithFormat:@"Your login password is %@",[[objects lastObject] valueForKey:@"Password"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                _pwdText.text  = [[objects lastObject] valueForKey:@"Password"];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (IBAction)loginBtn_Pressed:(id)sender {
    // Check if mobile or password is blank
    if ([_mobileText.text isEqualToString:@""] || [_pwdText.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill in your mobile number and password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;

    }
    
    // Login requests
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *pwdQuery;
    if (_isDoctor) {
        pwdQuery = [PFQuery queryWithClassName:@"Doctors"];
    }
    else {
        pwdQuery = [PFQuery queryWithClassName:@"Patients"];
    }
    [pwdQuery whereKey:@"Mobile" equalTo:_mobileText.text];
    [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            if (![objects count]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Mobile number not found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                    
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return ;
            }

            if ([_pwdText.text isEqualToString:[[objects lastObject] valueForKey:@"Password"]]) {
                AppDelegate *mydelegate = [[UIApplication sharedApplication] delegate];
                if (_isDoctor) {
                    mydelegate.doctorMobile = _mobileText.text;
                    DoctorHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorHomeViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                else {
                    mydelegate.customerMobile = _mobileText.text;
                    CustomerHomeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerHomeViewController"];
                    [self.navigationController pushViewController:controller animated:YES];

                }
            }
            else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Wrong password" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                    
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return ;
            }
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
