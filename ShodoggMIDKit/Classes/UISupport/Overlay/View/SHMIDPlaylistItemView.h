//
//  SHMIDPlaylistItemView.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/18/16.
//
//

#import <UIKit/UIKit.h>
#import "SHMIDRoundedButton.h"

@interface SHMIDPlaylistItemView : UICollectionViewCell

@property (nonatomic) UILabel *headerLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UIImageView *artworkView;
@property (nonatomic) SHMIDRoundedButton *addToPlaylistButton;
@end
