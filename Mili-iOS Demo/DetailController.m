#import "DetailController.h"
#import "MLCentralManager.h"
#import "AlarmController.h"
#import "ColorController.h"

typedef NS_ENUM(NSInteger, MLDBasicSection) {
    MLD_DEVICE_NAME,
    MLD_DEVICE_INFO,
    MLD_LEPARAMS,
    MLD_STATISTICS,
    MLD_BATTERY_INFO,
    MLD_DATETIME,
    MLD_REALTIME_STEPS = 100,
    MLD_ACTIVITY_DATA,
    MLD_SENSOR_DATA,
    MLD_SEND_NOTIFICATION = 200,
    MLD_WEAR_LOCATION,
    MLD_GOAL,
    MLD_COLOR,
    MLD_ALARM_CLOCK
};

@interface DetailController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *realtimeSteps;
@property (weak, nonatomic) IBOutlet UILabel *datetime;
@property (weak, nonatomic) IBOutlet UILabel *sensorData;

@property (nonatomic, strong) NSIndexPath *deselectIndexPath;

@property (nonatomic, strong) UIActionSheet *sendNotificationActionSheet;
@property (nonatomic, strong) UIActionSheet *wearLocationActionSheet;

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.clearsSelectionOnViewWillAppear = YES;
    
    [_service readDeviceNameWithBlock:^(NSString *deviceName, NSError *error) {
        _deviceName.text = deviceName;
    }];
    [_service subscribeRealtimeStepsWithBlock:^(NSUInteger realtimeSteps, NSError *error) {
        _realtimeSteps.text = [NSString stringWithFormat:@"%i", realtimeSteps];
    }];
    [self refreshDatetime];
    [_service subscribeSensorDataWithBlock:^(NSUInteger index, NSInteger x, NSInteger y, NSInteger z, NSError *error) {
        _sensorData.text = [NSString stringWithFormat:@"%i, %i, %i", x, y, z];
    }];
}

- (void)refreshDatetime {
    MLDateTimeModel *datetime = [[MLDateTimeModel alloc] init];
    datetime.newerDate = [NSDate date];
    [_service writeDatetime:datetime withBlock:^(NSError *error) {
        [_service readDatetimeWithBlock:^(MLDateTimeModel *datetime, NSError *error) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            _datetime.text = [dateFormatter stringFromDate:datetime.olderDate];
        }];
    }];
}

- (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message indexPath:(NSIndexPath *)indexPath {
    NSString *content = [message stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
    return alert;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section * 100 + indexPath.row) {
        case MLD_DEVICE_NAME:
        case MLD_REALTIME_STEPS:
        case MLD_SENSOR_DATA:
            return nil;
            break;
        default:
            return indexPath;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section * 100 + indexPath.row) {
        case MLD_DEVICE_INFO: {
            [_service readDeviceInfoWithBlock:^(MLDeviceInfoModel *deviceInfo, NSError *error) {
                [self showAlertWithTitle:@"DeviceInfo" message:deviceInfo.description indexPath:indexPath];
            }];
            break;
        }
        case MLD_LEPARAMS: {
            [_service readLEParamsWithBlock:^(MLLEParamsModel *LEParams, NSError *error) {
                [self showAlertWithTitle:@"LEParams" message:LEParams.description indexPath:indexPath];
            }];
            break;
        }
        case MLD_STATISTICS: {
            [_service readStatisticsWithBlock:^(MLStatisticsModel *statistics, NSError *error) {
                [self showAlertWithTitle:@"Statistics" message:statistics.description indexPath:indexPath];
            }];
            break;
        }
        case MLD_BATTERY_INFO: {
            [_service readBatteryInfoWithBlock:^(MLBatteryInfoModel *batteryInfo, NSError *error) {
                [self showAlertWithTitle:@"BatteryInfo" message:batteryInfo.description indexPath:indexPath];
            }];
            break;
        }
        case MLD_DATETIME: {
            [self refreshDatetime];
            [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case MLD_ACTIVITY_DATA: {
            [_service stopSubscribeRealtimeStepsWithBlock:^(NSError *error) {}];
            [_service stopSubscribeSensorDataWithBlock:^(NSError *error) {}];
            UIAlertView *alert = [self showAlertWithTitle:@"ActivityData" message:@"loading..." indexPath:indexPath];
            [_service readActivityDataWithBlock:^(NSArray *activityDataFragmentList, NSError *error) {
                alert.message = activityDataFragmentList.description;
            }];
            break;
        }
        case MLD_SEND_NOTIFICATION: {
            _sendNotificationActionSheet = [[UIActionSheet alloc] initWithTitle:@"SendNotification" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Normal", @"Call", nil];
            [_sendNotificationActionSheet showInView:self.view];
            _deselectIndexPath = indexPath;
            break;
        }
        case MLD_WEAR_LOCATION: {
            _wearLocationActionSheet = [[UIActionSheet alloc] initWithTitle:@"WearLocation" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Left hand", @"Right hand", nil];
            [_wearLocationActionSheet showInView:self.view];
            _deselectIndexPath = indexPath;
            break;
        }
        case MLD_GOAL: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SetGoal" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            _deselectIndexPath = indexPath;
            break;
        }
        case MLD_COLOR: {
            [self performSegueWithIdentifier:@"colorSegue" sender:self];
            break;
        }
        case MLD_ALARM_CLOCK: {
            [self performSegueWithIdentifier:@"alarmSegue" sender:self];
            break;
        }
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == _wearLocationActionSheet) {
        [_service doSetWearLocation:buttonIndex withBlock:^(NSError *error) {
            [[self tableView] deselectRowAtIndexPath:_deselectIndexPath animated:YES];
        }];
    } else if (actionSheet == _sendNotificationActionSheet) {
        [_service doSendNotification:buttonIndex withBlock:^(NSError *error) {
            [[self tableView] deselectRowAtIndexPath:_deselectIndexPath animated:YES];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger goal;
    [[NSScanner scannerWithString:[alertView textFieldAtIndex:0].text] scanInteger: &goal];
    [_service doSetGoal:goal withBlock:^(NSError *error) {
        [[self tableView] deselectRowAtIndexPath:_deselectIndexPath animated:YES];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"colorSegue"]) {
        ColorController *colorController = segue.destinationViewController;
        colorController.service = _service;
    } else if ([segue.identifier isEqual:@"alarmSegue"]) {
        AlarmController *alarmController = segue.destinationViewController;
        alarmController.service = _service;
    }
}

@end
