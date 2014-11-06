#import "MLMiliPeripheral.h"
#import "MLCentralManager.h"
#import "MLHelper.h"

@implementation MLMiliPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral MACAddress:(NSString *)MACAddress central:(YMSCBCentralManager *)central {
    self = [super initWithPeripheral:peripheral central:central baseHi:0 baseLo:0];
    if (self) {
        MLMiliService *miliService = [[MLMiliService alloc] initWithPeripheral:self];
        self.serviceDict = @{
                             ML_SERVICE_MILI: miliService
                             };
        self.MACAddress = MACAddress;
    }
    return self;
}

- (void)connectWithUserInfo:(MLUserInfoModel *)userInfo block:(void (^)(MLMiliService *service, NSError *error))connectCallback {
    if (!userInfo) {
        NSLog(@"WARN: connect without auth.");
    }
    _userInfo = userInfo;
    [self connectWithOptions:nil withBlock:^(YMSCBPeripheral *yp, NSError *error) {
        if (error) {
            return connectCallback(nil, error);
        }
        [yp discoverServices:[self services] withBlock:^(NSArray *services, NSError *error) {
            if (error) {
                return connectCallback(nil, error);
            }
            MLMiliService *service = self.serviceDict[ML_SERVICE_MILI];
            [service discoverCharacteristics:[service characteristics] withBlock:^(NSDictionary *chDict, NSError *error) {
                if (error) {
                    return connectCallback(nil, error);
                }
                NSSet *notifySet = [NSSet setWithObjects:ML_CHARACTERISTIC_NOTIFICATION, ML_CHARACTERISTIC_REALTIME_STEPS, ML_CHARACTERISTIC_ACTIVITY_DATA, ML_CHARACTERISTIC_BATTERY_INFO, ML_CHARACTERISTIC_SENSOR_DATA, nil];
                MLCounter counter = [MLHelper counter:notifySet.count withBlock:^{
                    [service authorize:ML_AUTH_NORMAL withBlock:^(NSError *error) {
                        if (error) {
                            return connectCallback(nil, error);
                        } else {
                            connectCallback(service, nil);
                        }
                    }];
                }];
                for (NSString *chName in chDict) {
                    if ([notifySet containsObject:chName]) {
                        YMSCBCharacteristic *yc = chDict[chName];
                        [yc setNotifyValue:YES withBlock:^(NSError *error) {
                            if (error) {
                                return connectCallback(nil, error);
                            }
                            counter();
                        }];
                    }
                }
            }];
        }];
    }];
}

@end
