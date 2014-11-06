#import "MLCentralManager.h"
#import "MLHelper.h"

NSString *const ML_SERVICE_MILI = @"mili";

NSString *const ML_CHARACTERISTIC_DEVICE_INFO = @"deviceInfo";
NSString *const ML_CHARACTERISTIC_DEVICE_NAME = @"deviceName";
NSString *const ML_CHARACTERISTIC_NOTIFICATION = @"notification";
NSString *const ML_CHARACTERISTIC_USER_INFO = @"userInfo";
NSString *const ML_CHARACTERISTIC_CONTROL_POINT = @"controlPoint";
NSString *const ML_CHARACTERISTIC_REALTIME_STEPS = @"realtimeSteps";
NSString *const ML_CHARACTERISTIC_ACTIVITY_DATA = @"activityData";
NSString *const ML_CHARACTERISTIC_FIRMWARE_DATA = @"firmwareData";
NSString *const ML_CHARACTERISTIC_LEPARAMS = @"LEParams";
NSString *const ML_CHARACTERISTIC_DATETIME = @"datetime";
NSString *const ML_CHARACTERISTIC_STATISTICS = @"statistics";
NSString *const ML_CHARACTERISTIC_BATTERY_INFO = @"batteryInfo";
NSString *const ML_CHARACTERISTIC_TEST = @"test";
NSString *const ML_CHARACTERISTIC_SENSOR_DATA = @"sensorData";

static char *const kQueueLabel = "me.stormluke.miliios";
static NSString *const kMiliName = @"MI";

static MLCentralManager *sharedCentralManager;

@implementation MLCentralManager

+ (instancetype)initSharedManagerWithDelegate:(id)delegate {
    if (sharedCentralManager == nil) {
        dispatch_queue_t queue = dispatch_queue_create(kQueueLabel, 0);
        
        NSArray *nameList = @[kMiliName];
        sharedCentralManager = [[super allocWithZone:NULL] initWithKnownPeripheralNames:nameList
                                                                                  queue:queue
                                                                   useStoredPeripherals:YES
                                                                               delegate:delegate];
    }
    return sharedCentralManager;
    
}

+ (instancetype)sharedManager {
    if (sharedCentralManager == nil) {
        NSLog(@"ERROR: must call initSharedServiceWithDelegate: first.");
    }
    return sharedCentralManager;
}

- (void)scanForMilisWithBlock:(void (^)(MLMiliPeripheral *peripheral, NSNumber *RSSI, NSError *error))discoverCallback {
    [self scanForPeripheralsWithServices:nil
                                 options:@{ CBCentralManagerScanOptionAllowDuplicatesKey: @YES }
                               withBlock:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI, NSError *error) {
                                   if (!error) {
                                       MLMiliPeripheral *mili = [self handlePeripheral:peripheral advertisementData:advertisementData];
                                       if (mili) {
                                           return discoverCallback(mili, RSSI, error);
                                       }
                                   } else {
                                       discoverCallback(nil, nil, error);
                                   }
                               }];
}

- (MLMiliPeripheral *)handlePeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData {
    MLMiliPeripheral *mili = nil;
    YMSCBPeripheral *yp = [self findPeripheral:peripheral];
    if (yp == nil) {
        for (NSString *pname in self.knownPeripheralNames) {
            if ([pname isEqualToString:peripheral.name]) {
                NSData *advData = advertisementData[@"kCBAdvDataManufacturerData"];
                NSString *MACString = [[[[MLDataReader alloc] initWithData:advData] rePos:2] readMACAddressString];
                
                mili = [[MLMiliPeripheral alloc] initWithPeripheral:peripheral MACAddress:MACString central:self];
                [self addPeripheral:mili];
                break;
            }
        }
    }
    return mili;
}

@end
