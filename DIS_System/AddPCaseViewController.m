//
//  AddPCaseViewController.m
//  DIS_System
//
//  Created by Zhuoyu Li on 7/28/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "AddPCaseViewController.h"
#import "AppDelegate.h"

@interface AddPCaseViewController ()
@property (weak, nonatomic) IBOutlet UITextField *caseNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *patientNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *patientMobileTextField;
@property (weak, nonatomic) IBOutlet UITextView *descripText;
@property (weak, nonatomic) IBOutlet UITextView *presecripText;
@property (weak, nonatomic) IBOutlet UITextView *suggestionText;

@property (strong, nonatomic) NSString *drName;

@end

@implementation AddPCaseViewController

@synthesize pCaseId = _pCaseId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Patient Case";
    [self fetchDoctorName];
    [self setup];
}

-(void)setup {
    if (![_pCaseId isEqualToString:@""]) {
        [self fetchPatientCase];
        _caseNameTextField.enabled = NO;
        _patientNameTextField.enabled = NO;
        _patientMobileTextField.enabled = NO;
        _descripText.editable = NO;
        _presecripText.editable = NO;
        _suggestionText.editable = NO;
    }
    else {
        UIBarButtonItem *submitBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submitCase:)];
        self.navigationItem.rightBarButtonItem = submitBtn;
    }
}

-(void)fetchPatientCase {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *caseQuery = [PFQuery queryWithClassName:@"PHistory"];
    [caseQuery whereKey:@"objectId" equalTo:_pCaseId];
    [caseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [objects lastObject];
            _patientNameTextField.text = [dict valueForKey:@"PName"];
            _caseNameTextField.text = [dict valueForKey:@"CaseName"];
            _patientMobileTextField.text = [dict valueForKey:@"PMobile"];
            _descripText.text = [dict valueForKey:@"Descrip"];
            _presecripText.text = [dict valueForKey:@"Prescription"];
            _suggestionText.text = [dict valueForKey:@"Suggestion"];
        }
    }];
}

-(void)submitCase: (id)sender {
    if ([_caseNameTextField.text  isEqual: @""] || [_patientMobileTextField.text  isEqual: @""] ||[_patientNameTextField.text isEqual:@""] || [_descripText.text isEqualToString:@""] || [_presecripText.text isEqualToString:@""] || [_suggestionText.text isEqualToString:@""]) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Alert" message:@"All fields are required" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        }];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }
    else {
        AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        PFObject *pHistory = [PFObject objectWithClassName:@"PHistory"];
        [pHistory setObject:appdelegate.doctorMobile forKey:@"DrMobile"];
        [pHistory setObject:_drName forKey:@"DrName"];
        [pHistory setObject:_patientNameTextField.text forKey:@"PName"];
        [pHistory setObject:_patientMobileTextField.text forKey:@"PMobile"];
        [pHistory setObject:_caseNameTextField.text forKey:@"CaseName"];
        [pHistory setObject:_descripText.text forKey:@"Descrip"];
        [pHistory setObject:_presecripText.text forKey:@"Prescription"];
        [pHistory setObject:_suggestionText.text forKey:@"Suggestion"];
        
        [pHistory saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                NSLog(@"%@",[error description]);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchDoctorName {
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    PFQuery *drQuery = [PFQuery queryWithClassName:@"Doctors"];
    [drQuery whereKey:@"Mobile" equalTo:appdelegate.doctorMobile];
    [drQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            _drName = [[objects lastObject] valueForKey:@"Name"];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_caseNameTextField resignFirstResponder];
    [_patientNameTextField resignFirstResponder];
    [_patientMobileTextField resignFirstResponder];
    [_descripText resignFirstResponder];
    [_presecripText resignFirstResponder];
    [_suggestionText resignFirstResponder];
}

#pragma mark- TextField and TextView Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}// called when 'return' key pressed. return NO to ignore.

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == _suggestionText) {
        [self animatedTextView:textView UP:YES Distance:270];
    }
    else if (textView == _presecripText) {
        [self animatedTextView:textView UP:YES Distance:200];
    }
    else if (textView == _descripText) {
        [self animatedTextView:textView UP:YES Distance:100];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == _suggestionText) {
        [self animatedTextView:textView UP:NO Distance:270];
    }
    else if (textView == _presecripText) {
        [self animatedTextView:textView UP:NO Distance:200];
    }
    else if (textView == _descripText) {
        [self animatedTextView:textView UP:NO Distance:100];
    }
}

-(void) animatedTextView: (id)text UP: (BOOL)up Distance: (int)movementDistance{
    const float movementDuration = 0.3f;
    int move = up ? -movementDistance:movementDistance;
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, move);
    [UIView commitAnimations];
}

@end
