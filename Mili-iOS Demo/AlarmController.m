#import "AlarmController.h"

@interface AlarmController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *days;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;

@end

@implementation AlarmController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)okPressed:(UIButton *)sender {
    NSUInteger days;
    switch (_days.selectedSegmentIndex) {
        case 0:
            days = ML_DAYS_ONCE;
            break;
        case 1:
            days = ML_DAYS_ALL;
            break;
    }
    NSDate *date = _date.date;
    MLAlarmClockModel *alarm = [[MLAlarmClockModel alloc] init];
    alarm.index = 0;
    alarm.enabled = YES;
    alarm.date = date;
    alarm.wakeUpDuration = 0;
    alarm.days = days;
    [_service doSetAlarmClock:alarm withBlock:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
