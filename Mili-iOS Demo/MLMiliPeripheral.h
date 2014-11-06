#import <Foundation/Foundation.h>
#import <YmsCoreBluetooth/YMSCBPeripheral.h>
#import "MLMiliService.h"

@interface MLMiliPeripheral : YMSCBPeripheral

@property (nonatomic, strong) NSString *MACAddress;
@property (nonatomic, strong) MLUserInfoModel *userInfo;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral MACAddress:(NSString *)MACAddress central:(YMSCBCentralManager *)central;
- (void)connectWithUserInfo:(MLUserInfoModel *)userInfo block:(void (^)(MLMiliService *service, NSError *error))connectCallback;

@end
