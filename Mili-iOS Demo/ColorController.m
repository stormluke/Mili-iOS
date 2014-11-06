#import "ColorController.h"

@interface ColorController ()

@property (weak, nonatomic) IBOutlet UISlider *red;
@property (weak, nonatomic) IBOutlet UISlider *green;
@property (weak, nonatomic) IBOutlet UISlider *blue;

@end

@implementation ColorController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)okPressed:(UIButton *)sender {
    
    NSUInteger red = (NSUInteger)_red.value;
    NSUInteger green = (NSUInteger)_green.value;
    NSUInteger blue = (NSUInteger)_blue.value;
    
    [_service doSetColorWithRed:red green:green blue:blue blink:YES withBlock:^(NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
