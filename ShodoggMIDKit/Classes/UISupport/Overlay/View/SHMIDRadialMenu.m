//
//  SHMIDRadialMenu.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/24/16.
//
//

#import "SHMIDRadialMenu.h"
#import "SHMIDCircleHelpers.h"
#import <QuartzCore/QuartzCore.h>
#import <pop/POP.h>

CGFloat defaultRadius = 115.0;

@interface SHMIDRadialMenu()<SHMIDRadiaSubMenuDelegate>

@property (nonatomic, readwrite) SHMIDRadialMenuState state;
@property (nonatomic, strong) NSArray *subMenus;

@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat subMenuScale;
@property (nonatomic) CGFloat highlightScale;
@property (nonatomic) CGFloat minHighlightDistance;

@property (nonatomic) int numOfOpeningSubMenus;
@property (nonatomic) int numOfOpenedSubMenus;
@property (nonatomic) int numOfHighlighedSubMenus;

@property (nonatomic) CGPoint position;

@end

@implementation SHMIDRadialMenu

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _subMenus                 = @[];
        _subMenuScale             = 0.75;
        _highlightScale           = 1.15;
        _radiusStep               = 0.0;
        _openDelayStep            = 0.05;
        _closeDelayStep           = 0.035;
        _activatedDelay           = 0.0;
        _minAngle                 = 180;
        _maxAngle                 = 540;
        _highlightDistance        = 0.0;
        _minHighlightDistance     = 0.0;
        _numOfOpeningSubMenus     = 0.0;
        _numOfOpenedSubMenus      = 0.0;
        _numOfHighlighedSubMenus  = 0.0;
        _allowsMultipleHighlights = NO;
        _position                 = CGPointZero;
        _backgroundView           = [UIView new];
    }
    return self;
}

- (instancetype)initWithMenus:(NSArray *)menus {
    return [self initWithMenus:menus radius:defaultRadius];
}

- (instancetype)initWithMenus:(NSArray *)menus radius:(CGFloat)radius {
    if (self = [self initWithFrame:CGRectMake(0, 0, radius*2, radius*2)]) {
        _radius = radius;
        _subMenus = menus;
        for (int i = 0; i < menus.count; i++) {
            SHMIDRadialSubMenu *menu = menus[i];
            menu.delegate = self;
            menu.tag = i;
            [self addSubview:menu];
        }
        [self setup];
    }
    return self;
}

#pragma mark - Configuration

- (void)setState:(SHMIDRadialMenuState)state {
    
    if (_state == state) {return;}
    _state = state;
    
    switch (state) {
        case SHMIDRadialMenuClosed:
            if ([self.delegate respondsToSelector:@selector(radialMenuDidClose)]) {
                [self.delegate radialMenuDidClose];
            }
            break;
        case SHMIDRadialMenuOpened:
        case SHMIDRadialMenuOpening:
        case SHMIDRadialMenuClosing:
        default:
            break;
    }
}

- (void)setup {
    
    self.layer.zPosition = -2;
    self.highlightDistance = _radius * 0.75;
    self.minHighlightDistance =  _radius * 0.25;
    
    self.backgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    _backgroundView.layer.zPosition = -1;
    _backgroundView.frame = CGRectMake(0, 0, _radius * 2, _radius * 2);
    _backgroundView.layer.cornerRadius = _radius;
    _backgroundView.center = self.center;
    _backgroundView.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    
    [self addSubview:_backgroundView];
}

- (void)resetDefaults {
    self.numOfOpenedSubMenus = 0;
    self.numOfOpeningSubMenus = 0;
    self.numOfHighlighedSubMenus = 0;
    for (SHMIDRadialSubMenu *menu in self.subMenus) {
        [menu removeAllAnimations];
    }
}

- (CGFloat)subMenuRadius {
    return _radius * _subMenuScale;
}

- (CGFloat)subMenuHighlightedRadius {
    return _radius * (_subMenuScale * _highlightScale);
}

#pragma mark - Interface

