//
//  SHMIDCastControlsView.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 6/1/16.
//
//

#import <UIKit/UIKit.h>
#import "SHMIDMediaItem.h"

@protocol SHMIDCastControlsViewDelegate <NSObject>
- (void)endCasting;
@end

@interface SHMIDCastControlsView : UIView

@property (weak) id <SHMIDCastControlsViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame mediaItem:(SHMIDMediaItem *)item;

@end
