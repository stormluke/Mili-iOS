Mili-iOS
========

[Mili (Xiaomi bracelet)](http://www.mi.com/shouhuan) iOS API and demo app. Current API based on firmware v1.0.3.0 (app v1.1.372).

## API Example

```objc
MLCentralManager *manager = [MLCentralManager initSharedManagerWithDelegate:nil];
[manager scanForMilisWithBlock:^(MLMiliPeripheral *mili, NSNumber *RSSI, NSError *error) {
        userInfo = ...;
        [mili connectWithUserInfo:userInfo block:^(MLMiliService *service, NSError *error) {
                [service readDeviceInfoWithBlock:^(MLDeviceInfoModel *deviceInfo, NSError *error) {
                    NSLog(@"%@", deviceInfo);
            }];
        }];
}];
```

Please check [MLCentralManager.h](), [MLMiliPeripheral.h](), [MLMiliService.h]() and the demo app for more details.

## TODO

- Send firmware
- More precise error
- Separate API from demo app
- Documents

## Thanks

- [Procyon](https://bitbucket.org/mstrobel/procyon)
- [YmsCoreBluetooth](https://github.com/kickingvegas/YmsCoreBluetooth)
- [LightBlue - Bluetooth Low Energy](https://itunes.apple.com/us/app/lightblue-bluetooth-low-energy/id557428110)
- [小米手环](http://www.mi.com/shouhuan)

## License

MIT