- (void)openAtPosition:(CGPoint)position {
    if (self.subMenus.count == 0) {
        NSLog(@"%s - No submenus to open", __PRETTY_FUNCTION__);
        return;
    }
    if (self.state != SHMIDRadialMenuClosed) {
        NSLog(@"%s - Can only open closed menus", __PRETTY_FUNCTION__);
        return;
    }
    [self resetDefaults];
    self.state = SHMIDRadialMenuOpening;
    self.position = position;
    [self show];
    CGPoint relativePosition = [self convertPoint:self.position fromView:self.superview];
    for (int i = 0; i < self.subMenus.count; i++) {
        SHMIDRadialSubMenu *subMenu = self.subMenus[i];
        CGPoint subMenuPosition = [self getPositionForSubMenu:subMenu];
        double delay = self.openDelayStep * (double)i;
        self.numOfOpeningSubMenus += 1;
        [subMenu openAtPosition:subMenuPosition fromPosition:relativePosition delay:delay];
    }
}

- (void)close {
    if (self.state == SHMIDRadialMenuClosed || self.state == SHMIDRadialMenuClosing) {
        NSLog(@"%s - Menu is already closed/closing", __PRETTY_FUNCTION__);
        return;
    }
    self.state = SHMIDRadialMenuClosing;
    [self.subMenus enumerateObjectsUsingBlock:^(SHMIDRadialSubMenu *subMenu, NSUInteger idx, BOOL * _Nonnull stop) {
        double delay = self.closeDelayStep * (double)idx;
        if (subMenu.state == SHMIDRadialSubMenuHighlighted) {
            double closeDelay = (self.closeDelayStep * (double)self.subMenus.count) + self.activatedDelay;
            [subMenu activate:closeDelay];
        } else {
            [subMenu close:delay];
        }
    }];
}

- (void)moveAtPosition:(CGPoint)position {
    
    //NSLog(@"%s - Position: (%f, %f)", __PRETTY_FUNCTION__, position.x, position.y);
    
    if (self.state != SHMIDRadialMenuOpened
        && self.state != SHMIDRadialMenuHighlighted
        && self.state != SHMIDRadialMenuUnHighlighted) {
        return;
    }
    CGPoint relativePosition = [self convertPoint:position fromView:self.superview];
    double distanceFromCenter = [SHMIDCircleHelpers distanceBetweenPoints:position pointB:self.center];
    
    CGFloat highlightDistance = self.highlightDistance;
    if (self.numOfHighlighedSubMenus > 0) {
        highlightDistance = highlightDistance * self.highlightScale;
    }
    
    NSMutableArray *subMenusByDistance = [NSMutableArray new];
    for (SHMIDRadialSubMenu *subMenu in self.subMenus) {
        double distance = [SHMIDCircleHelpers distanceBetweenPoints:subMenu.center pointB:relativePosition];
        if (distanceFromCenter >= (double)self.minHighlightDistance
            && distance <= (double)highlightDistance) {
            subMenu.distance = distance;
            [subMenusByDistance addObject:subMenu];
        }
        else if (subMenu.state == SHMIDRadialSubMenuHighlighted) {
            [subMenu unhighlight];
        }
    }
    
    if (subMenusByDistance.count == 0) {return;}
    
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey: @"distance" ascending: YES];
    NSArray *subMenuSortedByDistance = [subMenusByDistance sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSMutableArray *shouldHiglight = [NSMutableArray new];
    for (SHMIDRadialSubMenu *subMenu in subMenuSortedByDistance) {
        if (subMenu.state == SHMIDRadialSubMenuHighlighted) {
            //[subMenu unhighlight];
        } else {
            [shouldHiglight addObject:subMenu];
        }
    }
    
    for (SHMIDRadialSubMenu *subMenu in shouldHiglight) {
        [subMenu highlight];
    }
}

- (void)grow {
    [self scaleBackgroundViewBySize:self.highlightScale];
    [self growSubMenus];
}

- (void)shrink {
    [self scaleBackgroundViewBySize:1];
    [self shrinkSubMenus];
}

- (void)show {
    [self scaleBackgroundViewBySize:1];
}

- (void)hide {
    [self scaleBackgroundViewBySize:0];
}

- (void)scaleBackgroundViewBySize:(CGFloat)size {
    POPSpringAnimation *animation = [self.backgroundView pop_animationForKey:@"scale"];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(size, size)];
    if (animation != nil) {
        animation.toValue = toValue;
    } else {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        animation.toValue = toValue;
        [self.backgroundView pop_addAnimation:animation forKey:@"scale"];
    }
}

- (void)growSubMenus {
    for (SHMIDRadialSubMenu *subMenu in self.subMenus) {
        CGPoint subMenuPosition = [self getExpandedPositionForSubMenu:subMenu];
        [self moveSubMenu:subMenu toPosition:subMenuPosition];
    }
}

