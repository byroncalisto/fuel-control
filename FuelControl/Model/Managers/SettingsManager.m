//
//  SettingsManager.m
//  FuelControl
//
//  Created by Papío on 4/6/15.
//  Copyright (c) 2015 PapiusSoft. All rights reserved.
//

#import "SettingsManager.h"

@interface SettingsManager ()

@property (nonatomic, strong) NSDictionary *symbolMap;
@property (nonatomic, strong) NSNumberFormatter *priceFormatter;
@property (nonatomic, strong) NSNumberFormatter *unitFormatter;

@end

@implementation SettingsManager

@synthesize lengthUnits = _lengthUnits;
@synthesize capacityUnits = _capacityUnits;
@synthesize reportedLengthUnits = _reportedLengthUnits;
@synthesize reportedCapacityUnits = _reportedCapacityUnits;
@synthesize maxUnitsDecimals = _maxUnitsDecimals;
@synthesize maxPriceDecimals = _maxPriceDecimals;
@synthesize currencySymbol = _currencySymbol;

#pragma mark - Initialization

+ (instancetype)sharedSettings
{
    static SettingsManager *_settingsManager;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        _settingsManager = [[SettingsManager alloc] init];
        [_settingsManager initializeSettings];
    });
    
    return _settingsManager;
}

- (void)initializeSettings
{
    self.symbolMap = @{
                       @(FCKilometers) : @"km",
                       @(FCMiles) : @"mi",
                       @(FCLiters) : @"lt",
                       @(FCGallonsImperial) : @"gal",
                       @(FCGallonsUS) :  @"gal"
                       };
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey:@"AppSettings"]) {
        NSDictionary *defaultSettings = @{
                                          @"LengthUnits" : @(FCKilometers),
                                          @"CapacityUnits" : @(FCLiters),
                                          @"ReportedLengthUnits" : @(FCKilometers),
                                          @"ReportedCapacityUnits" : @(FCLiters),
                                          @"MaxUnitsDecimals" : @2,
                                          @"MaxPriceDecimals" : @2,
                                          @"CurrencySymbol" : @"$"
                                          };
        
        [userDefaults setObject:defaultSettings forKey:@"AppSettings"];
        [userDefaults synchronize];
    }
    
    NSLocale *formatterLocale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    
    self.priceFormatter = [[NSNumberFormatter alloc] init];
    self.priceFormatter.locale = formatterLocale;
    self.priceFormatter.numberStyle = NSNumberFormatterNoStyle;
    self.priceFormatter.minimumFractionDigits = self.maxPriceDecimals;
    self.priceFormatter.maximumFractionDigits = self.maxPriceDecimals;
    self.priceFormatter.minimumIntegerDigits = 1;
    
    self.unitFormatter = [[NSNumberFormatter alloc] init];
    self.unitFormatter.locale = formatterLocale;
    self.unitFormatter.numberStyle = NSNumberFormatterNoStyle;
    self.unitFormatter.minimumFractionDigits = self.maxUnitsDecimals;
    self.unitFormatter.maximumFractionDigits = self.maxUnitsDecimals;
    self.unitFormatter.minimumIntegerDigits = 1;
}

#pragma mark - User Settings

- (FCLengthUnit)lengthUnits
{
    if (!_lengthUnits)
        _lengthUnits = [(NSNumber *)[self getSettingWithKey:@"LengthUnits"] intValue];
    
    return _lengthUnits;
}

- (void)setLengthUnits:(FCLengthUnit)lengthUnits
{
    _lengthUnits = lengthUnits;
    [self setSettingWithObject:@(lengthUnits) forKey:@"LengthUnits"];
}

- (FCCapacityUnit)capacityUnits
{
    if (!_capacityUnits)
        _capacityUnits = [(NSNumber *)[self getSettingWithKey:@"CapacityUnits"] intValue];
    
    return _capacityUnits;
}

- (void)setCapacityUnits:(FCCapacityUnit)capacityUnits
{
    _capacityUnits = capacityUnits;
    [self setSettingWithObject:@(capacityUnits) forKey:@"CapacityUnits"];
}

- (FCLengthUnit)reportedLengthUnits
{
    if (!_reportedLengthUnits)
        _reportedLengthUnits = [(NSNumber *)[self getSettingWithKey:@"ReportedLengthUnits"] intValue];
    
    return _reportedLengthUnits;
}

- (void)setReportedLengthUnits:(FCLengthUnit)reportedLengthUnits
{
    _reportedLengthUnits = reportedLengthUnits;
    [self setSettingWithObject:@(reportedLengthUnits) forKey:@"ReportedLengthUnits"];
}

- (FCCapacityUnit)reportedCapacityUnits
{
    if (!_reportedCapacityUnits)
        _reportedCapacityUnits = [(NSNumber *)[self getSettingWithKey:@"ReportedCapacityUnits"] intValue];
    
    return _reportedCapacityUnits;
}

