//
//  EditFuelEntryViewController.m
//  FuelControl
//
//  Created by Papío on 3/29/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "EditFuelEntryViewController.h"
#import "SettingsManager.h"

@interface EditFuelEntryViewController ()

@property (nonatomic, weak) IBOutlet UITextField *txtOdometer;
@property (nonatomic, weak) IBOutlet UITextField *txtTrip;
@property (nonatomic, weak) IBOutlet UITextField *txtQuantity;
@property (nonatomic, weak) IBOutlet UITextField *txtPricePerUnit;
@property (nonatomic, weak) IBOutlet UITextField *txtTotalPrice;
@property (nonatomic, weak) IBOutlet UITextField *txtCalculatedYield;
@property (nonatomic, weak) IBOutlet UITextField *txtReportedYield;
@property (nonatomic, weak) IBOutlet UITextField *txtDate;
@property (nonatomic, weak) IBOutlet UILabel *lblOdometer;
@property (nonatomic, weak) IBOutlet UILabel *lblTrip;
@property (nonatomic, weak) IBOutlet UILabel *lblQuantity;
@property (nonatomic, weak) IBOutlet UILabel *lblPricePerUnit;
@property (nonatomic, weak) IBOutlet UILabel *lblTotalPrice;
@property (nonatomic, weak) IBOutlet UILabel *lblCalculatedYield;
@property (nonatomic, weak) IBOutlet UILabel *lblReportedYield;

@property (nonatomic, weak) SettingsManager *settings;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation EditFuelEntryViewController

#pragma mark - View methods

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
    
    self.settings = [SettingsManager sharedSettings];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd-MMM-yyyy";
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate date];
    datePicker.maximumDate = [NSDate date];
    
    [datePicker addTarget:self
                   action:@selector(changeDate:)
         forControlEvents:UIControlEventValueChanged];
    
    self.txtDate.inputView = datePicker;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Display units in labels
    NSString *lengthSymbol = [self.settings getLengthSymbolFor:self.settings.lengthUnits];
    NSString *capacitySymbol = [self.settings getCapacitySymbolFor:self.settings.capacityUnits];
    NSString *currencySymbol = self.settings.currencySymbol;
    NSString *yieldSymbol = [self.settings getYieldSymbol];
    NSString *reportedYieldSymbol = [self.settings getReportedYieldSymbol];
    
    self.lblOdometer.text = [NSString stringWithFormat:@"%@ (%@)", self.lblOdometer.text, lengthSymbol];
    self.lblTrip.text = [NSString stringWithFormat:@"%@ (%@)", self.lblTrip.text, lengthSymbol];
    self.lblQuantity.text = [NSString stringWithFormat:@"%@ (%@)", self.lblQuantity.text, capacitySymbol];
    self.lblPricePerUnit.text = [NSString stringWithFormat:@"%@ (%@)", self.lblPricePerUnit.text, currencySymbol];
    self.lblTotalPrice.text = [NSString stringWithFormat:@"%@ (%@)", self.lblTotalPrice.text, currencySymbol];
    self.lblCalculatedYield.text = [NSString stringWithFormat:@"%@ (%@)", self.lblCalculatedYield.text, yieldSymbol];
    self.lblReportedYield.text = [NSString stringWithFormat:@"%@ (%@)", self.lblReportedYield.text, reportedYieldSymbol];
    
    self.txtOdometer.placeholder = lengthSymbol;
    self.txtTrip.placeholder = lengthSymbol;
    self.txtQuantity.placeholder = capacitySymbol;
    self.txtPricePerUnit.placeholder = currencySymbol;
    self.txtTotalPrice.placeholder = currencySymbol;
    self.txtCalculatedYield.placeholder = yieldSymbol;
    self.txtReportedYield.placeholder = reportedYieldSymbol;
    
    UIDatePicker *datePicker = (UIDatePicker *)self.txtDate.inputView;
    
    if (self.fuelEntry) {
        self.txtOdometer.text = [self.settings getFormattedUnits:[self.fuelEntry.odometer doubleValue]];
        self.txtTrip.text = [self.settings getFormattedUnits:[self.fuelEntry.trip doubleValue]];
        self.txtQuantity.text = [self.settings getFormattedUnits:[self.fuelEntry.quantity doubleValue]];
        self.txtPricePerUnit.text = [self.settings getFormattedPrice:[self.fuelEntry.pricePerUnit doubleValue] withSymbol:NO];
        self.txtTotalPrice.text = [self.settings getFormattedPrice:[self.fuelEntry.totalPrice doubleValue] withSymbol:NO];
        self.txtCalculatedYield.text = [self.settings getFormattedUnits:[self.fuelEntry.calculatedYield doubleValue]];
        
        if (self.fuelEntry.reportedYield)
            self.txtReportedYield.text = [self.settings getFormattedUnits:[self.fuelEntry.reportedYield doubleValue]];
        
        datePicker.date = self.fuelEntry.date;
    }
    
    self.txtDate.text = [self.dateFormatter stringFromDate:datePicker.date];
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
    else if (textField == self.txtDate)
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self cleanInput:textField];
    
    if (textField == self.txtQuantity || textField == self.txtPricePerUnit ||
        textField == self.txtTotalPrice || textField == self.txtTrip) {
        [self calculateTotals:textField];
    }
    
    if (textField == self.txtOdometer || textField == self.txtTrip ||
        textField == self.txtQuantity || textField == self.txtReportedYield) {
        double value = [textField.text doubleValue];
        textField.text = [self.settings getFormattedUnits:value];
    }
    else if (textField == self.txtPricePerUnit || self.txtTotalPrice) {
        double value = [textField.text doubleValue];
        textField.text = [self.settings getFormattedPrice:value withSymbol:NO];
    }
}

