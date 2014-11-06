#import "MLMiliService.h"
#import "MLCentralManager.h"
#import "MLHelper.h"

typedef NS_ENUM(NSInteger, MLActivityDataState) {
    ML_AD_STATE_BEGINNING,
    ML_AD_STATE_MIDDLE
};

@interface MLMiliService ()

@property (nonatomic, strong) MLRealtimeStepsHandler realtimeStepsHandler;
@property (nonatomic, strong) MLRealtimeStepsHandler realtimeStepsCallback;
@property (nonatomic, strong) MLBatteryInfoHandler batteryInfoHandler;
@property (nonatomic, strong) MLBatteryInfoHandler batteryInfoCallback;
@property (nonatomic, strong) MLSensorDataHandler sensorDataHandler;
@property (nonatomic, strong) MLActivityDataHandler activityDataHandler;

@property (nonatomic, strong) MLActivityDataReader *activityDataReader;

@end

@implementation MLMiliService

- (instancetype)initWithPeripheral:(YMSCBPeripheral *)peripheral {
    self = [super initWithName:@"mili" parent:peripheral baseHi:0 baseLo:0 serviceOffset:0xfee0];
    if (self) {
        [self addCharacteristic:ML_CHARACTERISTIC_DEVICE_INFO withAddress:ML_CH_DEVICE_INFO];
        [self addCharacteristic:ML_CHARACTERISTIC_DEVICE_NAME withAddress:ML_CH_DEVICE_NAME];
        [self addCharacteristic:ML_CHARACTERISTIC_NOTIFICATION withAddress:ML_CH_NOTIFICATION];
        [self addCharacteristic:ML_CHARACTERISTIC_USER_INFO withAddress:ML_CH_USER_INFO];
        [self addCharacteristic:ML_CHARACTERISTIC_CONTROL_POINT withAddress:ML_CH_CONTROL_POINT];
        [self addCharacteristic:ML_CHARACTERISTIC_REALTIME_STEPS withAddress:ML_CH_REALTIME_STEPS];
        [self addCharacteristic:ML_CHARACTERISTIC_ACTIVITY_DATA withAddress:ML_CH_ACTIVITY_DATA];
        [self addCharacteristic:ML_CHARACTERISTIC_FIRMWARE_DATA withAddress:ML_CH_FIRMWARE_DATA];
        [self addCharacteristic:ML_CHARACTERISTIC_LEPARAMS withAddress:ML_CH_LEPARAMS];
        [self addCharacteristic:ML_CHARACTERISTIC_DATETIME withAddress:ML_CH_DATETIME];
        [self addCharacteristic:ML_CHARACTERISTIC_STATISTICS withAddress:ML_CH_STATISTICS];
        [self addCharacteristic:ML_CHARACTERISTIC_BATTERY_INFO withAddress:ML_CH_BATTERY_INFO];
        [self addCharacteristic:ML_CHARACTERISTIC_TEST withAddress:ML_CH_TEST];
        [self addCharacteristic:ML_CHARACTERISTIC_SENSOR_DATA withAddress:ML_CH_SENSOR_DATA];
    }
    return self;
}

#pragma mark - authorization

- (MLUserInfoModel *)userInfo {
    MLMiliPeripheral *mili = (MLMiliPeripheral *)self.parent;
    return mili.userInfo;
}

- (void)setUserInfo:(MLUserInfoModel *)userInfo {
    MLMiliPeripheral *mili = (MLMiliPeripheral *)self.parent;
    mili.userInfo = userInfo;
}

- (void)authorize:(MLAuthType)type withBlock:(MLErrorHandler)writeCallback {
    [self userInfo].type = type;
    [self writeUserInfo:[self userInfo] withBlock:writeCallback];
}

#pragma mark - deviceInfo

- (void)readDeviceInfoWithBlock:(void (^)(MLDeviceInfoModel *deviceInfo, NSError *error))readCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_DEVICE_INFO];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            return readCallback(nil, error);
        }
        MLDeviceInfoModel *deviceInfo = [[MLDeviceInfoModel alloc] initWithData:data];
        readCallback(deviceInfo, nil);
    }];
}

#pragma mark - deviceName

- (void)readDeviceNameWithBlock:(void (^)(NSString *deviceName, NSError *error))readCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_DEVICE_NAME];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            return readCallback(nil, error);
        }
        NSString *deviceName = [[[MLDataReader alloc] initWithData:data] readString:20];
        readCallback(deviceName, nil);
    }];
}

