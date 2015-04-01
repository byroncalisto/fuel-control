//
//  EditFuelEntryViewController.m
//  FuelControl
//
//  Created by Papío on 3/29/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "EditFuelEntryViewController.h"

@interface EditFuelEntryViewController ()

@property (nonatomic, weak) IBOutlet UITextField *txtOdometer;
@property (nonatomic, weak) IBOutlet UITextField *txtTrip;
@property (nonatomic, weak) IBOutlet UITextField *txtQuantity;
@property (nonatomic, weak) IBOutlet UITextField *txtPricePerUnit;
@property (nonatomic, weak) IBOutlet UITextField *txtTotalPrice;
@property (nonatomic, weak) IBOutlet UITextField *txtCalculatedYield;
@property (nonatomic, weak) IBOutlet UITextField *txtReportedYield;
@property (nonatomic, weak) IBOutlet UILabel *lblDate;

@end

@implementation EditFuelEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.fuelEntry) {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.fuelEntry)
        return 1;
    
    return 2;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id textObject = [cell viewWithTag:1];
    
    if (textObject && [textObject isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)textObject;
        [textField becomeFirstResponder];
    }
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath;
    
    if (textField == self.txtOdometer)
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    else if (textField == self.txtTrip)
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    else if (textField == self.txtQuantity)
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    else if (textField == self.txtPricePerUnit)
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    else if (textField == self.txtTotalPrice)
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    else if (textField == self.txtReportedYield)
        indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

#pragma mark - Keyboard Notification Handling

- (void)keyboardWillAppear:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat totalHeight = navigationBarHeight;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        totalHeight += statusBarHeight;
    
    contentInsets = UIEdgeInsetsMake(totalHeight, 0.0, keyboardSize.height, 0.0);
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    CGFloat totalHeight = navigationBarHeight;
    
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        totalHeight += statusBarHeight;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(totalHeight, 0.0, tabBarHeight, 0.0);
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

@end
