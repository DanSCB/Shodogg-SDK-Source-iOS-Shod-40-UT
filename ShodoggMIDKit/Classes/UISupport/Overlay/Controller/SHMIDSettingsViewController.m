//
//  SHMIDSettingsViewController.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 4/6/16.
//
//

#import "SHMIDSettingsViewController.h"
#import "SHMIDClient.h"
#import "SHMIDUtilities.h"

@interface SHMIDSettingsViewController ()
@property (nonatomic, strong) SHUser *user;
@property (nonatomic, strong) SHMIDClient *client;
@end

@implementation SHMIDSettingsViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor darkTextColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.client = [SHMIDClient sharedClient];
    if ([_client canResumeSession]) {
        __weak typeof(self) weakself = self;
        [self.client getUserInfoWithCompletion:^(SHUser *user) {
            if (user) weakself.user = user;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself.tableView reloadData];
            });
        }];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    if ([self.delegate respondsToSelector:@selector(didDismissController:)]) {
        [self.delegate didDismissController:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20.f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.f, 4.f, tableView.frame.size.width - 10.f, 16.f)];
    label.contentMode = UIViewContentModeCenter;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont fontWithName:@"Avenir" size:12.f];
    label.text = [SHMIDUtilities bundleVersionString];
    [view addSubview:label];
    return view;
}

static NSString *loginCellIdentifier = @"LoginCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:loginCellIdentifier forIndexPath:indexPath];
    SHMIDClient *client = [SHMIDClient sharedClient];
    if ([client canResumeSession]) {
        cell.textLabel.text = @"Logout";
        NSString *greeting = @"";
        if (self.user) {
            greeting = [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName];
        }
        cell.detailTextLabel.text = greeting;
    } else {
        cell.textLabel.text = @"Login";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[SHMIDClient sharedClient] canResumeSession]) {
        [self logout];
    } else {
        [self gotoLogin];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Logout

- (void)logout {
    __weak typeof(self) weakself = self;
    [self.client logoutWithCompletionBlock:^(NSError *error) {
        weakself.user = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView reloadData];
        });
    }];
}

- (void)gotoLogin {
    __weak typeof(self) weakself = self;
    [self.client sendToAuthorizationViewFromController:self completionBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [error showAsAlertInController:weakself];
            } else {
                [weakself dismiss];
            }
        });
    }];
}

@end