//
//  EditVehicleViewController.m
//  FuelControl
//
//  Created by Papío on 3/12/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "EditVehicleViewController.h"
#import "DataManager.h"

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
    
    if (self.vehicle) {
        self.txtMake.text = self.vehicle.make;
        self.txtModel.text = self.vehicle.model;
        self.txtYear.text = [NSString stringWithFormat:@"%@", self.vehicle.year];
    }
    
    [self.txtMake becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)saveVehicle:(id)sender
{
    DataManager *dataManager = [DataManager instance];
    NSString *validationErrors = [self validateForm];
    
    if (validationErrors.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Required Fields"
                                                        message:validationErrors
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    if (!self.vehicle) {
        //Add new vehicle
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:dataManager.context];
        self.vehicle = [[Vehicle alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:dataManager.context];
    }
    
    self.vehicle.make = self.txtMake.text;
    self.vehicle.model = self.txtModel.text;
    self.vehicle.year = [NSNumber numberWithInteger:[self.txtYear.text integerValue]];
    
    [dataManager saveDataObject:self.vehicle
          withCompletionHandler:^(BOOL success) {
              if (success)
                  [self.delegate vehicleDidSave:self];
          }];
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.vehicle)
        return 2;
    
    return 1;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 1) {
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete Vehicle"
                                                              message:@"Are you sure you want to permanently delete this vehicle and all its data?"
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles:@"Yes", nil];
        
        [deleteAlert show];
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

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        DataManager *dataManager = [DataManager instance];
        
        [dataManager.context deleteObject:self.vehicle];
        
        [dataManager saveDataObject:self.vehicle
              withCompletionHandler:^(BOOL success) {
                  if (success)
                      [self.delegate vehicleDidSave:self];
              }];
    }
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