- (void)writeDeviceName:(NSString *)deviceName withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_DEVICE_NAME];
    NSData *stringData = [[[[MLDataBuilder alloc] init] writeString:deviceName bytesCount:20] data];
    [yc writeValue:stringData withBlock:writeCallback];
}

#pragma mark - userInfo

- (void)readUserInfoWithBlock:(void (^)(MLUserInfoModel *userInfo, NSError *error))readCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_USER_INFO];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            return readCallback(nil, error);
        }
        MLUserInfoModel *userInfo = [[MLUserInfoModel alloc] initWithData:data];
        readCallback(userInfo, nil);
    }];
}

- (void)writeUserInfo:(MLUserInfoModel *)userInfo withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_USER_INFO];
    [yc writeValue:[userInfo data] withBlock:writeCallback];
}

#pragma mark - realtimeSteps

- (void)readReatimeStepsWithBlock:(void (^)(NSUInteger realtimeSteps, NSError *error))readCallback {
    _realtimeStepsCallback = readCallback;
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_REALTIME_STEPS];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {}];
}

#pragma mark - LEParams

- (void)writeHighLEParamsWithBlock:(MLErrorHandler)writeCallback {
    MLLEParamsModel *LEParams = [[MLLEParamsModel alloc] init];
    LEParams.connIntMin = 460;
    LEParams.connIntMax = 500;
    LEParams.timeout = 500;
    [self writeLEParams:LEParams withBlock:writeCallback];
}

- (void)writeLowLEParamsWithBlock:(MLErrorHandler)writeCallback {
    MLLEParamsModel *LEParams = [[MLLEParamsModel alloc] init];
    LEParams.connIntMin = 39;
    LEParams.connIntMax = 49;
    LEParams.timeout = 500;
    [self writeLEParams:LEParams withBlock:writeCallback];
}

- (void)readLEParamsWithBlock:(void (^)(MLLEParamsModel *LEParams, NSError *error))readCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_LEPARAMS];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            return readCallback(nil, error);
        }
        MLLEParamsModel *LEParams = [[MLLEParamsModel alloc] initWithData:data];
        readCallback(LEParams, nil);
    }];
}

- (void)writeLEParams:(MLLEParamsModel *)LEParams withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_LEPARAMS];
    [yc writeValue:[LEParams data] withBlock:writeCallback];
}

#pragma mark - datetime

- (void)readDatetimeWithBlock:(void (^)(MLDateTimeModel *datetime, NSError *error))readCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_DATETIME];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            return readCallback(nil, error);
        }
        MLDateTimeModel *datetime = [[MLDateTimeModel alloc] initWithData:data];
        readCallback(datetime, nil);
    }];
}

- (void)writeDatetime:(MLDateTimeModel *)datetime withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_DATETIME];
    [yc writeValue:[datetime data] withBlock:writeCallback];
}

#pragma mark - statistics

- (void)readStatisticsWithBlock:(void (^)(MLStatisticsModel *statistics, NSError *error))readCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_STATISTICS];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            return readCallback(nil, error);
        }
        MLStatisticsModel *statistics = [[MLStatisticsModel alloc] initWithData:data];
        readCallback(statistics, nil);
    }];
}

- (void)writeStatistics:(MLStatisticsModel *)statistics withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_STATISTICS];
    [yc writeValue:[statistics data] withBlock:writeCallback];
}

#pragma mark - batteryInfo

- (void)readBatteryInfoWithBlock:(MLBatteryInfoHandler)readCallback {
    _batteryInfoCallback = readCallback;
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_BATTERY_INFO];
    [yc readValueWithBlock:^(NSData *data, NSError *error) {}];
}

- (void)writeBatteryInfo:(MLBatteryInfoModel *)batteryInfo withBlock:(void (^)(NSError *error))writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_BATTERY_INFO];
    [yc writeValue:[batteryInfo data] withBlock:writeCallback];
}

#pragma mark - activityData

- (void)readActivityDataWithBlock:(MLActivityDataHandler)activityDataHandler {
    _activityDataReader = [[MLActivityDataReader alloc] init];
    _activityDataHandler = activityDataHandler;
    [self doStartFetchActivityDataWithBlock:^(NSError *error) {
        if (error) {
            return activityDataHandler(nil, error);
        }
    }];
}

#pragma mark - controlPoint

- (void) writeControlPointWithWork:(void (^)(MLDataBuilder *builder))builderWork withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_CONTROL_POINT];
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    builderWork(builder);
    [yc writeValue:[builder data] withBlock:writeCallback];
}

