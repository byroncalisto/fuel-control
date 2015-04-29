//
//  FuelEntry+FuelEntryExtensions.m
//  FuelControl
//
//  Created by Papío on 3/31/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "FuelEntry+FuelEntryExtensions.h"
#import "SettingsManager.h"

@implementation FuelEntry (FuelEntryExtensions)

#pragma mark - Store values converted to metric

- (void)storeOdometer:(double)odometer
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    self.odometer = [NSNumber numberWithDouble:[settings convert:odometer
                                                  fromLengthUnit:settings.lengthUnits
                                                    toLengthUnit:FCKilometers]];
}

- (void)storeTrip:(double)trip
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    self.trip = [NSNumber numberWithDouble:[settings convert:trip
                                              fromLengthUnit:settings.lengthUnits
                                                toLengthUnit:FCKilometers]];
}

- (void)storeQuantity:(double)quantity
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    self.quantity = [NSNumber numberWithDouble:[settings convert:quantity
                                                fromCapacityUnit:settings.capacityUnits
                                                  toCapacityUnit:FCLiters]];
}

- (void)storeCalculatedYield:(double)calculatedYield
{
    self.calculatedYield = [NSNumber numberWithDouble:[self convertYield:calculatedYield toUserUnits:NO IsReported:NO]];
}

- (void)storeReportedYield:(double)reportedYield
{
    self.reportedYield = [NSNumber numberWithDouble:[self convertYield:reportedYield toUserUnits:NO IsReported:YES]];
}

#pragma mark - Get values converted to user units

- (double)convertedOdometer
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    if (self.odometer)
        return [settings convert:[self.odometer doubleValue]
                  fromLengthUnit:FCKilometers
                    toLengthUnit:settings.lengthUnits];
    
    return 0.0;
}

- (double)convertedTrip
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    if (self.trip)
        return [settings convert:[self.trip doubleValue]
                  fromLengthUnit:FCKilometers
                    toLengthUnit:settings.lengthUnits];
    
    return 0.0;
}

- (double)convertedQuantity
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    if (self.quantity)
        return [settings convert:[self.quantity doubleValue]
                fromCapacityUnit:FCLiters
                  toCapacityUnit:settings.capacityUnits];
    
    return 0.0;
}

- (double)convertedCalculatedYield
{
    if (self.calculatedYield)
        return [self convertYield:[self.calculatedYield doubleValue]
                      toUserUnits:YES
                       IsReported:NO];
    
    return 0.0;
}

- (double)convertedReportedYield
{
    if (self.reportedYield)
        return [self convertYield:[self.reportedYield doubleValue]
                      toUserUnits:YES
                       IsReported:YES];
    
    return 0.0;
}

#pragma mark - Private methods

- (double)convertYield:(double)yield toUserUnits:(BOOL)userUnits IsReported:(BOOL)isReported
{
    SettingsManager *settings = [SettingsManager sharedSettings];
    
    double distance = [settings convert:yield
                         fromLengthUnit:(userUnits ? FCKilometers : (isReported ? settings.reportedLengthUnits : settings.lengthUnits))
                           toLengthUnit:(userUnits ? (isReported ? settings.reportedLengthUnits : settings.lengthUnits) : FCKilometers)];
    
    double volume = [settings convert:1.0
                     fromCapacityUnit:(userUnits ? FCLiters : (isReported ? settings.reportedCapacityUnits : settings.capacityUnits))
                       toCapacityUnit:(userUnits ? (isReported ? settings.reportedCapacityUnits : settings.capacityUnits) : FCLiters)];
    
    return distance / volume;
}

@end