#pragma mark - Actions

- (void)changeDate:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.txtDate.text = [self.dateFormatter stringFromDate:datePicker.date];
}

- (IBAction)saveEntry:(id)sender
{
    NSString *validationErrors = [self validationErrors];
    
    if (!validationErrors) {
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot save"
                                                        message:[NSString stringWithFormat:@"The following fields have errors:\n%@", validationErrors]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
}

- (NSString *)validationErrors
{
    return nil;
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

#pragma mark - Private Methods

- (void)calculateTotals:(UITextField *)sender
{
    NSString *tripString = self.txtTrip.text;
    NSString *quantityString = self.txtQuantity.text;
    NSString *pricePerUnitString = self.txtPricePerUnit.text;
    NSString *totalPriceString = self.txtTotalPrice.text;
    
    if (quantityString.length > 0 && pricePerUnitString.length > 0 &&
        (sender == self.txtQuantity || sender == self.txtPricePerUnit)) {
        double quantityValue = [quantityString doubleValue];
        double pricePerUnitValue = [pricePerUnitString doubleValue];
        double totalPriceValue = quantityValue * pricePerUnitValue;
        
        self.txtTotalPrice.text = [self.settings getFormattedPrice:totalPriceValue withSymbol:NO];
    }
    else if (totalPriceString.length > 0 && pricePerUnitString.length > 0 &&
             (sender == self.txtTotalPrice || sender == self.txtPricePerUnit)) {
        double pricePerUnitValue = [pricePerUnitString doubleValue];
        double totalPriceValue = [totalPriceString doubleValue];
        double quantityValue = pricePerUnitValue > 0 ? totalPriceValue / pricePerUnitValue : 0;
        
        self.txtQuantity.text = [self.settings getFormattedUnits:quantityValue];
    }
    else if (quantityString.length > 0 && totalPriceString.length > 0 &&
             (sender == self.txtQuantity || sender == self.txtTotalPrice)) {
        double quantityValue = [quantityString doubleValue];
        double totalPriceValue = [totalPriceString doubleValue];
        double pricePerUnitValue = quantityValue > 0 ? totalPriceValue / quantityValue : 0;
        
        self.txtPricePerUnit.text = [self.settings getFormattedPrice:pricePerUnitValue withSymbol:NO];
    }
    
    if (tripString.length > 0 && quantityString.length > 0 &&
        (sender == self.txtTrip || sender == self.txtQuantity)) {
        double tripValue = [tripString doubleValue];
        double quantityValue = [quantityString doubleValue];
        double calculatedYieldValue = quantityValue > 0 ? tripValue / quantityValue : 0;
        
        self.txtCalculatedYield.text = [self.settings getFormattedUnits:calculatedYieldValue];
    }
}

- (void)cleanInput:(UITextField *)textField
{
    //First replace commas with periods.
    NSString *fieldText = textField.text;
    fieldText = [fieldText stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    //Extract only the numeric part
    NSError *error;
    
    NSString *numberRegEx = @"^\\d+(\\.\\d+)?$";
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:numberRegEx
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regEx matchesInString:fieldText
                                      options:NSMatchingReportCompletion
                                        range:NSMakeRange(0, textField.text.length)];
    
    if (matches && matches.count > 0) {
        NSTextCheckingResult *firstResult = (NSTextCheckingResult *)matches[0];
        textField.text = [fieldText substringWithRange:firstResult.range];
    }
}

@end
