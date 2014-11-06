#import <Foundation/Foundation.h>

@interface MLActivityDataFragmentModel : NSObject

@property (nonatomic) NSUInteger type;
@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic) NSUInteger duration;
@property (nonatomic) NSUInteger count;
@property (nonatomic, strong) NSMutableArray *activityDataList;

@end
