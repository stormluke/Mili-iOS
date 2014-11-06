#import <Foundation/Foundation.h>
#import <YmsCoreBluetooth/YMSCBService.h>
#import <YmsCoreBluetooth/YMSCBCharacteristic.h>
#import "MLModel.h"

typedef void (^MLErrorHandler)(NSError *error);

typedef void (^MLRealtimeStepsHandler)(NSUInteger realtimeSteps, NSError *error);
typedef void (^MLActivityDataHandler)(NSArray *activityDataFragmentList, NSError *error);
typedef void (^MLBatteryInfoHandler)(MLBatteryInfoModel *batteryInfo, NSError *error);
typedef void (^MLSensorDataHandler)(NSUInteger index, NSInteger x, NSInteger y, NSInteger z, NSError *error);

typedef NS_ENUM(NSUInteger, MLCharacteristic) {
    ML_CH_DEVICE_INFO = 0xff01,
    ML_CH_DEVICE_NAME,
    ML_CH_NOTIFICATION,
    ML_CH_USER_INFO,
    ML_CH_CONTROL_POINT,
    ML_CH_REALTIME_STEPS,
    ML_CH_ACTIVITY_DATA,
    ML_CH_FIRMWARE_DATA,
    ML_CH_LEPARAMS,
    ML_CH_DATETIME,
    ML_CH_STATISTICS,
    ML_CH_BATTERY_INFO,
    ML_CH_TEST,
    ML_CH_SENSOR_DATA
};

typedef NS_ENUM(NSUInteger, MLControlPoint) {
    ML_CP_REALTIME_STEPS_NOTIFICATION = 3,
    ML_CP_TIMER,
    ML_CP_GOAL,
    ML_CP_FETCH_DATA,
    ML_CP_FIRMWARE_INFO,
    ML_CP_SEND_NOTIFICATION,
    ML_CP_RESET,
    ML_CP_CONFIRM_DATA,
    ML_CP_SYNC,
    ML_CP_REBOOT,
    ML_CP_COLOR = 14,
    ML_CP_WEAR_LOCATION,
    ML_CP_REALTIME_STEPS,
    ML_CP_STOP_SYNC,
    ML_CP_SENSOR_DATA,
    ML_CP_STOP_VIBRATE
};

typedef NS_ENUM(NSUInteger, MLNotificationType) {
    ML_NOTIFICATION_NORMAL,
    ML_NOTIFICATION_CALL
};

typedef NS_ENUM(NSUInteger, MLWearLocation) {
    ML_WEAR_LOCATION_LEFT,
    ML_WEAR_LOCATION_RIGHT
};

typedef NS_ENUM(NSUInteger, MLTestCommand) {
    ML_TEST_REMOTE_DISCONNECT = 1,
    ML_TEST_SELFTEST,
    ML_TEST_NOTIFICATION,
    ML_TEST_DISCONNECTED_REMINDER = 5
};

@interface MLMiliService : YMSCBService

- (instancetype)initWithPeripheral:(YMSCBPeripheral *)peripheral;

#pragma mark - authorization

- (MLUserInfoModel *)userInfo;
- (void)setUserInfo:(MLUserInfoModel *)userInfo;
- (void)authorize:(MLAuthType)type withBlock:(MLErrorHandler)writeCallback;

#pragma mark - basicInfo

- (void)readDeviceInfoWithBlock:(void (^)(MLDeviceInfoModel *deviceInfo, NSError *error))readCallback;

- (void)readDeviceNameWithBlock:(void (^)(NSString *deviceName, NSError *error))readCallback;
- (void)writeDeviceName:(NSString *)deviceName withBlock:(MLErrorHandler)writeCallback;

- (void)readUserInfoWithBlock:(void (^)(MLUserInfoModel *userInfo, NSError *error))readCallback;
- (void)writeUserInfo:(MLUserInfoModel *)userInfo withBlock:(MLErrorHandler)writeCallback;

- (void)readReatimeStepsWithBlock:(MLRealtimeStepsHandler)readCallback;

- (void)readLEParamsWithBlock:(void (^)(MLLEParamsModel *LEParams, NSError *error))readCallback;
- (void)writeLEParams:(MLLEParamsModel *)LEParams withBlock:(MLErrorHandler)writeCallback;
- (void)writeHighLEParamsWithBlock:(MLErrorHandler)writeCallback;
- (void)writeLowLEParamsWithBlock:(MLErrorHandler)writeCallback;

- (void)readDatetimeWithBlock:(void (^)(MLDateTimeModel *datetime, NSError *error))readCallback;
- (void)writeDatetime:(MLDateTimeModel *)datetime withBlock:(MLErrorHandler)writeCallback;

- (void)readStatisticsWithBlock:(void (^)(MLStatisticsModel *statistics, NSError *error))readCallback;
- (void)writeStatistics:(MLStatisticsModel *)statistics withBlock:(MLErrorHandler)writeCallback;

- (void)readBatteryInfoWithBlock:(MLBatteryInfoHandler)readCallback;
- (void)writeBatteryInfo:(MLBatteryInfoModel *)batteryInfo withBlock:(MLErrorHandler)writeCallback;

- (void)readActivityDataWithBlock:(MLActivityDataHandler)activityDataHandler;

#pragma mark - controlPoint

- (void)enableRealtimeStepsNotification:(BOOL)isEnable withBlock:(MLErrorHandler)writeCallback;
- (void)enableSensorData:(BOOL)isEnable withBlock:(MLErrorHandler)writeCallback;
- (void)doSetAlarmClock:(MLAlarmClockModel *)alarmClock withBlock:(MLErrorHandler)writeCallback;
- (void)doSetGoal:(NSUInteger)goal withBlock:(MLErrorHandler)writeCallback;
- (void)doSendNotification:(MLNotificationType)type withBlock:(MLErrorHandler)writeCallback;
- (void)doFactoryResetWithBlock:(MLErrorHandler)writeCallback;
- (void)doSyncWithBlock:(MLErrorHandler)writeCallback;
- (void)doRebootWithBlock:(MLErrorHandler)writeCallback;
- (void)doSetColorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue blink:(BOOL)blink withBlock:(MLErrorHandler)writeCallback;
- (void)doSetWearLocation:(MLWearLocation)wearLocation withBlock:(MLErrorHandler)writeCallback;
- (void)doSetRealtimeSteps:(NSUInteger)realtimeSteps withBlock:(MLErrorHandler)writeCallback;
- (void)doStopSyncWithBlock:(MLErrorHandler)writeCallback;
- (void)doStopVibrateWithBlock:(MLErrorHandler)writeCallback;

- (void)testRemoteDisconnectWithBlock:(MLErrorHandler)writeCallback;
- (void)testSelfWithBlock:(MLErrorHandler)writeCallback;
- (void)testNotifyWithBlock:(MLErrorHandler)writeCallback;
- (void)testDisconnectedReminderWithBlock:(MLErrorHandler)writeCallback;

#pragma mark - subscribe

- (void)subscribeRealtimeStepsWithBlock:(MLRealtimeStepsHandler)realtimeStepsHandler;
- (void)stopSubscribeRealtimeStepsWithBlock:(MLErrorHandler)writeCallback;
- (void)subscribeSensorDataWithBlock:(MLSensorDataHandler)sensorDataHandler;
- (void)stopSubscribeSensorDataWithBlock:(MLErrorHandler)writeCallback;
- (void)subscribeBatteryInfoWithBlock:(MLBatteryInfoHandler)batteryInfoHandler;
- (void)stopSubscribeBatteryInfoWithBlock:(MLErrorHandler)writeCallback;

@end
