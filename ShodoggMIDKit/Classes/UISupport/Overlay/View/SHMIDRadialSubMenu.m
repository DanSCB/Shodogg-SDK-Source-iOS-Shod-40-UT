//
//  SHMIDRadialSubMenu.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/23/16.
//
//

#import "SHMIDRadialSubMenu.h"
#import <pop/POP.h>

CGFloat openDelay            = 0.0;
CGFloat closeDealy           = 0.0;
CGFloat closeDuration        = 0.1;
CGFloat openSpringSpeed      = 12.0;
CGFloat openSpringBounciness = 6.0;

NSString * const SHMIDRadialSubMenuOpenAnimation = @"SHMIDRadialSubMenuOpenAnimationKey";
NSString * const SHMIDRadialSubMenuCloseAnimation = @"SHMIDRadialSubMenuCloseAnimationKey";
NSString * const SHMIDRadialSubMenuFadeInAnimation = @"SHMIDRadialSubMenuFadeInAnimationKey";
NSString * const SHMIDRadialSubMenuFadeOutAnimation = @"SHMIDRadialSubMenuFadeOutAnimation";

@interface SHMIDRadialSubMenu() <POPAnimationDelegate>
@property (nonatomic, readwrite) SHMIDRadialSubMenuState state;
@end

@implementation SHMIDRadialSubMenu {
    CGPoint originalPosition;
    CGPoint currentPosition;
}

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        originalPosition = self.center;
        self.state = SHMIDRadialSubMenuClosed;
    }
    return self;
}

