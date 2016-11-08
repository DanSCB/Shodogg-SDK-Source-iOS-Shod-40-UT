//
//  SHMIDPlaylistCollectionCell.h
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 5/26/16.
//
//

#import <UIKit/UIKit.h>
#import "SHMIDRoundedButton.h"

@interface SHMIDPlaylistCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet SHMIDRoundedButton *addItemButton;
@end
