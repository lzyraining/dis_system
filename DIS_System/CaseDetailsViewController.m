//
//  CaseDetailsViewController.m
//  DIS_System
//
//  Created by Zhuoyu Li on 7/28/16.
//  Copyright © 2016 Yang. All rights reserved.
//

#import "CaseDetailsViewController.h"

@interface CaseDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *caseNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *DrNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *DrMobileTextField;
@property (weak, nonatomic) IBOutlet UITextView *caseDescripTextField;
@property (weak, nonatomic) IBOutlet UITextView *prescripTextField;
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextView;

@end

@implementation CaseDetailsViewController

@synthesize pCaseId = _pCaseId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _caseNameTextField.enabled = NO;
    _DrNameTextField.enabled = NO;
    _DrMobileTextField.enabled = NO;
    _caseDescripTextField.editable = NO;
    _prescripTextField.editable = NO;
    _suggestionTextView.editable = NO;
    [self fetchPatientCase];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchPatientCase {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *caseQuery = [PFQuery queryWithClassName:@"PHistory"];
    [caseQuery whereKey:@"objectId" equalTo:_pCaseId];
    [caseQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dict = [objects lastObject];
                _DrNameTextField.text = [dict valueForKey:@"DrName"];
                _caseNameTextField.text = [dict valueForKey:@"CaseName"];
                _DrMobileTextField.text = [dict valueForKey:@"DrMobile"];
                _caseDescripTextField.text = [dict valueForKey:@"Descrip"];
                _prescripTextField.text = [dict valueForKey:@"Prescription"];
                _suggestionTextView.text = [dict valueForKey:@"Suggestion"];
            });
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

@end
