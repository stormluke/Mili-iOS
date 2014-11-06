#import "MLDateTimeModel.h"
#import "MLHelper.h"

@implementation MLDateTimeModel

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        MLDataReader *reader = [[MLDataReader alloc] initWithData:data];
        self.newerDate = [reader readDate];
        self.olderDate = [reader readDate];
    }
    return self;
}

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeDate:self.newerDate];
    [builder writeDate:self.olderDate];
    return [builder data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"newerDate = %@, olderDate = %@", self.newerDate, self.olderDate];
}

@end
