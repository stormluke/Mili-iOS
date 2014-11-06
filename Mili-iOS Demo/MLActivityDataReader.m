#import "MLActivityDataReader.h"
#import "MLActivityDataFragmentModel.h"
#import "MLActivityDataModel.h"

typedef NS_ENUM(NSInteger, MLADRState) {
    ML_ADR_READY,
    ML_ADR_READING,
    ML_ADR_DONE
};

@interface MLActivityDataReader ()

@property (nonatomic, strong) NSMutableArray *activityDataFragmentList;
@property (nonatomic, strong) MLActivityDataFragmentModel *currentActivityDataFragment;
@property (nonatomic) NSInteger dataIndex;
@property (nonatomic) MLADRState state;

@end

@implementation MLActivityDataReader

- (instancetype)init {
    self = [super init];
    if (self) {
        _activityDataFragmentList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)appendData:(NSData *)data {
    [super appendData:data];
    if (_state == ML_ADR_READY) {
        _dataIndex = 0;
        _currentActivityDataFragment = [[MLActivityDataFragmentModel alloc] init];
        _currentActivityDataFragment.type = [self readInt:1];
        _currentActivityDataFragment.timeStamp = [self readDate];
        _currentActivityDataFragment.duration = [self readInt:2];
        _currentActivityDataFragment.count = [self readInt:2];
        if (_currentActivityDataFragment.type == 0) {
            _currentActivityDataFragment.duration /= 3;
            _currentActivityDataFragment.count /= 3;
        }
        if (_currentActivityDataFragment.count == 0) {
            _state = ML_ADR_DONE;
        } else {
            _state = ML_ADR_READING;
        }
    } else if (_state == ML_ADR_READING) {
        while ([self bytesLeftCount] >= 3) {
            MLActivityDataModel *activityData = [[MLActivityDataModel alloc] init];
            activityData.intensity = [self readInt:1];
            activityData.steps = [self readInt:1];
            activityData.category = [self readInt:1];
            [_currentActivityDataFragment.activityDataList addObject:activityData];
            _dataIndex++;
            if (_dataIndex == _currentActivityDataFragment.count) {
                [_activityDataFragmentList addObject:_currentActivityDataFragment];
                _state = ML_ADR_READY;
                break;
            }
        }
    }
    return self;
}

- (BOOL)isDone {
    return _state == ML_ADR_DONE;
}

- (NSArray *)activityDataFragmentList {
    return _activityDataFragmentList;
}

@end
