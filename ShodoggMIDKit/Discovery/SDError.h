//
//  SDError.h
//  ShodoggSDK
//
//  Created by stepukaa on 11/3/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

@import Foundation;

@interface SDError : NSError

+ (NSError*)wrappedErrorForError:(NSError*)error;

@end
