//
//  SHMIDWelcomeViewController.m
//  Pods
//
//  Created by Aamir Khan on 5/13/16.
//
//

#import "SHMIDWelcomeViewController.h"
#import "SHMIDRoundedButton.h"
#import "SHMIDClient.h"

@interface SHMIDWelcomeViewController ()
@property (weak, nonatomic) IBOutlet SHMIDRoundedButton *getStartedButton;
@property (weak, nonatomic) IBOutlet SHMIDRoundedButton *learnMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@end

@implementation SHMIDWelcomeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getStartedButton.midAppearance = SHMIDButtonAppearanceBlue;
    self.learnMoreButton.midAppearance = SHMIDButtonAppearanceBlue;
}

#pragma mark - IBActions

- (IBAction)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getStartedTapped:(id)sender {
    [self dismissAndGoHome];
}

- (IBAction)learnMoreTapped:(id)sender {
    [self dismissAndGoHome];
}

- (void)dismissAndGoHome {
    __weak typeof(self) wself = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [wself completeFirstTimeUserExperience];
    }];
}

- (IBAction)signInTapped:(id)sender {
    __weak typeof (self) wself = self;
    [[SHMIDClient sharedClient] sendToAuthorizationViewFromController:self completionBlock:^(NSError *error) {
        if (!error) {
            [wself completeFirstTimeUserExperience];
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

- (void)completeFirstTimeUserExperience {
    if ([self.delegate respondsToSelector:@selector(didFinishFirstTimeUserExperience:)]) {
        [self.delegate didFinishFirstTimeUserExperience:self];
    }
}

@end