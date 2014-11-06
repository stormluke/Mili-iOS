#import "MLCentralManager.h"
#import "MiliController.h"
#import "DetailController.h"

static NSString *const kCellId = @"miliCell";
static NSString *const kSegueId = @"miliSegue";

@interface MiliController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *scanButton;

@property (nonatomic, strong) MLCentralManager *manager;
@property (nonatomic, strong) MLMiliService *service;

@end

@implementation MiliController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [MLCentralManager initSharedManagerWithDelegate:self];
}

- (IBAction)scanPressed:(UIBarButtonItem *)sender {
    [_manager removeAllPeripherals];
    [_tableView reloadData];
    _scanButton.enabled = NO;
    [_manager scanForMilisWithBlock:^(MLMiliPeripheral *mili, NSNumber *RSSI, NSError *error) {
        [_tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _manager.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLMiliPeripheral *mili = (MLMiliPeripheral *)[_manager peripheralAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    cell.textLabel.text = mili.name;
    cell.detailTextLabel.text = mili.MACAddress;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_manager stopScan];
    MLMiliPeripheral *mili = (MLMiliPeripheral *)[_manager peripheralAtIndex:indexPath.row];
    MLUserInfoModel *userInfo = [[MLUserInfoModel alloc] init];
    userInfo.uid = 170420175;
    userInfo.gender = ML_GENDER_FEMALE;
    userInfo.age = 23;
    userInfo.height = 168;
    userInfo.weight = 50;
    userInfo.alias = @"anri.okita";
    NSLog(@"WARN: Auth using fake profile.");
    [mili connectWithUserInfo:userInfo block:^(MLMiliService *service, NSError *error) {
        _service = service;
        [self performSegueWithIdentifier:kSegueId sender:self];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        _scanButton.enabled = YES;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueId]) {
        DetailController *detailController = segue.destinationViewController;
        detailController.service = _service;
    }
}

@end
