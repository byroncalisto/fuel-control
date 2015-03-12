//
//  Vehicle.h
//  FuelControl
//
//  Created by Papío on 3/11/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FuelEntry;

@interface Vehicle : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *fuelEntries;
@end

@interface Vehicle (CoreDataGeneratedAccessors)

- (void)addFuelEntriesObject:(FuelEntry *)value;
- (void)removeFuelEntriesObject:(FuelEntry *)value;
- (void)addFuelEntries:(NSSet *)values;
- (void)removeFuelEntries:(NSSet *)values;

@end
