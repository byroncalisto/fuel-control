//
//  FuelingsTableViewController.m
//  FuelControl
//
//  Created by Papío on 3/26/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "FuelingsTableViewController.h"
#import "EditFuelEntryViewController.h"

@interface FuelingsTableViewController ()

@end

@implementation FuelingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EditFuelEntryViewController *editFuelEntryVC = (EditFuelEntryViewController *)segue.destinationViewController;
    editFuelEntryVC.vehicle = self.vehicle;
    
    
}

@end
