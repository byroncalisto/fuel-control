//
//  VehicleListViewController.m
//  FuelControl
//
//  Created by Papio on 2/25/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "VehicleListViewController.h"
#import "FuelingsTableViewController.h"
#import "DataManager.h"

@interface VehicleListViewController ()

@property (nonatomic, strong) NSFetchedResultsController *resultsController;

@end

@implementation VehicleListViewController

#pragma mark - View initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadVehicleData:)
                                                 name:DataManagerReadyNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadVehicleData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Vehicle Data management

- (void)loadVehicleData:(NSNotification *)notification
{
    [self reloadVehicleData];
}

- (void)reloadVehicleData
{
    DataManager *dataManager = [DataManager instance];
    
    if (dataManager.context) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Vehicle"];
        [fetchRequest setSortDescriptors:@[
                                           [NSSortDescriptor sortDescriptorWithKey:@"make" ascending:YES],
                                           [NSSortDescriptor sortDescriptorWithKey:@"model" ascending:YES]]];
        
        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:dataManager.context
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
        
        NSError *error;
        [self.resultsController performFetch:&error];
        
        
        if (error) {
            NSLog(@"Error during fetch: %@, %@", error, error.localizedDescription);
            abort();
        }
        else
            [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.resultsController)
        return [self.resultsController.sections count];
    
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleCell"];
        
        Vehicle *vehicleItem = (Vehicle *)[self.resultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", vehicleItem.make, vehicleItem.model, vehicleItem.year];
        
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.resultsController) {
        NSArray *sections = self.resultsController.sections;
        id<NSFetchedResultsSectionInfo> sectionInfo = sections[section];
        
        if ([sectionInfo numberOfObjects] == 0)
            return @"Tap Add to create a new Vehicle";
    }
    
    return @"Select a Vehicle";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"EditVehicleSegue" sender:indexPath];
}

#pragma mark - Edit Vehicle Delegate

- (void)vehicleDidSave:(EditVehicleViewController *)editVehicleVC
{
    [self reloadVehicleData];
    [editVehicleVC.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddVehicleSegue"]) {
        EditVehicleViewController *editVehicleVC = (EditVehicleViewController *)segue.destinationViewController;
        
        editVehicleVC.delegate = self;
        editVehicleVC.navigationItem.title = @"Add Vehicle";
    }
    else if ([segue.identifier isEqualToString:@"EditVehicleSegue"] && sender) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        EditVehicleViewController *editVehicleVC = (EditVehicleViewController *)segue.destinationViewController;
        
        editVehicleVC.delegate = self;
        editVehicleVC.vehicle = (Vehicle *)[self.resultsController objectAtIndexPath:indexPath];
        editVehicleVC.navigationItem.title = @"Edit Vehicle";
    }
    else if ([segue.identifier isEqualToString:@"EditFuelSegue"] && sender) {
        UITableViewCell *selectedCell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        FuelingsTableViewController *fuelingsTableVC = (FuelingsTableViewController *)segue.destinationViewController;
        
        Vehicle *selectedVehicle = (Vehicle *)[self.resultsController objectAtIndexPath:indexPath];
        fuelingsTableVC.vehicle = selectedVehicle;
        fuelingsTableVC.navigationItem.title = [NSString stringWithFormat:@"%@ %@ %@", selectedVehicle.make, selectedVehicle.model, selectedVehicle.year];
    }
}

@end
