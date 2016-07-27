//
//  CustomerRegisterViewController.m
//  DIS_System
//
//  Created by swt on 5/13/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "CustomerRegisterViewController.h"


@interface CustomerRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *mobileText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
- (IBAction)SignUpBtn_Pressed:(id)sender;

@end

@implementation CustomerRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameText) {
        [_mobileText becomeFirstResponder];
    }
    else if (textField == _mobileText) {
        [_emailText becomeFirstResponder];
    }
    else if (textField == _emailText) {
        [_pwdText becomeFirstResponder];
    }
    else if (textField == _pwdText){
        [_pwdText resignFirstResponder];
    }
    return YES;
}

- (BOOL) inputIsValid {
    // Not Empty
    if (!(_nameText.text.length > 0 && _pwdText.text.length > 0 && _mobileText.text.length == 10 && _emailText.text.length > 0) ) {
        return false;
    }
    // Email
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:_emailText.text]) {
        return false;
    }
    
    return true;
}


- (IBAction)SignUpBtn_Pressed:(id)sender {
    if ([self inputIsValid]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PFQuery *pwdQuery = [PFQuery queryWithClassName:@"Patients"];
        [pwdQuery whereKey:@"Email" equalTo:_emailText.text];
        [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([objects count]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Email is already exsist"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                        
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
            }
        }];
        
        
        pwdQuery = [PFQuery queryWithClassName:@"Patients"];
        [pwdQuery whereKey:@"Mobile" equalTo:_mobileText.text];
        [pwdQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if ([objects count]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Mobile number is already exsist"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                        
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                else{
                    PFObject *patients = [PFObject objectWithClassName:@"Patients"];
                    [patients setValue:_nameText.text forKey:@"Name"];
                    [patients setValue:_pwdText.text forKey:@"Password"];
                    [patients setValue:_mobileText.text forKey:@"Mobile"];
                    [patients setValue:_emailText.text forKey:@"Email"];
                    
                    [patients saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                    }];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat:@"Registered succesfully!"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
                        [self.navigationController popViewControllerAnimated:NO];
                        
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
                
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Invalid input" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction  *_Nonnull action) {
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}
@end