- (void)shrinkSubMenus {
    for (SHMIDRadialSubMenu *subMenu in self.subMenus) {
        CGPoint subMenuPosition = [self getPositionForSubMenu:subMenu];
        [self moveSubMenu:subMenu toPosition:subMenuPosition];
    }
}

- (void)moveSubMenu:(SHMIDRadialSubMenu *)subMenu toPosition:(CGPoint)position {
    POPSpringAnimation *animation = [subMenu pop_animationForKey:@"expand"];
    NSValue *toValue = [NSValue valueWithCGPoint:position];
    if (animation != nil) {
        animation.toValue = toValue;
    } else {
        animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        animation.toValue = toValue;
        [subMenu pop_addAnimation:animation forKey:@"expand"];
    }
}

#pragma mark - Circle Convenience

- (double)getAngleForSubMenu:(SHMIDRadialSubMenu *)subMenu {
    BOOL fullCircle = [SHMIDCircleHelpers isFullCircleWithMinimumAngle:self.minAngle maxAngle:self.maxAngle];
    int max = fullCircle ? self.subMenus.count : self.subMenus.count - 1;
    return [SHMIDCircleHelpers getAngleForIndex:subMenu.tag max:max minAngle:(double)self.minAngle maxAngle:(double)self.maxAngle];
}

- (CGPoint)getPositionForSubMenu:(SHMIDRadialSubMenu *)subMenu {
    return [self getPostionForSubMenu:subMenu radius:(double)[self subMenuRadius]];
}

- (CGPoint)getExpandedPositionForSubMenu:(SHMIDRadialSubMenu *)subMenu {
    return [self getPostionForSubMenu:subMenu radius:(double)[self subMenuHighlightedRadius]];
}

- (CGPoint)getPostionForSubMenu:(SHMIDRadialSubMenu *)subMenu radius:(double)radius {
    double angle = [self getAngleForSubMenu:subMenu];
    double absRadius = radius + (self.radiusStep * (double)subMenu.tag);
    CGPoint circlePosition = [SHMIDCircleHelpers getPointForAngle:angle radius:absRadius];
    CGPoint relativePosition = CGPointMake(self.position.x + circlePosition.x, self.position.y + circlePosition.y);
    return [self convertPoint:relativePosition fromView:self.superview];
}

#pragma mark - SHMIDRadialSubMenuDelegate

- (void)subMenuDidOpen:(SHMIDRadialSubMenu *)subMenu {
    self.numOfOpenedSubMenus += 1;
    if (self.numOfOpenedSubMenus == self.numOfOpeningSubMenus) {
        self.state = SHMIDRadialMenuOpened;
    }
}

- (void)subMenuDidHighlight:(SHMIDRadialSubMenu *)subMenu {
    if (_state == SHMIDRadialMenuHighlighted) {
        return;
    }
    self.state = SHMIDRadialMenuHighlighted;
    if ([self.delegate respondsToSelector:@selector(radialMenuDidHighlight:)]) {
        [self.delegate radialMenuDidHighlight:subMenu];
    }
    subMenu.transform = CGAffineTransformMakeScale(1.25, 1.25);
    self.numOfHighlighedSubMenus += 1;
    if (_numOfHighlighedSubMenus >= 1) {
        [self grow];
    }
}

- (void)subMenuDidActivate:(SHMIDRadialSubMenu *)subMenu {
    self.state = SHMIDRadialMenuActivated;
    if ([self.delegate respondsToSelector:@selector(radialMenuDidActivate:)]) {
        [self.delegate radialMenuDidActivate:subMenu];
    }
}

- (void)subMenuDidUnHighlight:(SHMIDRadialSubMenu *)subMenu {
    if (_state == SHMIDRadialMenuUnHighlighted) {
        return;
    }
    self.state = SHMIDRadialMenuUnHighlighted;
    if ([self.delegate respondsToSelector:@selector(radialMenuDidUnHighlight:)]) {
        [self.delegate radialMenuDidUnHighlight:subMenu];
    }
    subMenu.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.numOfHighlighedSubMenus -= 1;
    if (_numOfHighlighedSubMenus == 0) {
        [self shrink];
    }
}

- (void)subMenuDidClose:(SHMIDRadialSubMenu *)subMenu {
    self.numOfOpeningSubMenus -= 1;
    self.numOfOpenedSubMenus -= 1;
    if (self.numOfOpenedSubMenus == 0 || self.numOfOpeningSubMenus == 0) {
        [self hide];
        self.state = SHMIDRadialMenuClosed;
    }
}

@end