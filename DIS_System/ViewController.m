//
//  ViewController.m
//  DIS_System
//
//  Created by Zebin Yang on 5/13/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "DoctorRegisterViewController.h"
#import "CustomerRegisterViewController.h"

@interface ViewController ()
- (IBAction)loginBtn_Pressed:(id)sender;

- (IBAction)newDoctorePressed:(id)sender;
- (IBAction)newCustomer_Pressed:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Home";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn_Pressed:(id)sender {
    UIButton *btn = (UIButton *) sender;
    LoginViewController *controller = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if (btn.tag == 100) {
        controller.isDoctor = YES;
    }
    else {
        controller.isDoctor = NO;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}



- (IBAction)newDoctorePressed:(id)sender {
    DoctorRegisterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorRegisterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)newCustomer_Pressed:(id)sender {
    CustomerRegisterViewController *controller = [[UIStoryboard storyboardWithName:@"Main2" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerRegisterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