- (instancetype)initWithImageView:(UIImageView *)imageView {
    self = [self initWithFrame:imageView.frame];
    if (self) {
        _imageView = imageView;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setState:(SHMIDRadialSubMenuState)state {
    if (_state == state) {return;}
    _state = state;
    switch (state) {
        case SHMIDRadialSubMenuUnHighlighted:
            if ([self.delegate respondsToSelector:@selector(subMenuDidUnHighlight:)]) {
                [self.delegate subMenuDidUnHighlight:self];
            }
            _state = SHMIDRadialSubMenuOpened;
            break;
        case SHMIDRadialSubMenuOpened:
            if ([self.delegate respondsToSelector:@selector(subMenuDidOpen:)]) {
                [self.delegate subMenuDidOpen:self];
            }
            break;
        case SHMIDRadialSubMenuHighlighted:
            if ([self.delegate respondsToSelector:@selector(subMenuDidHighlight:)]) {
                [self.delegate subMenuDidHighlight:self];
            }
            break;
        case SHMIDRadialSubMenuActivated:
            if ([self.delegate respondsToSelector:@selector(subMenuDidActivate:)]) {
                [self.delegate subMenuDidActivate:self];
            }
            break;
        case SHMIDRadialSubMenuClosed:
            if ([self.delegate respondsToSelector:@selector(subMenuDidClose:)]) {
                [self.delegate subMenuDidClose:self];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Interface

- (void)openAtPosition:(CGPoint)position fromPosition:(CGPoint)fromPosition delay:(double)delay {
    self.state = SHMIDRadialSubMenuOpening;
    openDelay = delay;
    currentPosition = position;
    originalPosition = fromPosition;
    self.center = originalPosition;
    [self openAnimation];
}

- (void)openAtPosition:(CGPoint)position fromPosition:(CGPoint)fromPosition {
    [self openAtPosition:position fromPosition:fromPosition delay:0];
}

- (void)close:(double)delay {
    self.state = SHMIDRadialSubMenuClosing;
    closeDealy = delay;
    [self closeAnimation];
}

- (void)close {
    [self close:0];
}

- (void)highlight {
    self.state = SHMIDRadialSubMenuHighlighted;
}

- (void)unhighlight {
    self.state = SHMIDRadialSubMenuUnHighlighted;
}

- (void)activate:(double)delay {
    closeDealy = delay;
    self.state = SHMIDRadialSubMenuActivated;
    [self closeAnimation];
}

- (void)activate {
    [self activate:0];
}

#pragma mark - Animations

- (void)openAnimation {
    POPSpringAnimation *animation;
    if ([self pop_animationForKey:SHMIDRadialSubMenuOpenAnimation] == nil) {
        animation                   = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        animation.name              = SHMIDRadialSubMenuOpenAnimation;
        animation.toValue           = [NSValue valueWithCGPoint:currentPosition];
        animation.beginTime         = CACurrentMediaTime() + openDelay;
        animation.springBounciness  = openSpringBounciness;
        animation.springSpeed       = openSpringSpeed;
        animation.delegate          = self;
        [self pop_addAnimation:animation forKey:SHMIDRadialSubMenuOpenAnimation];
    }
}

- (void)fadeInAnimation {
    NSNumber *toValue = @(1.0);
    POPSpringAnimation *animation;
    POPSpringAnimation *existingAnimation = [self pop_animationForKey:SHMIDRadialSubMenuFadeInAnimation];
    if (existingAnimation) {
        existingAnimation.toValue = toValue;
    } else {
        animation                   = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
        animation.name              = SHMIDRadialSubMenuFadeInAnimation;
        animation.toValue           = toValue;
        animation.springBounciness  = openSpringBounciness;
        animation.springSpeed       = openSpringSpeed;
        animation.delegate          = self;
        [self pop_addAnimation:animation forKey:SHMIDRadialSubMenuFadeInAnimation];
    }
}

- (void)closeAnimation {
    POPBasicAnimation *animation;
    if ([self pop_animationForKey:SHMIDRadialSubMenuCloseAnimation] == nil) {
        animation           = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        animation.name      = SHMIDRadialSubMenuCloseAnimation;
        animation.toValue   = [NSValue valueWithCGPoint:originalPosition];
        animation.beginTime = CACurrentMediaTime() + closeDealy;
        animation.duration  = closeDuration;
        animation.delegate  = self;
        [self pop_addAnimation:animation forKey:SHMIDRadialSubMenuCloseAnimation];
    }
}

- (void)fadeOutAnimation {
    NSNumber *toValue = @(0.0);
    POPBasicAnimation *animation;
    POPBasicAnimation *existingAnimation = [self pop_animationForKey:SHMIDRadialSubMenuFadeOutAnimation];
    if (existingAnimation) {
        existingAnimation.toValue = toValue;
    } else {
        animation                   = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        animation.name              = SHMIDRadialSubMenuFadeOutAnimation;
        animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.toValue           = toValue;
        animation.duration          = closeDuration;
        animation.delegate          = self;
        [self pop_addAnimation:animation forKey:SHMIDRadialSubMenuFadeOutAnimation];
    }
}

- (void)removeAllAnimations {
    [self removeOpenAnimation];
    [self removeCloseAnimation];
}

- (void)removeOpenAnimation {
    [self pop_removeAnimationForKey:SHMIDRadialSubMenuOpenAnimation];
    [self pop_removeAnimationForKey:SHMIDRadialSubMenuFadeInAnimation];
}

- (void)removeCloseAnimation {
    [self pop_removeAnimationForKey:SHMIDRadialSubMenuCloseAnimation];
    [self pop_removeAnimationForKey:SHMIDRadialSubMenuFadeOutAnimation];
}

#pragma mark - POP Animation Delegate

- (void)pop_animationDidStart:(POPAnimation *)anim {
    if ([anim.name isEqualToString:SHMIDRadialSubMenuOpenAnimation]) {
        [self fadeInAnimation];
    } else if ([anim.name isEqualToString:SHMIDRadialSubMenuCloseAnimation]) {
        [self fadeOutAnimation];
    }
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if (!finished) {return;}
    if ([anim.name isEqualToString:SHMIDRadialSubMenuOpenAnimation]) {
        self.state = SHMIDRadialSubMenuOpened;
    } else if ([anim.name isEqualToString:SHMIDRadialSubMenuCloseAnimation]) {
        self.state = SHMIDRadialSubMenuClosed;
        [self removeOpenAnimation];
    } else if ([anim.name isEqualToString:SHMIDRadialSubMenuOpenAnimation]
               && _state == SHMIDRadialSubMenuClosing) {
        [self closeAnimation];
    } else if ([anim.name isEqualToString:SHMIDRadialSubMenuCloseAnimation]
               && _state == SHMIDRadialSubMenuOpening) {
        [self openAnimation];
    }
}

@end