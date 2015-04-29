//
//  SettingsManager.h
//  FuelControl
//
//  Created by Papío on 4/6/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

@import Foundation;

//Length units
typedef enum {
    FCKilometers = 0,
    FCMiles = 1
} FCLengthUnit;

//Capacity units
typedef enum {
    FCLiters = 10,
    FCGallonsUS = 11,
    FCGallonsImperial = 12
} FCCapacityUnit;

@interface SettingsManager : NSObject

@property (nonatomic) FCLengthUnit lengthUnits;
@property (nonatomic) FCCapacityUnit capacityUnits;
@property (nonatomic) FCLengthUnit reportedLengthUnits;
@property (nonatomic) FCCapacityUnit reportedCapacityUnits;
@property (nonatomic) NSInteger maxUnitsDecimals;
@property (nonatomic) NSInteger maxPriceDecimals;
@property (nonatomic, strong) NSString *currencySymbol;

+ (instancetype)sharedSettings;

- (NSString *)getLengthSymbolFor:(FCLengthUnit)lengthUnit;
- (NSString *)getCapacitySymbolFor:(FCCapacityUnit)capacityUnit;
- (NSString *)getYieldSymbol;
- (NSString *)getReportedYieldSymbol;

- (double)convert:(double)value fromLengthUnit:(FCLengthUnit)sourceLength toLengthUnit:(FCLengthUnit)targetLength;
- (double)convert:(double)value fromCapacityUnit:(FCCapacityUnit)sourceCapacity toCapacityUnit:(FCCapacityUnit)targetCapacity;

- (NSString *)getFormattedUnits:(double)units;
- (NSString *)getFormattedPrice:(double)price withSymbol:(BOOL)withSymbol;

@end
