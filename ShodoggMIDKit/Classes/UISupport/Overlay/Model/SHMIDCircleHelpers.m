//
//  SHMIDCircleHelpers.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/24/16.
//
//

#import "SHMIDCircleHelpers.h"
#include <math.h>

@implementation SHMIDCircleHelpers

+ (double)degreesToRadians:(double)degrees {
    return degrees * M_PI / 180;
}

+ (double)radiansToDegrees:(double)radians {
    return radians * 180 / M_PI;
}

+ (BOOL)isFullCircle:(double)minAngle maxAngle:(double)maxAngle {
    return fmod(maxAngle - minAngle, 360) == 0;
}

+ (BOOL)isFullCircleWithMinimumAngle:(int)minAngle maxAngle:(int)maxAngle {
    return [[self class] isFullCircle:(double)minAngle maxAngle:(double)maxAngle];
}

+ (double)getAngleForIndex:(int)idx max:(int)max minAngle:(double)minAngle maxAngle:(double)maxAngle {
    int spreadAngle   = maxAngle - minAngle;
    double percentage = (double)idx/(double)max;
    return [[self class] degreesToRadians:(minAngle + (percentage * spreadAngle))];
}

+ (CGPoint)getPointForAngle:(double)angle radius:(double)radius {
    CGFloat pX = radius * cos(angle);
    CGFloat pY = radius * sin(angle);
    return CGPointMake(pX, pY);
}

+ (CGPoint)getPointAlongCircle:(int)idx max:(int)max minAngle:(double)minAngle maxAngle:(double)maxAngle radius:(double)radius {
    double angle = [[self class] getAngleForIndex:idx max:max minAngle:minAngle maxAngle:maxAngle];
    return [[self class] getPointForAngle:angle radius:radius];
}

+ (double)distanceBetweenPoints:(CGPoint)pointA pointB:(CGPoint)pointB {
    return sqrt(pow((double)(pointB.x - pointA.x), 2) + pow((double)(pointB.y - pointA.y), 2));
}

@end
