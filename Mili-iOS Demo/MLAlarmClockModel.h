#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MLDays) {
    ML_DAYS_ONCE = 0,
    ML_DAYS_MON = 1,
    ML_DAYS_TUE = 1 << 1,
    ML_DAYS_WED = 1 << 2,
    ML_DAYS_THU = 1 << 3,
    ML_DAYS_FRI = 1 << 4,
    ML_DAYS_SAT = 1 << 5,
    ML_DAYS_SUN = 1 << 6,
    ML_DAYS_ALL = 0x1111111
};

@interface MLAlarmClockModel : NSObject

@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL enabled;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSUInteger wakeUpDuration;
@property (nonatomic) NSUInteger days;

- (NSData *)data;

@end