- (void)enableRealtimeStepsNotification:(BOOL)isEnable withBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_REALTIME_STEPS_NOTIFICATION bytesCount:1];
        [builder writeInt:isEnable bytesCount:1];
    } withBlock:writeCallback];
}

- (void)enableSensorData:(BOOL)isEnable withBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_SENSOR_DATA bytesCount:1];
        [builder writeInt:isEnable bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doSetAlarmClock:(MLAlarmClockModel *)alarmClock withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_CONTROL_POINT];
    [yc writeValue:[alarmClock data] withBlock:writeCallback];
}

- (void)doSetGoal:(NSUInteger)goal withBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_GOAL bytesCount:1];
        [builder writeInt:0 bytesCount:1];
        [builder writeInt:goal bytesCount:2];
    } withBlock:writeCallback];
}

- (void)doStartFetchActivityDataWithBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_FETCH_DATA bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doSendNotification:(MLNotificationType)type withBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_SEND_NOTIFICATION bytesCount:1];
        [builder writeInt:type bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doFactoryResetWithBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_RESET bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doSyncWithBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_SYNC bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doRebootWithBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_REBOOT bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doSetColorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue blink:(BOOL)blink withBlock:(void (^)(NSError *error))writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_COLOR bytesCount:1];
        [builder writeColorWithRed:red green:green blue:blue blink:blink];
    } withBlock:writeCallback];
}

- (void)doSetWearLocation:(MLWearLocation)wearLocation withBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_WEAR_LOCATION bytesCount:1];
        [builder writeInt:wearLocation bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doSetRealtimeSteps:(NSUInteger)realtimeSteps withBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_REALTIME_STEPS bytesCount:1];
        [builder writeInt:realtimeSteps bytesCount:2];
    } withBlock:writeCallback];
}

- (void)doStopSyncWithBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_STOP_SYNC bytesCount:1];
    } withBlock:writeCallback];
}

- (void)doStopVibrateWithBlock:(MLErrorHandler)writeCallback {
    [self writeControlPointWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_CP_STOP_VIBRATE bytesCount:1];
    } withBlock:writeCallback];
}

#pragma mark - test

- (void)writeTestWithWork:(void (^)(MLDataBuilder *builder))builderWork withBlock:(MLErrorHandler)writeCallback {
    YMSCBCharacteristic *yc = self.characteristicDict[ML_CHARACTERISTIC_TEST];
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    builderWork(builder);
    [yc writeValue:[builder data] withBlock:writeCallback];
}

- (void)testRemoteDisconnectWithBlock:(MLErrorHandler)writeCallback {
    [self writeTestWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_TEST_REMOTE_DISCONNECT bytesCount:1];
    } withBlock:writeCallback];
}

- (void)testSelfWithBlock:(MLErrorHandler)writeCallback {
    [self writeTestWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_TEST_SELFTEST bytesCount:1];
    } withBlock:writeCallback];
}

- (void)testNotifyWithBlock:(MLErrorHandler)writeCallback {
    [self writeTestWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_TEST_NOTIFICATION bytesCount:1];
    } withBlock:writeCallback];
}

- (void)testDisconnectedReminderWithBlock:(MLErrorHandler)writeCallback {
    [self writeTestWithWork:^(MLDataBuilder *builder) {
        [builder writeInt:ML_TEST_DISCONNECTED_REMINDER bytesCount:1];
    } withBlock:writeCallback];
}

#pragma mark - subscribeNotify

- (void)subscribeRealtimeStepsWithBlock:(MLRealtimeStepsHandler)realtimeStepsHandler {
    _realtimeStepsHandler = realtimeStepsHandler;
    [self enableRealtimeStepsNotification:YES withBlock:^(NSError *error) {
        if (error) {
            return _realtimeStepsHandler(0, error);
        }
        [self readReatimeStepsWithBlock:^(NSUInteger realtimeSteps, NSError *error) {}];
    }];
}

- (void)stopSubscribeRealtimeStepsWithBlock:(MLErrorHandler)writeCallback {
    [self enableRealtimeStepsNotification:NO withBlock:^(NSError *error) {
        _realtimeStepsHandler = nil;
        if (error) {
            return writeCallback(error);
        }
        writeCallback(nil);
    }];
}

- (void)subscribeSensorDataWithBlock:(MLSensorDataHandler)sensorDataHandler {
    _sensorDataHandler = sensorDataHandler;
    [self enableSensorData:YES withBlock:^(NSError *error) {
        if (error) {
            return _sensorDataHandler(0, 0, 0, 0, error);
        }
    }];
}