- (void)setReportedCapacityUnits:(FCCapacityUnit)reportedCapacityUnits
{
    _reportedCapacityUnits = reportedCapacityUnits;
    [self setSettingWithObject:@(reportedCapacityUnits) forKey:@"ReportedCapacityUnits"];
}

- (NSInteger)maxUnitsDecimals
{
    if (!_maxUnitsDecimals)
        _maxUnitsDecimals = [(NSNumber *)[self getSettingWithKey:@"MaxUnitsDecimals"] integerValue];
    
    return _maxUnitsDecimals;
}

- (void)setMaxUnitsDecimals:(NSInteger)maxUnitsDecimals
{
    _maxUnitsDecimals = maxUnitsDecimals;
    [self setSettingWithObject:@(maxUnitsDecimals) forKey:@"MaxUnitsDecimals"];
}

- (NSInteger)maxPriceDecimals
{
    if (!_maxPriceDecimals)
        _maxPriceDecimals = [(NSNumber *)[self getSettingWithKey:@"MaxPriceDecimals"] integerValue];
    
    return _maxPriceDecimals;
}

- (void)setMaxPriceDecimals:(NSInteger)maxPriceDecimals
{
    _maxPriceDecimals = maxPriceDecimals;
    [self setSettingWithObject:@(maxPriceDecimals) forKey:@"MaxPriceDecimals"];
}

- (NSString *)currencySymbol
{
    if (!_currencySymbol)
        _currencySymbol = (NSString *)[self getSettingWithKey:@"CurrencySymbol"];
    
    return _currencySymbol;
}

- (void)setCurrencySymbol:(NSString *)currencySymbol
{
    _currencySymbol = currencySymbol;
    [self setSettingWithObject:currencySymbol forKey:@"CurrencySymbol"];
}

#pragma mark - User Defaults getter and setter

- (id)getSettingWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appSettings = (NSDictionary *)[userDefaults objectForKey:@"AppSettings"];
    
    if (appSettings[key])
        return appSettings[key];
    
    return nil;
}

- (void)setSettingWithObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *appSettings = [(NSDictionary *)[userDefaults objectForKey:@"AppSettings"] mutableCopy];
    
    [appSettings setObject:object forKey:key];
    
    [userDefaults setObject:appSettings forKey:@"AppSettings"];
    [userDefaults synchronize];
}

#pragma mark - Symbol methods

- (NSString *)getLengthSymbolFor:(FCLengthUnit)lengthUnit
{
    return self.symbolMap[@(lengthUnit)];
}

- (NSString *)getCapacitySymbolFor:(FCCapacityUnit)capacityUnit
{
    return self.symbolMap[@(capacityUnit)];
}

- (NSString *)getYieldSymbol
{
    return [NSString stringWithFormat:@"%@ / %@",
            [self getLengthSymbolFor:self.lengthUnits],
            [self getCapacitySymbolFor:self.capacityUnits]];
}

- (NSString *)getReportedYieldSymbol
{
    return [NSString stringWithFormat:@"%@ / %@",
            [self getLengthSymbolFor:self.reportedLengthUnits],
            [self getCapacitySymbolFor:self.reportedCapacityUnits]];
}

#pragma mark - Conversion methods

- (double)convert:(double)value fromLengthUnit:(FCLengthUnit)sourceLength toLengthUnit:(FCLengthUnit)targetLength
{
    if (sourceLength == targetLength)
        return value;
    
    if (sourceLength == FCKilometers && targetLength == FCMiles)
        return value * 0.621371192237334;
    
    return value * 1.609344;
}

- (double)convert:(double)value fromCapacityUnit:(FCCapacityUnit)sourceCapacity toCapacityUnit:(FCCapacityUnit)targetCapacity
{
    if (sourceCapacity == targetCapacity)
        return value;
    
    if (sourceCapacity == FCLiters && targetCapacity == FCGallonsUS)
        return value * 0.2641720523581484;
    else if (sourceCapacity == FCLiters && targetCapacity == FCGallonsImperial)
        return value * 0.21996924829908776;
    else if (sourceCapacity == FCGallonsUS && targetCapacity == FCGallonsImperial)
        return value * 0.832674188148;
    else if (sourceCapacity == FCGallonsUS && targetCapacity == FCLiters)
        return value * 3.7854118;
    else if (sourceCapacity == FCGallonsImperial && targetCapacity == FCGallonsUS)
        return value * 1.20094992043;
    else
        return value * 4.54609;
}

#pragma mark - Formatted price methods

- (NSString *)getFormattedPrice:(double)price withSymbol:(BOOL)withSymbol
{
    NSString *formattedPrice = [self.priceFormatter stringFromNumber:@(price)];
    
    if (withSymbol)
        return [NSString stringWithFormat:@"%@ %@", self.currencySymbol, formattedPrice];
    
    return formattedPrice;
}

- (NSString *)getFormattedUnits:(double)units
{
    return [self.unitFormatter stringFromNumber:@(units)];
}

@end
