//
//  SHMIDOAuthChooser.m
//
//
//  Created by Aamir Khan on 12/11/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import "SHMIDOAuthChooser.h"
#import "SHMIDUtilities.h"
#import "SHMIDAuth.h"

#import "SHMIDLoginEmailViewController.h"

@interface SHMIDOAuthChooser()
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic,   weak) UIViewController<SHMIDClientDelegate> *topViewController;
@end

@implementation SHMIDOAuthChooser

+ (SHMIDOAuthChooser *)chooserWithServicesAndOrder:(NSArray *)order
                           parentViewController:(UIViewController<SHMIDClientDelegate> *)topViewController {
    return [[self alloc] initWithFrame:CGRectZero
                       servicesInOrder:order
                  parentViewController:topViewController];
}

- (instancetype)initWithFrame:(CGRect)frame
              servicesInOrder:(NSArray *)order
         parentViewController:(UIViewController<SHMIDClientDelegate> *)topViewController {
    
    self = [super initWithFrame:frame];

    if (self) {
        
        _topViewController = topViewController;
        _buttons = [[NSMutableArray alloc] initWithCapacity:order.count];
        [order enumerateObjectsUsingBlock:^(NSString *type, NSUInteger idx, BOOL *stop) {
            UIButton *button = [self buttonWithAuthType:SHAuthProviderFromString(type)];
            [_buttons addObject:button];
            [self addSubview:button];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Button(250)]"
                                     options:0 metrics:0 views:@{@"Button": button}]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0 constant:0]];
        }];
        
        __block NSString *vPosFormat =  @"";
        NSMutableDictionary *views = [[NSMutableDictionary alloc] init];
        [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            NSString *key = [NSString stringWithFormat:@"Button%x", idx];
            [views setObject:button forKey:key];
            vPosFormat = (idx == 0) ? [NSString stringWithFormat:@"V:|-10-[%@(50)]", key]
                                    : [vPosFormat stringByAppendingFormat:@"-5-[%@(==Button%x)]", key, idx - 1];
        }];
        NSString *finalVPosFormat = [vPosFormat stringByAppendingString:@"-|"];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:finalVPosFormat
                                                                     options:0 metrics:0 views:views]];
    }
    
    return self;
}

- (UIButton *)buttonWithAuthType:(SHAuthProvider)provider {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:15.f];
    [button setTitle:[[self class] titleForAuthProviderButton:provider] forState:UIControlStateNormal];
    [button addTarget:self action:[[self class] selectorForAuthProvider:provider]
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (NSString *)titleForAuthProviderButton:(SHAuthProvider)provider {
    return [NSString stringWithFormat:@"Sign-in with %@", SHAuthProviderAsString(provider).capitalizedString];;
}

+ (SEL)selectorForAuthProvider:(SHAuthProvider)provider {
    SEL selector;
    switch (provider) {
        case SHAuthProviderSalesforce:
        case SHAuthProviderLinkedin:
        case SHAuthProviderTwitter:
        case SHAuthProviderEmail:
            selector = @selector(emailTapped:);
            break;
        case SHAuthProviderFacebook:
            selector = @selector(facebookTapped:);
            break;
        case SHAuthProviderGoogle:
            selector = @selector(googleTapped:);
            break;
    }
    return selector;
}

+ (NSString *)imageNameOAuthType:(SHAuthProvider)type  {
    NSString *imageName;
    switch (type) {
        case SHAuthProviderSalesforce:
        case SHAuthProviderLinkedin:
        case SHAuthProviderTwitter:
        case SHAuthProviderEmail:
            imageName = nil;
            break;
        case SHAuthProviderFacebook:
            imageName = @"media_login_social_fb";
            break;
        case SHAuthProviderGoogle:
            imageName = @"media_login_social_g+";
            break;
    }
    return imageName;
}

#pragma mark - Actions

- (void)facebookTapped:(id)sender {
    [[SHMIDClient sharedClient] loginWithFacebookFromController:_topViewController];
}

- (void)googleTapped:(id)sender {
    [[SHMIDClient sharedClient] loginWithGoogleFromController:_topViewController];
}

- (void)emailTapped:(id)sender {
    [[SHMIDClient sharedClient] loginWithEmailAndPasswordFromController:_topViewController];
}
@end