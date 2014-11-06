#import <UIKit/UIKit.h>
#import "MLMiliService.h"

@interface DetailController : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) MLMiliService *service;

@end