- (void)stopSubscribeSensorDataWithBlock:(void (^)(NSError *error))writeCallback {
    [self enableSensorData:NO withBlock:^(NSError *error) {
        _sensorDataHandler = nil;
        if (error) {
            return writeCallback(error);
        }
        writeCallback(nil);
    }];
}

- (void)subscribeBatteryInfoWithBlock:(MLBatteryInfoHandler)batteryInfoHandler {
    _batteryInfoHandler = batteryInfoHandler;
}

- (void)stopSubscribeBatteryInfoWithBlock:(MLErrorHandler)writeCallback {
    _batteryInfoHandler = nil;
}

#pragma mark - notifyHandler

- (void)notifyCharacteristicHandler:(YMSCBCharacteristic *)yc error:(NSError *)error {
//    NSLog(@"Nofity: %@ = %@", yc.name, yc.cbCharacteristic.value);
    if ([yc.name isEqualToString:ML_CHARACTERISTIC_NOTIFICATION]) {
        return [self handleMLNotification:yc error:error];
    } else if ([yc.name isEqualToString:ML_CHARACTERISTIC_REALTIME_STEPS]) {
        return [self handleMLRealtimeSteps:yc error:error];
    } else if ([yc.name isEqualToString:ML_CHARACTERISTIC_ACTIVITY_DATA]) {
        return [self handleMLActivityData:yc error:error];
    } else if ([yc.name isEqualToString:ML_CHARACTERISTIC_BATTERY_INFO]) {
        return [self handleMLBatteryInfo:yc error:error];
    } else if ([yc.name isEqualToString:ML_CHARACTERISTIC_SENSOR_DATA]) {
        return [self handleMLSensorData:yc error:error];
    } else {
        NSLog(@"WARN: No notify handler");
    }
}

- (void)handleMLNotification:(YMSCBCharacteristic *)yc error:(NSError *)error {
    NSLog(@"%@, %@", yc.name, yc.cbCharacteristic.value);
}

- (void)handleMLRealtimeSteps:(YMSCBCharacteristic *)yc error:(NSError *)error {
    if (error) {
        if (_realtimeStepsCallback) {
            _realtimeStepsCallback(0, error);
            _realtimeStepsCallback = nil;
        }
        return _realtimeStepsHandler(0, error);
    }
    MLDataReader *reader = [[MLDataReader alloc] initWithData:yc.cbCharacteristic.value];
    NSUInteger realtimeSteps = [reader readInt:2];
    if (_realtimeStepsCallback) {
        _realtimeStepsCallback(realtimeSteps, nil);
        _realtimeStepsCallback = nil;
    }
    _realtimeStepsHandler(realtimeSteps, nil);
}

- (void)handleMLActivityData:(YMSCBCharacteristic *)yc error:(NSError *)error {
    if (error) {
        return _activityDataHandler(nil, error);
    }
    [_activityDataReader appendData:yc.cbCharacteristic.value];
    if ([_activityDataReader isDone]) {
        _activityDataHandler([_activityDataReader activityDataFragmentList], nil);
        _activityDataHandler = nil;
        _activityDataReader = nil;
    }
}

- (void)handleMLBatteryInfo:(YMSCBCharacteristic *)yc error:(NSError *)error {
    if (error) {
        if (_batteryInfoCallback) {
            _batteryInfoCallback(nil, error);
            _batteryInfoCallback = nil;
        }
        if (_batteryInfoHandler) {
            _batteryInfoHandler(nil, error);
        }
        return;
    }
    MLBatteryInfoModel *batteryInfo = [[MLBatteryInfoModel alloc] initWithData:yc.cbCharacteristic.value];
    if (_batteryInfoCallback) {
        _batteryInfoCallback(batteryInfo, nil);
        _batteryInfoCallback = nil;
    }
    if (_batteryInfoHandler) {
        _batteryInfoHandler(batteryInfo, nil);
    }
}

- (void)handleMLSensorData:(YMSCBCharacteristic *)yc error:(NSError *)error {
    if (error) {
        return _sensorDataHandler(0, 0, 0, 0, error);
    }
    MLDataReader *reader = [[MLDataReader alloc] initWithData:yc.cbCharacteristic.value];
    NSUInteger index = [reader readInt:2];
    while ([reader bytesLeftCount] >= 3) {
        NSInteger x = [reader readSensorData];
        NSInteger y = [reader readSensorData];
        NSInteger z = [reader readSensorData];
        _sensorDataHandler(index, x, y, z, nil);
    }
}

@end
