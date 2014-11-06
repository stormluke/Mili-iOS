#import "MLActivityDataModel.h"

@implementation MLActivityDataModel

- (NSString *)description {
    return [NSString stringWithFormat:@"intensity = %tu, steps = %tu, category = %tu", _intensity, _steps, _category];
}

@end
