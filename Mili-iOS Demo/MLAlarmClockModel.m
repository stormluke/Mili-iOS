#import "MLAlarmClockModel.h"
#import "MLMiliService.h"
#import "MLHelper.h"

@implementation MLAlarmClockModel

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeInt:ML_CP_TIMER bytesCount:1];
    [builder writeInt:_index bytesCount:1];
    [builder writeInt:_enabled bytesCount:1];
    [builder writeDate:_date];
    [builder writeInt:_wakeUpDuration bytesCount:1];
    [builder writeInt:_days bytesCount:1];
    return [builder data];
}

@end
