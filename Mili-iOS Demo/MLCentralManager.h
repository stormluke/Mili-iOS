#import <Foundation/Foundation.h>
#import <YmsCoreBluetooth/YMSCBCentralManager.h>
#import "MLMiliPeripheral.h"

extern NSString *const ML_SERVICE_MILI;

extern NSString *const ML_CHARACTERISTIC_DEVICE_INFO;
extern NSString *const ML_CHARACTERISTIC_DEVICE_NAME;
extern NSString *const ML_CHARACTERISTIC_NOTIFICATION;
extern NSString *const ML_CHARACTERISTIC_USER_INFO;
extern NSString *const ML_CHARACTERISTIC_CONTROL_POINT;
extern NSString *const ML_CHARACTERISTIC_REALTIME_STEPS;
extern NSString *const ML_CHARACTERISTIC_ACTIVITY_DATA;
extern NSString *const ML_CHARACTERISTIC_FIRMWARE_DATA;
extern NSString *const ML_CHARACTERISTIC_LEPARAMS;
extern NSString *const ML_CHARACTERISTIC_DATETIME;
extern NSString *const ML_CHARACTERISTIC_STATISTICS;
extern NSString *const ML_CHARACTERISTIC_BATTERY_INFO;
extern NSString *const ML_CHARACTERISTIC_TEST;
extern NSString *const ML_CHARACTERISTIC_SENSOR_DATA;

@interface MLCentralManager : YMSCBCentralManager

+ (instancetype)initSharedManagerWithDelegate:(id)delegate;
+ (instancetype)sharedManager;
- (void)scanForMilisWithBlock:(void (^)(MLMiliPeripheral *mili, NSNumber *RSSI, NSError *error))discoverCallback;

@end
