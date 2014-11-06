#import "MLActivityDataFragmentModel.h"

@implementation MLActivityDataFragmentModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _activityDataList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type = %tu, timeStamp = %@, duration = %tu min, count = %tu", _type, _timeStamp, _duration, _count];
}

@end
