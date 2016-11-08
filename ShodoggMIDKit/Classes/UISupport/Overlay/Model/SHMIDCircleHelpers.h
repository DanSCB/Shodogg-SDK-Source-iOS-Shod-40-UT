//
//  SHMIDCircleHelpers.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 8/24/16.
//
//

#import <Foundation/Foundation.h>

@interface SHMIDCircleHelpers : NSObject

+ (double)degreesToRadians:(double)degrees;
+ (double)radiansToDegrees:(double)radians;
+ (BOOL)isFullCircle:(double)minAngle maxAngle:(double)maxAngle;
+ (BOOL)isFullCircleWithMinimumAngle:(int)minAngle maxAngle:(int)maxAngle;
+ (double)getAngleForIndex:(int)idx max:(int)max minAngle:(double)minAngle maxAngle:(double)maxAngle;
+ (CGPoint)getPointForAngle:(double)angle radius:(double)radius;
+ (CGPoint)getPointAlongCircle:(int)idx max:(int)max minAngle:(double)minAngle maxAngle:(double)maxAngle radius:(double)radius;
+ (double)distanceBetweenPoints:(CGPoint)pointA pointB:(CGPoint)pointB;

@end
