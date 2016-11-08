//
//  SHMIDOAuthChooser.h
//  
//
//  Created by Aamir Khan on 12/11/15.
//  Copyright (c) 2015 Shodogg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMIDClient.h"

@interface SHMIDOAuthChooser : UIView

+ (SHMIDOAuthChooser *)chooserWithServicesAndOrder:(NSArray *)order
                           	  parentViewController:(UIViewController<SHMIDClientDelegate> *)topViewController;
@end