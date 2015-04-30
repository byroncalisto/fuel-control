//
//  FuelingsTableViewController.m
//  FuelControl
//
//  Created by Papío on 3/26/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "FuelingsTableViewController.h"
#import "EditFuelEntryViewController.h"
#import "DataManager.h"
#import "SettingsManager.h"

@interface FuelingsTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, weak) SettingsManager *settings;

@end

@implementation FuelingsTableViewController

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd-MMM-yyyy";
    self.dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    self.settings = [SettingsManager sharedSettings];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadFuelEntries];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.resultsController)
        return self.resultsController.sections.count;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.resultsController) {
        NSArray *sections = self.resultsController.sections;
        id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
        
        return [sectionInfo numberOfObjects];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultsController) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FuelEntryCell"];
        FuelEntry *fuelEntry = (FuelEntry *)[self.resultsController objectAtIndexPath:indexPath];
        
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:1];
        UILabel *quantityLabel = (UILabel *)[cell viewWithTag:2];
        UILabel *totalPriceLabel = (UILabel *)[cell viewWithTag:3];
        
        dateLabel.text = [self.dateFormatter stringFromDate:fuelEntry.date];
        quantityLabel.text = [NSString stringWithFormat:@"%@ %@", [self.settings getFormattedUnits:[fuelEntry.quantity doubleValue]], [self.settings getCapacitySymbolFor:self.settings.capacityUnits]];
        totalPriceLabel.text = [self.settings getFormattedPrice:[fuelEntry.totalPrice doubleValue] withSymbol:YES];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Private methods

- (void)reloadFuelEntries
{
    DataManager *dataManager = [DataManager instance];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FuelEntry"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"vehicle == %@", self.vehicle];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:dataManager.context
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    
    NSError *error;
    
    [self.resultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Error fetching fuel entries for vehicle %@ %@ %@: %@", self.vehicle.make, self.vehicle.model, self.vehicle.year, error);
        abort();
    }
    else
        [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditFuelEntryViewController *editFuelEntryVC = (EditFuelEntryViewController *)segue.destinationViewController;
    editFuelEntryVC.vehicle = self.vehicle;
    editFuelEntryVC.delegate = self;
    
    if ([segue.identifier isEqualToString:@"AddFuelEntrySegue"]) {
        editFuelEntryVC.fuelEntry = nil;
        editFuelEntryVC.navigationItem.title = @"Add Fuel Entry";
    }
    else if ([segue.identifier isEqualToString:@"EditFuelEntrySegue"] && sender) {
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        
        editFuelEntryVC.fuelEntry = (FuelEntry *)[self.resultsController objectAtIndexPath:indexPath];
        editFuelEntryVC.navigationItem.title = @"Edit Fuel Entry";
    }
}

#pragma mark - Edit Fuel Entry delegate

- (void)fuelEntryDidSave:(EditFuelEntryViewController *)editFuelEntryVC
{
    [self reloadFuelEntries];
    [editFuelEntryVC.navigationController popViewControllerAnimated:YES];
}

@end
