Mili-iOS
========

[Mili (Xiaomi bracelet)](http://www.mi.com/shouhuan) iOS API and demo app. Current API based on firmware v1.0.3.0 (app v1.1.372).

![screenshots](http://ww3.sinaimg.cn/large/6ad06ebbjw1em1nybz9tcj20ek0cw3zj.jpg)

## API Example

```objc
MLCentralManager *manager = [MLCentralManager initSharedManagerWithDelegate:nil];
[manager scanForMilisWithBlock:^(MLMiliPeripheral *mili, NSNumber *RSSI, NSError *error) {
    userInfo = ...;
    [manager stopScan];
    [mili connectWithUserInfo:userInfo block:^(MLMiliService *service, NSError *error) {
        [service readDeviceInfoWithBlock:^(MLDeviceInfoModel *deviceInfo, NSError *error) {
            NSLog(@"%@", deviceInfo);
        }];
    }];
}];
```

Please check [MLCentralManager.h](https://github.com/stormluke/Mili-iOS/blob/master/Mili-iOS%20Demo/MLCentralManager.h), [MLMiliPeripheral.h](https://github.com/stormluke/Mili-iOS/blob/master/Mili-iOS%20Demo/MLMiliPeripheral.h), [MLMiliService.h](https://github.com/stormluke/Mili-iOS/blob/master/Mili-iOS%20Demo/MLMiliService.h) and the demo app for more details.

Note that current demo will use a fake user info for authentication, this will replace the old profile and cause mili vibrate (re-auth) when connected.

## TODO

- Send firmware
- More precise error
- Separate API from demo app
- Documents

## Thanks

- [dex2jar](https://code.google.com/p/dex2jar/)
- [Procyon](https://bitbucket.org/mstrobel/procyon)
- [YmsCoreBluetooth](https://github.com/kickingvegas/YmsCoreBluetooth)
- [LightBlue - Bluetooth Low Energy](https://itunes.apple.com/us/app/lightblue-bluetooth-low-energy/id557428110)
- [小米手环](http://www.mi.com/shouhuan)

## License

MIT
