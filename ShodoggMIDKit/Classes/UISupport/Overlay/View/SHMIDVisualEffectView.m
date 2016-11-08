//
//  SHMIDVisualEffectView.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 6/2/16.
//
//

#import "SHMIDVisualEffectView.h"

@implementation SHMIDVisualEffectView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    return view == self.contentView ? nil : view;
}

@end
