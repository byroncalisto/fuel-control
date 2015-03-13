//
//  EditVehicleViewController.m
//  FuelControl
//
//  Created by Papío on 3/12/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "EditVehicleViewController.h"

@interface EditVehicleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtMake;
@property (weak, nonatomic) IBOutlet UITextField *txtModel;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;

@end

@implementation EditVehicleViewController

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.txtMake becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)saveVehicle:(id)sender
{
    NSString *validationErrors = [self validateForm];
    
    if (validationErrors.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:validationErrors
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}


#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.txtMake)
        [self.txtModel becomeFirstResponder];
    else if (textField == self.txtModel)
        [self.txtYear becomeFirstResponder];
    else
        [self.txtYear resignFirstResponder];
    
    return NO;
}

#pragma mark - Private Methods

- (NSString *)validateForm
{
    NSMutableString *validationMessage = [[NSMutableString alloc] init];
    
    if (self.txtMake.text.length == 0)
        [validationMessage appendString:@"Make Required.\n"];
    
    if (self.txtModel.text.length == 0)
        [validationMessage appendString:@"Model Required.\n"];
    
    if (self.txtYear.text.length == 0)
        [validationMessage appendString:@"Year Required."];
    
    return validationMessage;
}

@end
